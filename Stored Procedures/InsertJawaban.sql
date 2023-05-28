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
			[idPertanyaan],
			[jawaban]
		FROM 
			@tabelJawaban
	OPEN cursorJawaban

	FETCH NEXT FROM 
		cursorJawaban 
	INTO 
		@currIdPertanyaan,
		@currJawaban

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		IF(ISNUMERIC(@currJawaban) = 1)
		BEGIN
			INSERT INTO 
				[JawabanNumeric]([jawabanNumeric], [timestamp], [tombstone], [idPertanyaan], [idUser], [idGroupJawaban])
			VALUES
				(@currJawaban, CURRENT_TIMESTAMP, 1, @currIdPertanyaan, @idUser, @idGroupJawaban)
		END
		ELSE IF(ISDATE(@currJawaban) = 1)
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
			@currJawaban
	END

	CLOSE cursorJawaban
	DEALLOCATE cursorJawaban