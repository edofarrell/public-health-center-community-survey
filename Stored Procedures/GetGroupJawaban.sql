/*
	@waktuAwal dan @waktuakhir dapat keduanya bernilai null atau keduanya terisi,
	tidak bisa hanya salah satu
*/
ALTER PROCEDURE [GetGroupJawaban]
	@idSurvei [INT],
	@waktuAwal [DATETIME],
	@waktuAkhir [DATETIME]
AS
	BEGIN TRANSACTION
	BEGIN TRY
		IF(@waktuAwal IS NULL OR @waktuAkhir IS NULL)
		BEGIN
			SELECT
				[idGroupJawaban]
			FROM
				[GroupJawaban]
			WHERE
				[idSurvei] = @idSurvei
			ORDER BY
				[idGroupJawaban] ASC
		END
		ELSE
		BEGIN
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
		END

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
			0

		ROLLBACK TRANSACTION
	END CATCH