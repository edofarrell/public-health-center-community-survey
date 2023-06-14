ALTER PROCEDURE [DeleteJawaban]
	@idGroupJawaban [INT],
	@idPertanyaan [INT]
AS
	DECLARE
		@tipeJawaban [VARCHAR](10),
		@isSuccess [BIT]

	BEGIN TRANSACTION
	BEGIN TRY
		SELECT
			@tipeJawaban = [PertanyaanSurvei].[tipeJawaban]
		FROM
			[GroupJawaban]
				INNER JOIN 
						[PertanyaanSurvei]
						ON [GroupJawaban].[idSurvei] = [PertanyaanSurvei].[idSurvei]
		WHERE
			[GroupJawaban].[idGroupJawaban] = @idGroupJawaban
			AND [PertanyaanSurvei].[idPertanyaanSurvei] = @idPertanyaan

		IF (@tipeJawaban = 'NUMERIC')
		BEGIN
			UPDATE 
				[JawabanNumeric]
			SET
				tombstone = 0
			WHERE
				[JawabanNumeric].[idGroupJawaban] = @idGroupJawaban
				AND
				[JawabanNumeric].[idPertanyaan] = @idPertanyaan
				AND
				[JawabanNumeric].[tombstone] = 1
		END
		ELSE IF (@tipeJawaban = 'DATE')
		BEGIN
			UPDATE 
				[JawabanDate]
			SET
				tombstone = 0
			WHERE
				[JawabanDate].[idGroupJawaban] = @idGroupJawaban
				AND
				[JawabanDate].[idPertanyaan] = @idPertanyaan
				AND
				[JawabanDate].[tombstone] = 1
		END
		ELSE
		BEGIN
			UPDATE 
				[JawabanString]
			SET
				tombstone = 0
			WHERE
				[JawabanString].[idGroupJawaban] = @idGroupJawaban
				AND
				[JawabanString].[idPertanyaan] = @idPertanyaan
				AND
				[JawabanString].[tombstone] = 1
		END

		SET
			@isSuccess = 1

		SELECT
			@isSuccess
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET
			@isSuccess = 0

		SELECT
			@isSuccess
	ROLLBACK TRANSACTION
	END CATCH
	