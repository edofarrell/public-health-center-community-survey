/*
	Format
	Date: YYYY-MM-DD
*/

ALTER PROCEDURE [InsertJawaban]
	@idUser [INT],
	@idSurvei [INT],
	@strJawaban [VARCHAR](1000)
AS
	DECLARE 
		@currIdPertanyaan [INT],
		@currJawaban [VARCHAR](100),
		@currTipeJawaban [VARCHAR](10),
		@idGroupJawaban [INT]

	INSERT INTO 
		[GroupJawaban]([timestamp], [idSurvei])
	VALUES
		(CURRENT_TIMESTAMP, @idSurvei)
	SET 
		@idGroupJawaban = @@IDENTITY

	DECLARE @tabelJawaban TABLE
	(
		[idPertanyaan] [INT],
		[jawaban] [VARCHAR](1000)
	)

	INSERT INTO @tabelJawaban
	SELECT
		CAST([key] AS [INT]),
		[value]
	FROM
		PARSE(@strJawaban)

	DECLARE cursorJawaban CURSOR
	FOR
		SELECT 
			[@tabelJawaban].[idPertanyaan],
			[@tabelJawaban].[jawaban],
			[PertanyaanSurvei].[tipeJawaban]
		FROM 
			[@tabelJawaban]
			INNER JOIN [PertanyaanSurvei]
				ON [@tabelJawaban].[idPertanyaan] = [PertanyaanSurvei].[idPertanyaanSurvei]
	OPEN cursorJawaban

	FETCH NEXT FROM 
		cursorJawaban 
	INTO 
		@currIdPertanyaan,
		@currJawaban,
		@currTipeJawaban

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		IF(@currTipeJawaban = 'NUMERIC')
		BEGIN
			INSERT INTO 
				[JawabanNumeric]([jawabanNumeric], [timestamp], [tombstone], [idPertanyaan], [idUser], [idGroupJawaban])
			VALUES
				(@currJawaban, CURRENT_TIMESTAMP, 1, @currIdPertanyaan, @idUser, @idGroupJawaban)
		END
		ELSE IF(@currTipeJawaban = 'DATE')
		BEGIN
			INSERT INTO 
				[JawabanDate]([jawabanDate], [timestamp], [tombstone], [idPertanyaan], [idUser], [idGroupJawaban])
			VALUES
				(@currJawaban, CURRENT_TIMESTAMP, 1, @currIdPertanyaan, @idUser, @idGroupJawaban)
		END
		ELSE
		BEGIN
			INSERT INTO 
				[JawabanString]([jawabanString], [timestamp], [tombstone], [idPertanyaan], [idUser], [idGroupJawaban])
			VALUES
				(@currJawaban, CURRENT_TIMESTAMP, 1, @currIdPertanyaan, @idUser, @idGroupJawaban)
		END

		FETCH NEXT FROM 
			cursorJawaban 
		INTO 
			@currIdPertanyaan,
			@currJawaban,
			@currTipeJawaban
	END

	CLOSE cursorJawaban
	DEALLOCATE cursorJawaban