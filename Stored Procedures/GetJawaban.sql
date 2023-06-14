ALTER PROCEDURE [GetJawaban]
	@idGroupJawaban [INT]
AS
	DECLARE @result TABLE
	(
		[idPertanyaan] [INT],
		[jawaban] [VARCHAR](300)
	)

	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO @result
		SELECT
			[idPertanyaan],
			CAST([jawabanNumeric] AS [VARCHAR])
		FROM
			[JawabanNumeric]
		WHERE
			[idGroupJawaban] = @idGroupJawaban
			AND	[tombstone] = 1

		INSERT INTO @result
		SELECT
			[idPertanyaan],
			CAST([jawabanDate] AS [VARCHAR])
		FROM
			[JawabanDate]
		WHERE
			[idGroupJawaban] = @idGroupJawaban
			AND	[tombstone] = 1

		INSERT INTO @result
		SELECT
			[idPertanyaan],
			[jawabanString]
		FROM
			[JawabanString]
		WHERE
			[idGroupJawaban] = @idGroupJawaban
			AND	[tombstone] = 1

		SELECT
			[idPertanyaan],
			[jawaban]
		FROM
			@result
		ORDER BY
			[idPertanyaan] ASC

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
			0

		ROLLBACK TRANSACTION
	END CATCH