/*
	Global Table Variable:
	1. ##numericPivot_{@guid}:
			Fields: idGroupJawaban, [idPertanyaanNumeric1], [idPertanyaanNumeric2], ..., [idPertanyaanNumericN]
	2. ##datePivot_{@guid}:
			Fields: idGroupJawaban, [idPertanyaanDate1], [idPertanyaanDate2], ..., [idPertanyaanDateN]
	3. ##stringPivot_{@guid}:
			Fields: idGroupJawaban, [idPertanyaanString1], [idPertanyaanString2], ..., [idPertanyaanStringN]
*/

ALTER PROCEDURE [GetPivotSurvei]
	@idSurvei [INT]
AS
	DECLARE
		@queryInsert [NVARCHAR](4000),
		@queryCreateTable [NVARCHAR](4000),
		@queryDropTable [NVARCHAR](2050),
		@query [NVARCHAR](2050),
		@queryId [NVARCHAR](100),
		@queryType [NVARCHAR](500),
		@querySelect [NVARCHAR](200),
		@guid [NVARCHAR](2000),
		@currIdPertanyaan [INT],
		@currTipeJawaban [VARCHAR](10)

	SET @guid = REPLACE(NEWID(), '-', '')
	SET @queryInsert = ''
	SET @queryCreateTable = ''
	SET @queryDropTable = 'DROP TABLE ##numericPivot_' + @guid
							+ ', ##datePivot_' + @guid
							+ ', ##stringPivot_' + @guid
	SET @queryId = ''
	SET @queryType = ''
	SET @querySelect = ''

	-- Pivot + Agregasi dan Filter semua jawaban numeric
	CREATE TABLE #jawabanNumeric
	(
		idGroupJawaban [INT],
		idPertanyaan [INT],
		jawaban [FLOAT]
	)

	INSERT INTO #jawabanNumeric
	SELECT
		[JawabanNumeric].[idGroupJawaban],
		[PertanyaanSurvei].[idPertanyaanSurvei],
		[JawabanNumeric].[jawabanNumeric]
	FROM
		[JawabanNumeric]
		RIGHT OUTER JOIN [PertanyaanSurvei]
			ON [JawabanNumeric].[idPertanyaan] = [PertanyaanSurvei].[idPertanyaanSurvei]
	WHERE 
		[PertanyaanSurvei].[idSurvei] = @idSurvei
		AND [PertanyaanSurvei].[tipeJawaban] = 'NUMERIC'
		AND ([JawabanNumeric].[tombstone] = 1 OR [JawabanNumeric].[tombstone] iS NULL)

	DECLARE cursorIdNumeric CURSOR
	FOR
		SELECT
			DISTINCT(idPertanyaan)
		FROM
			#jawabanNumeric
		ORDER BY
			idPertanyaan
	OPEN cursorIdNumeric

	FETCH NEXT FROM 
		cursorIdNumeric
	INTO
		@currIdPertanyaan

	-- Ambil semua idPertanyaan sebagai nama untuk create global table numeric + tipe data
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		SET @queryId = @queryId + ',[' + CAST(@currIdPertanyaan AS NVARCHAR)+']'
		SET @queryType = @queryType + ',[' + CAST(@currIdPertanyaan AS NVARCHAR) +'] ' + 'FLOAT'

		FETCH NEXT FROM 
			cursorIdNumeric
		INTO
			@currIdPertanyaan
	END

	CLOSE cursorIdNumeric
	DEALLOCATE cursorIdNumeric

	IF(LEN(@queryId) > 0)
	BEGIN
		SET @queryId = SUBSTRING(@queryId, 2, LEN(@queryId))
	END

	IF(LEN(@queryType) > 0)
	BEGIN
		SET @queryType = SUBSTRING(@queryType, 2, LEN(@queryType))
	END

	SET @queryCreateTable = 'CREATE TABLE ##numericPivot_' + @guid + ' (idGroupJawaban INT,' + @queryType + ')'
	SET @queryInsert = 'INSERT INTO ##numericPivot_' + @guid
				+ ' SELECT idGroupJawaban,' + @queryId + ' FROM #jawabanNumeric' 
				+ ' pivot(MAX(jawaban) FOR idPertanyaan IN (' + @queryId + ')) AS p'

	EXEC SP_EXECUTESQL @queryCreateTable
	EXEC SP_EXECUTESQL @queryInsert

	--SET @query = 'SELECT * FROM ##numericPivot_' + @guid
	--EXEC SP_EXECUTESQL @query

	/* Agregasi + Filter data numeric */

	
	-- Pivot + Agregasi dan Filter semua jawaban date
	CREATE TABLE #jawabanDate
	(
		idGroupJawaban [INT],
		idPertanyaan [INT],
		jawaban [DATE]
	)

	INSERT INTO #jawabanDate
	SELECT
		[JawabanDate].[idGroupJawaban],
		[PertanyaanSurvei].[idPertanyaanSurvei],
		[JawabanDate].[jawabanDate]
	FROM
		[JawabanDate]
		RIGHT OUTER JOIN [PertanyaanSurvei]
			ON [JawabanDate].[idPertanyaan] = [PertanyaanSurvei].[idPertanyaanSurvei]
	WHERE 
		[PertanyaanSurvei].[idSurvei] = @idSurvei
		AND [PertanyaanSurvei].[tipeJawaban] = 'DATE'
		AND ([JawabanDate].[tombstone] = 1 OR [JawabanDate].[tombstone] iS NULL)

	SET @queryId = ''
	SET @queryType = ''

	DECLARE cursorIdDate CURSOR
	FOR
		SELECT
			DISTINCT(idPertanyaan)
		FROM
			#jawabanDate
		ORDER BY
			idPertanyaan
	OPEN cursorIdDate

	FETCH NEXT FROM 
		cursorIdDate
	INTO
		@currIdPertanyaan

	-- Ambil semua idPertanyaan sebagai nama untuk create global table date + tipe data
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		SET @queryId = @queryId + ',[' + CAST(@currIdPertanyaan AS NVARCHAR)+']'
		SET @queryType = @queryType + ',[' + CAST(@currIdPertanyaan AS NVARCHAR) +'] ' + 'DATE'

		FETCH NEXT FROM 
			cursorIdDate
		INTO
			@currIdPertanyaan
	END

	CLOSE cursorIdDate
	DEALLOCATE cursorIdDate

	IF(LEN(@queryId) > 0)
	BEGIN
		SET @queryId = SUBSTRING(@queryId, 2, LEN(@queryId))
	END

	IF(LEN(@queryType) > 0)
	BEGIN
		SET @queryType = SUBSTRING(@queryType, 2, LEN(@queryType))
	END

	SET @queryCreateTable = 'CREATE TABLE ##datePivot_' + @guid + ' (idGroupJawaban INT,' + @queryType + ')'
	SET @queryInsert = 'INSERT INTO ##datePivot_' + @guid
				+ ' SELECT idGroupJawaban,' + @queryId + ' FROM #jawabanDate' 
				+ ' pivot(MAX(jawaban) FOR idPertanyaan IN (' + @queryId + ')) AS p'

	EXEC SP_EXECUTESQL @queryCreateTable
	EXEC SP_EXECUTESQL @queryInsert

	--SET @query = 'SELECT * FROM ##datePivot_' + @guid
	--EXEC SP_EXECUTESQL @query

	/* Agregasi + Filter data date */


	-- Pivot + Agregasi dan Filter semua jawaban string
	CREATE TABLE #jawabanString
	(
		idGroupJawaban [INT],
		idPertanyaan [INT],
		jawaban [VARCHAR](300)
	)

	INSERT INTO #jawabanString
	SELECT 
		[JawabanString].[idGroupJawaban],
		[PertanyaanSurvei].[idPertanyaanSurvei],
		[JawabanString].[jawabanString]
	FROM
		[JawabanString]
		RIGHT OUTER JOIN [PertanyaanSurvei]
			ON [JawabanString].[idPertanyaan] = [PertanyaanSurvei].[idPertanyaanSurvei]
	WHERE 
		[PertanyaanSurvei].[idSurvei] = @idSurvei
		AND [PertanyaanSurvei].[tipeJawaban] = 'STRING'
		AND ([JawabanString].[tombstone] = 1 OR [JawabanString].[tombstone] iS NULL)

	SET @queryId = ''
	SET @queryType = ''

	DECLARE cursorIdString CURSOR
	FOR
		SELECT
			DISTINCT(idPertanyaan)
		FROM
			#jawabanString
		ORDER BY
			idPertanyaan
	OPEN cursorIdString

	FETCH NEXT FROM 
		cursorIdString
	INTO
		@currIdPertanyaan

	-- Ambil semua idPertanyaan sebagai nama untuk create global table sring + tipe data
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		SET @queryId = @queryId + ',[' + CAST(@currIdPertanyaan AS NVARCHAR)+']'
		SET @queryType = @queryType + ',[' + CAST(@currIdPertanyaan AS NVARCHAR) +'] ' + 'VARCHAR(300)'

		FETCH NEXT FROM 
			cursorIdString
		INTO
			@currIdPertanyaan
	END

	CLOSE cursorIdString
	DEALLOCATE cursorIdString

	IF(LEN(@queryId) > 0)
	BEGIN
		SET @queryId = SUBSTRING(@queryId, 2, LEN(@queryId))
	END

	IF(LEN(@queryType) > 0)
	BEGIN
		SET @queryType = SUBSTRING(@queryType, 2, LEN(@queryType))
	END

	SET @queryCreateTable = 'CREATE TABLE ##stringPivot_' + @guid + ' (idGroupJawaban INT,' + @queryType + ')'
	SET @queryInsert = 'INSERT INTO ##stringPivot_' + @guid
				+ ' SELECT idGroupJawaban,' + @queryId + ' FROM #jawabanString' 
				+ ' pivot(MAX(jawaban) FOR idPertanyaan IN (' + @queryId + ')) AS p'

	EXEC SP_EXECUTESQL @queryCreateTable
	EXEC SP_EXECUTESQL @queryInsert

	--SET @query = 'SELECT * FROM ##stringPivot_' + @guid
	--EXEC SP_EXECUTESQL @query

	/* Agregasi + Filter data string */


	/* 
		Di titik ini sudah dapat semua jawaban yang sudah diagregasi dan filter,
		tinggal digabung ke 1 tabel dengan join.

		Tapi di SELECT statementnya perlu tau semua idPertanyaan untuk diurutkan.
	*/

	CREATE TABLE #tableIdPertanyaan
	(
		idPertanyaan [INT],
		tipeJawaban [VARCHAR](10)
	)

	INSERT INTO #tableIdPertanyaan
	SELECT 
		result.idPertanyaan,
		PertanyaanSurvei.tipeJawaban
	FROM
		(
			SELECT DISTINCT(idPertanyaan) FROM #jawabanNumeric
			UNION
			SELECT DISTINCT(idPertanyaan) FROM #jawabanDate
			UNION
			SELECT DISTINCT(idPertanyaan) FROM #jawabanString
		)as result
		INNER JOIN [PertanyaanSurvei]
			ON result.idPertanyaan = PertanyaanSurvei.idPertanyaanSurvei

	DECLARE cursorIdPertanyaan CURSOR
	FOR
		SELECT
			idPertanyaan,
			tipeJawaban
		FROM
			#tableIdPertanyaan
		ORDER BY
			idPertanyaan
	OPEN cursorIdPertanyaan

	FETCH NEXT FROM 
		cursorIdPertanyaan
	INTO
		@currIdPertanyaan,
		@currTipeJawaban

	-- Ambil semua idPertanyaan untuk di SELECT
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		IF(@currTipeJawaban = 'NUMERIC')
		BEGIN
			SET @querySelect = @querySelect + ',n.[' + CAST(@currIdPertanyaan AS VARCHAR) + ']'
		END
		ELSE IF(@currTipeJawaban = 'DATE')
		BEGIN
			SET @querySelect = @querySelect + ',d.[' + CAST(@currIdPertanyaan AS VARCHAR) + ']'
		END
		ELSE
		BEGIN
			SET @querySelect = @querySelect + ',s.[' + CAST(@currIdPertanyaan AS VARCHAR) + ']'
		END

		FETCH NEXT FROM 
			cursorIdPertanyaan
		INTO
			@currIdPertanyaan,
			@currTipeJawaban
	END

	CLOSE cursorIdPertanyaan
	DEALLOCATE cursorIdPertanyaan

	IF(LEN(@querySelect) > 0)
	BEGIN
		SET @querySelect = SUBSTRING(@querySelect, 2, LEN(@querySelect))
	END

	SET @query = 'SELECT n.idGroupJawaban,' + @querySelect + 
				' FROM ##numericPivot_' + @guid +' n' +
				' INNER JOIN ##datePivot_' + @guid + ' d ON n.idGroupJawaban=d.idGroupJawaban' +
				' INNER JOIN ##stringPivot_' + @guid + ' s ON n.idGroupJawaban=s.idGroupJawaban'
	EXEC SP_EXECUTESQL @query

	EXEC SP_EXECUTESQL @queryDropTable