ALTER PROCEDURE UbahSurvei
	@idUser INT,
	@idSurvei INT,
	@idGroupJawaban INT,
	@strJawaban VARCHAR(1000)
AS
	DECLARE @tblJawaban TABLE(
		idPertanyaan INT,
		JawabanPertanyaan VARCHAR(1000)
	)

	INSERT INTO @tblJawaban
		SELECT
			CAST([key] AS INT),
			[value]
		FROM
			PARSE(@strJawaban)

	DECLARE cursorJawaban CURSOR
		FOR
		SELECT
			idPertanyaan,
			JawabanPertanyaan
		FROM
			@tblJawaban
	OPEN cursorJawaban
		DECLARE @idPertanyaan INT
		DECLARE @ans VARCHAR(1000)
		FETCH NEXT FROM
			cursorJawaban
		INTO
			@idPertanyaan,
			@ans
		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF ISDATE(@ans) = 1
					BEGIN
						UPDATE 
							JawabanDate
						SET
							tombstone = 0
						WHERE
							idGroupJawaban = @idGroupJawaban
							AND
							idPertanyaan = @idPertanyaan
							AND
							tombstone = 1
					END
				ELSE IF ISNUMERIC(@ans) = 1
					BEGIN
						UPDATE 
							JawabanNumeric
						SET
							tombstone = 0
						WHERE
							idGroupJawaban = @idGroupJawaban
							AND
							idPertanyaan = @idPertanyaan
							AND
							tombstone = 1
					END
				ELSE
					BEGIN
						UPDATE 
							JawabanString
						SET
							tombstone = 0
						WHERE
							idGroupJawaban = @idGroupJawaban
							AND
							idPertanyaan = @idPertanyaan
							AND
							tombstone = 1
					END
				FETCH NEXT FROM 
					cursorJawaban
				INTO
					@idPertanyaan,
					@ans
			END
		CLOSE cursorJawaban
		DEALLOCATE cursorJawaban

		EXEC InsertJawaban @idUser, @idUser, @strJawaban