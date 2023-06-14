ALTER PROCEDURE [CreateSurvei]
	@namaSurvei [VARCHAR](50)
AS
	DECLARE
		@isSuccess [BIT]
	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO
			[Survei]([namaSurvei], [timestamp], [tombstone])
		VALUES
			(@namaSurvei, CURRENT_TIMESTAMP, 1)

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