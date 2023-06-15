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
	@idSurvei [INT],
	@jsonFilter [NVARCHAR](1000),
	@jsonAgregat [NVARCHAR](1000)
AS
	DECLARE
		@queryInsert [NVARCHAR](4000),
		@queryCreateTable [NVARCHAR](4000),
		@queryDropTable [NVARCHAR](2050),
		@query [NVARCHAR](2050),
		@queryId [NVARCHAR](100),
		@queryType [NVARCHAR](500),
		@querySelect [NVARCHAR](200),
		@queryFilter [NVARCHAR](1000),
		@queryAgregat [NVARCHAR](1000),
		@guid [NVARCHAR](2000),
		@currIdPertanyaan [INT],
		@currTipeJawaban [VARCHAR](10),
		@currFilter [VARCHAR](50),
		@lowerBound [VARCHAR](15),
		@upperBound [VARCHAR](15),
		@currAgregat [VARCHAR](10)

	DECLARE @filter TABLE
	(
		[idPertanyaan] [INT],
		[filter] [VARCHAR](50),
		[tipeJawaban] [VARCHAR](10)
	)

	DECLARE @agregat TABLE
	(
		[idPertanyaan] [INT],
		[agregat] [VARCHAR](50),
		[tipeJawaban] [VARCHAR](10)
	)

	CREATE TABLE #jawabanNumeric
	(
		idGroupJawaban [INT],
		idPertanyaan [INT],
		jawaban [FLOAT]
	)

	CREATE TABLE #jawabanDate
	(
		idGroupJawaban [INT],
		idPertanyaan [INT],
		jawaban [DATE]
	)

	CREATE TABLE #jawabanString
	(
		idGroupJawaban [INT],
		idPertanyaan [INT],
		jawaban [VARCHAR](300)
	)

	CREATE TABLE #tableIdPertanyaan
	(
		idPertanyaan [INT],
		tipeJawaban [VARCHAR](10)
	)

	BEGIN TRANSACTION
	BEGIN TRY
		SET @guid = REPLACE(NEWID(), '-', '')
		SET @queryDropTable = 'DROP TABLE 
									##numericPivot_' + @guid
									+ ', ##datePivot_' + @guid
									+ ', ##stringPivot_' + @guid

		INSERT INTO @filter
		SELECT
			[idPertanyaan],
			[filter],
			[tipeJawaban]
		FROM
			ParseFilter(@jsonFilter)

		INSERT INTO @agregat
		SELECT
			[idPertanyaan],
			[agregat],
			[tipeJawaban]
		FROM
			ParseAgregat(@jsonAgregat)

		/* Pivot jawaban numeric */
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

		-- Ambil semua idPertanyaan sebagai nama kolom untuk create global table numeric (dan tipe data)
		SET @queryId = ''
		SET @queryType = ''

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
					+ ' SELECT idGroupJawaban,' + @queryId 
					+ ' FROM #jawabanNumeric' 
					+ ' pivot(MAX(jawaban) FOR idPertanyaan IN (' + @queryId + ')) AS p'

		/* Filter data numeric */
		IF(@jsonFilter IS NOT NULL)
		BEGIN
			SET @queryFilter = ''

			DECLARE cursorFilter CURSOR
			FOR
				SELECT 
					[idPertanyaan],
					[filter]
				FROM
					@filter
				WHERE
					[tipeJawaban] = 'NUMERIC'
			OPEN cursorFilter

			FETCH NEXT FROM
				cursorFilter
			INTO
				@currIdPertanyaan,
				@currFilter

			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				SET @lowerBound = SUBSTRING(@currFilter, 0, CHARINDEX(',', @currFilter))
				SET @upperBound = SUBSTRING(@currFilter, CHARINDEX(',', @currFilter)+1, LEN(@currFilter))
				SET @queryFilter = @queryFilter 
								+ ' AND [' + CAST(@currIdPertanyaan AS NVARCHAR)+ ']' + '>=' + @lowerBound 
								+ ' AND [' + CAST(@currIdPertanyaan AS NVARCHAR)+ ']' + '<=' + @upperBound

				FETCH NEXT FROM
					cursorFilter
				INTO
					@currIdPertanyaan,
					@currFilter
			END

			CLOSE cursorFilter
			DEALLOCATE cursorFilter

			IF(LEN(@queryFilter) > 0)
			BEGIN
				SET @queryFilter = SUBSTRING(@queryFilter, 5, LEN(@queryFilter))
				SET @queryInsert = @queryInsert + ' WHERE ' + @queryFilter
			END
		END

		EXEC SP_EXECUTESQL @queryCreateTable
		EXEC SP_EXECUTESQL @queryInsert

		/* DEBUG */
		--SET @query = 'SELECT * FROM ##numericPivot_' + @guid
		--EXEC SP_EXECUTESQL @query

		/* Pivot jawaban date */
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

		-- Ambil semua idPertanyaan sebagai nama kolom untuk create global table date (dan tipe data)
		SET @queryId = ''
		SET @queryType = ''

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
					+ ' SELECT idGroupJawaban,' + @queryId 
					+ ' FROM #jawabanDate' 
					+ ' pivot(MAX(jawaban) FOR idPertanyaan IN (' + @queryId + ')) AS p'

		/* Filter data date */
		IF(@jsonFilter IS NOT NULL)
		BEGIN
			SET @queryFilter = ''

			DECLARE cursorFilter CURSOR
			FOR
				SELECT 
					[idPertanyaan],
					[filter]
				FROM
					@filter
				WHERE
					[tipeJawaban] = 'DATE'
			OPEN cursorFilter

			FETCH NEXT FROM
				cursorFilter
			INTO
				@currIdPertanyaan,
				@currFilter

			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				SET @lowerBound = SUBSTRING(@currFilter, 0, CHARINDEX(',', @currFilter))
				SET @upperBound = SUBSTRING(@currFilter, CHARINDEX(',', @currFilter)+1, LEN(@currFilter))
				SET @queryFilter = @queryFilter 
								+ ' AND [' + CAST(@currIdPertanyaan AS NVARCHAR)+ ']' + '>=''' + @lowerBound + '''' 
								+ ' AND [' + CAST(@currIdPertanyaan AS NVARCHAR)+ ']' + '<=''' + @upperBound + ''''

				FETCH NEXT FROM
					cursorFilter
				INTO
					@currIdPertanyaan,
					@currFilter
			END

			CLOSE cursorFilter
			DEALLOCATE cursorFilter

			IF(LEN(@queryFilter) > 0)
			BEGIN
				SET @queryFilter = SUBSTRING(@queryFilter, 5, LEN(@queryFilter))
				SET @queryInsert = @queryInsert + ' WHERE ' + @queryFilter
			END
		END

		EXEC SP_EXECUTESQL @queryCreateTable
		EXEC SP_EXECUTESQL @queryInsert

		/* DEBUG */
		--SET @query = 'SELECT * FROM ##datePivot_' + @guid
		--EXEC SP_EXECUTESQL @query

		/* Pivot jawaban string */
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

		-- Ambil semua idPertanyaan sebagai nama kolom untuk create global table string (dan tipe data)
		SET @queryId = ''
		SET @queryType = ''

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
					+ ' SELECT idGroupJawaban,' + @queryId 
					+ ' FROM #jawabanString' 
					+ ' pivot(MAX(jawaban) FOR idPertanyaan IN (' + @queryId + ')) AS p'

		/* Filter data string */
		IF(@jsonFilter IS NOT NULL)
		BEGIN
			SET @queryFilter = ''

			DECLARE cursorFilter CURSOR
			FOR
				SELECT 
					[idPertanyaan],
					[filter]
				FROM
					@filter
				WHERE
					[tipeJawaban] = 'STRING'
			OPEN cursorFilter

			FETCH NEXT FROM
				cursorFilter
			INTO
				@currIdPertanyaan,
				@currFilter

			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				SET @queryFilter = @queryFilter 
								+ ' AND [' + CAST(@currIdPertanyaan AS NVARCHAR)+ ']'
								+ ' LIKE ''%' + @currFilter + '%'''

				FETCH NEXT FROM
					cursorFilter
				INTO
					@currIdPertanyaan,
					@currFilter
			END

			CLOSE cursorFilter
			DEALLOCATE cursorFilter

			IF(LEN(@queryFilter) > 0)
			BEGIN
				SET @queryFilter = SUBSTRING(@queryFilter, 5, LEN(@queryFilter))
				SET @queryInsert = @queryInsert + ' WHERE ' + @queryFilter
			END
		END

		EXEC SP_EXECUTESQL @queryCreateTable
		EXEC SP_EXECUTESQL @queryInsert

		/* DEBUG */
		--SET @query = 'SELECT * FROM ##stringPivot_' + @guid
		--EXEC SP_EXECUTESQL @query

		/* 
			Di titik ini sudah dapat semua jawaban yang sudah dan filter,
			tinggal agregasi dan digabung ke 1 tabel dengan join.

			SELECT statementnya perlu tau semua idPertanyaan untuk diurutkan.
		*/
		IF(@jsonAgregat IS NULL)
		BEGIN
			INSERT INTO #tableIdPertanyaan
			SELECT 
				[result].[idPertanyaan],
				[PertanyaanSurvei].[tipeJawaban]
			FROM
				(
					SELECT DISTINCT([idPertanyaan]) FROM #jawabanNumeric
					UNION SELECT DISTINCT([idPertanyaan]) FROM #jawabanDate
					UNION SELECT DISTINCT([idPertanyaan]) FROM #jawabanString
				)as result
				INNER JOIN [PertanyaanSurvei]
					ON [result].[idPertanyaan] = [PertanyaanSurvei].[idPertanyaanSurvei]

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
			SET @querySelect = ''

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

			SET @query = 'SELECT n.idGroupJawaban,' + @querySelect
		END
		ELSE
		BEGIN
			SET @queryAgregat = ''

			DECLARE cursorAgregat CURSOR
			FOR
				SELECT 
					[idPertanyaan],
					[agregat],
					[tipeJawaban]
				FROM
					@agregat
			OPEN cursorAgregat

			FETCH NEXT FROM
				cursorAgregat
			INTO
				@currIdPertanyaan,
				@currAgregat,
				@currTipeJawaban

			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				IF(@currTipeJawaban = 'NUMERIC')
				BEGIN
					SET @queryAgregat = @queryAgregat + ',' 
									+ @currAgregat + '(n.[' + CAST(@currIdPertanyaan AS VARCHAR) + ']) '
									+ 'AS [' + @currAgregat + ' (' + CAST(@currIdPertanyaan AS VARCHAR) + ')]' 
				END
				ELSE IF(@currTipeJawaban = 'DATE')
				BEGIN
					SET @queryAgregat = @queryAgregat + ',' 
									+ @currAgregat + '(d.[' + CAST(@currIdPertanyaan AS VARCHAR) + ']) '
									+ 'AS [' + @currAgregat + ' (' + CAST(@currIdPertanyaan AS VARCHAR) + ')]' 
				END
				ELSE
				BEGIN
					SET @queryAgregat = @queryAgregat + ',' 
									+ @currAgregat + '(s.[' + CAST(@currIdPertanyaan AS VARCHAR) + ']) '
									+ 'AS [' + @currAgregat + ' (' + CAST(@currIdPertanyaan AS VARCHAR) + ')]' 
				END

				FETCH NEXT FROM
					cursorAgregat
				INTO
					@currIdPertanyaan,
					@currAgregat,
					@currTipeJawaban
			END

			CLOSE cursorAgregat
			DEALLOCATE cursorAgregat

			SET @queryAgregat = SUBSTRING(@queryAgregat, 2, LEN(@queryAgregat))
			SET @query = 'SELECT ' + @queryAgregat
		END

		SET @query = @query +
					' FROM ##numericPivot_' + @guid +' n' +
					' INNER JOIN ##datePivot_' + @guid + ' d ON n.idGroupJawaban=d.idGroupJawaban' +
					' INNER JOIN ##stringPivot_' + @guid + ' s ON n.idGroupJawaban=s.idGroupJawaban'
		
		EXEC SP_EXECUTESQL @query
		EXEC SP_EXECUTESQL @queryDropTable

		/* Print pertanyaan untuk setiap idPertanyaan */
		SELECT
			[idPertanyaanSurvei],
			[pertanyaan]
		FROM
			[PertanyaanSurvei]
		WHERE
			[idSurvei] = @idSurvei

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
			0

		ROLLBACK TRANSACTION
	END CATCH