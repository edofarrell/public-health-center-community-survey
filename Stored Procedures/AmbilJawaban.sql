ALTER PROCEDURE [MengambilJawaban]
	@idUser [INT],
	@idGroupJawaban [INT],
	@waktuAwal [DATETIME],
	@waktuAkhir [DATETIME]
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
		[idUser] = @idUser
		AND [idGroupJawaban] = @idGroupJawaban
		AND [timestamp] >= @waktuAwal
		AND [timestamp] <= @waktuAkhir
		AND	[tombstone] = 1

	INSERT INTO @result
	SELECT
		[idPertanyaan],
		CAST([jawabanDate] AS [VARCHAR](50))
	FROM
		[JawabanDate]
	WHERE
		[idUser] = @idUser
		AND [idGroupJawaban] = @idGroupJawaban
		AND [timestamp] >= @waktuAwal
		AND [timestamp] <= @waktuAkhir
		AND	[tombstone] = 1

	INSERT INTO @result
	SELECT
		[idPertanyaan],
		[jawabanString]
	FROM
		[JawabanString]
	WHERE
		[idUser] = @idUser
		AND [idGroupJawaban] = @idGroupJawaban
		AND [timestamp] >= @waktuAwal
		AND [timestamp] <= @waktuAkhir
		AND	[tombstone] = 1

	SELECT
		[idPertanyaan],
		[jawaban]
	FROM
		@result