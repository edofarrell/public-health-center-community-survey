ALTER PROCEDURE HistoryJawaban
	@idGroupJawaban [INT]
AS

	DECLARE @result TABLE(
		[jawaban] [VARCHAR](100),
		[timestamp] [DATETIME],
		[tombstone] [BIT],
		[idPertanyaan] [INT],
		[idUser] [INT]
	)

	INSERT INTO @result
	SELECT
		CONVERT(VARCHAR,[JawabanDate].[jawabanDate]),
		[JawabanDate].[timestamp],
		[JawabanDate].[tombstone],
		[JawabanDate].[idPertanyaan],
		[JawabanDate].[idUser]
	FROM
		JawabanDate
	WHERE
		[JawabanDate].[idGroupJawaban] = @idGroupJawaban

	INSERT INTO @result
	SELECT
		CONVERT(VARCHAR,[JawabanNumeric].[jawabanNumeric]),
		[JawabanNumeric].[timestamp],
		[JawabanNumeric].[tombstone],
		[JawabanNumeric].[idPertanyaan],
		[JawabanNumeric].[idUser]
	FROM
		JawabanNumeric
	WHERE
		[JawabanNumeric].[idGroupJawaban] = @idGroupJawaban
	
	INSERT INTO @result
	SELECT
		CONVERT(VARCHAR,[JawabanString].[jawabanString]),
		[JawabanString].[timestamp],
		[JawabanString].[tombstone],
		[JawabanString].[idPertanyaan],
		[JawabanString].[idUser]
	FROM
		JawabanString
	WHERE
		[JawabanString].[idGroupJawaban] = @idGroupJawaban

	SELECT
		[@result].[idPertanyaan],
		[@result].[jawaban],
		[@result].[timestamp],
		[@result].[tombstone],
		[@result].[idUser]
	FROM
		@result
	ORDER BY
		[@result].[idPertanyaan]