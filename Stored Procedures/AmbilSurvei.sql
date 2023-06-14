ALTER PROCEDURE [GetSurvei]
	@idUser [INT]
AS
	BEGIN TRANSACTION
	BEGIN TRY	
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

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
			0

		ROLLBACK TRANSACTION
	END CATCH