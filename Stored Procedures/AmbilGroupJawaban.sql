ALTER PROCEDURE [AmbilGroupJawaban]
	@idUser [INT],
	@idSurvei [INT],
	@waktuAwal [DATETIME],
	@waktuAkhir [DATETIME]
AS
	SELECT
		[idGroupJawaban]
	FROM
		[GroupJawaban]
	WHERE
		[idSurvei] = @idSurvei
		AND [timestamp] >= @waktuAwal
		AND [timestamp] <= @waktuAkhir
	ORDER BY
		[idGroupJawaban] ASC