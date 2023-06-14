ALTER PROCEDURE [AmbilGroupJawaban]
	@idUser [INT],
	@idSurvei [INT],
	@waktuAwal [DATETIME],
	@waktuAkhir [DATETIME]
AS
	BEGIN TRANSACTION
	BEGIN TRY
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
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
			0
	ROLLBACK TRANSACTION
	END CATCH