/*
	Format
	Date: YYYY-MM-DD
*/

ALTER PROCEDURE [UpdateJawaban]
	@idUser [INT],
	@idGroupJawaban [INT],
	@strJawaban [VARCHAR](1000)
AS
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

	DECLARE 
		@currIdPertanyaan [INT],
		@currJawaban [VARCHAR](100)

	FETCH NEXT FROM
		cursorJawaban
	INTO
		@currIdPertanyaan,
		@currJawaban

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		IF(ISNUMERIC(@currJawaban) = 1)
		BEGIN
			UPDATE 
				[JawabanNumeric]
			SET
				[tombstone] = 0
			WHERE
				[idGroupJawaban] = @idGroupJawaban
				AND	[idPertanyaan] = @currIdPertanyaan
				AND	[tombstone] = 1

			INSERT INTO 
				[JawabanNumeric]([jawabanNumeric], [timestamp], [tombstone], [idPertanyaan], [idUser], [idGroupJawaban])
			VALUES
				(@currJawaban, CURRENT_TIMESTAMP, 1, @currIdPertanyaan, @idUser, @idGroupJawaban)
		END
		ELSE IF(ISDATE(@currJawaban) = 1)
		BEGIN
			UPDATE 
				[JawabanDate]
			SET
				[tombstone] = 0
			WHERE
				[idGroupJawaban] = @idGroupJawaban
				AND	[idPertanyaan] = @currIdPertanyaan
				AND	[tombstone] = 1

			INSERT INTO 
				[JawabanDate]([jawabanDate], [timestamp], [tombstone], [idPertanyaan], [idUser], [idGroupJawaban])
			VALUES
				(@currJawaban, CURRENT_TIMESTAMP, 1, @currIdPertanyaan, @idUser, @idGroupJawaban)
		END
		ELSE
		BEGIN
			UPDATE 
				[JawabanString]
			SET
				[tombstone] = 0
			WHERE
				[idGroupJawaban] = @idGroupJawaban
				AND	[idPertanyaan] = @currIdPertanyaan
				AND	[tombstone] = 1

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