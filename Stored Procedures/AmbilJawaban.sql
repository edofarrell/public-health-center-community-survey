ALTER PROCEDURE [AmbilJawaban]
	@idGroupJawaban [INT]
AS
	DECLARE @result TABLE
	(
		[idPertanyaan] [INT],
		[jawaban] [VARCHAR](50)
	)

	INSERT INTO @result
	SELECT
		[idPertanyaan],
		CAST([jawabanNumeric] AS [VARCHAR](50))
	FROM
		[JawabanNumeric]
	WHERE
		[idGroupJawaban] = @idGroupJawaban
		AND	[tombstone] = 1

	INSERT INTO @result
	SELECT
		[idPertanyaan],
		CAST([jawabanDate] AS [VARCHAR](50))
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