ALTER PROCEDURE [AmbilPertanyaan]
	@idSurvei [INT]
AS
	SELECT
		[idPertanyaanSurvei],
		[pertanyaan]
	FROM
		[PertanyaanSurvei]
	WHERE
		[idSurvei] = @idSurvei
		AND	[tombstone] = 1
	ORDER BY
		[idPertanyaanSurvei] ASC