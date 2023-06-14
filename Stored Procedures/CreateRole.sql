ALTER PROCEDURE [CreateRole]
	@namaRole [VARCHAR](20)
AS
	DECLARE 
		@isSuccess [BIT]

	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO 
			[Role]([namaRole])
		VALUES
			(@namaRole)

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
