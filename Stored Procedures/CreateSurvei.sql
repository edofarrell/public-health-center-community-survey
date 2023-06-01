ALTER PROCEDURE [CreateSurvei]
	@namaSurvei [VARCHAR](50)
AS
	INSERT INTO
		[Survei]([namaSurvei], [timestamp], [tombstone])
	VALUES
		(@namaSurvei, CURRENT_TIMESTAMP, 1)