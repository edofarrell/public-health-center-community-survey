ALTER PROCEDURE [CreateSurvei]
	@namaSurvei [VARCHAR](50)
AS
	DECLARE
		@isSuccess [BIT]

	INSERT INTO
		[Survei]([namaSurvei], [timestamp], [tombstone])
	VALUES
		(@namaSurvei, CURRENT_TIMESTAMP, 1)

	SET
		@isSuccess = 1

	SELECT
		@isSuccess