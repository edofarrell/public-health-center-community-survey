ALTER PROCEDURE [AmbilPertanyaan]
	@idSurvei [INT]
AS
	BEGIN TRANSACTION
	BEGIN TRY
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
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
			0
	ROLLBACK TRANSACTION
	END CATCH