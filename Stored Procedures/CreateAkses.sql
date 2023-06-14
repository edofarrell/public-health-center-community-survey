ALTER PROCEDURE [CreateAkses]
	@idUser [INT],
	@idSurvei [INT]
AS
	DECLARE 
		@isSuccess [BIT]

	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO 
			[MengaksesSurvei]([idUser], [idSurvei])
		VALUES
			(@idUser, @idSurvei)

		SET @isSuccess = 1

		SELECT 
			@isSuccess

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET @isSuccess = 0

		SELECT 
			@isSuccess

		ROLLBACK TRANSACTION
	END CATCH