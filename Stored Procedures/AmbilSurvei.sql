ALTER PROCEDURE [AmbilSurvei]
	@idUser [INT]
AS
	SELECT
		[Survei].[idSurvei],
		[Survei].[namaSurvei]
	FROM
		[Survei]
		INNER JOIN [MengaksesSurvei]
			ON [Survei].[idSurvei] = [MengaksesSurvei].[idSurvei]
	WHERE
		[MengaksesSurvei].[idUser] = @idUser
		AND	[Survei].[tombstone] = 1
	ORDER BY
		[Survei].[idSurvei] ASC