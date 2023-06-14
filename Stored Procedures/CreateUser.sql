ALTER PROCEDURE [CreateUser]
	@username [VARCHAR](20),
	@password [VARCHAR](20),
	@idRole [INT]
AS
	DECLARE
		@isSuccess [BIT]

	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO 
			[User]([username], [password], [idRole])
		VALUES
			(@username, @password, @idRole)

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
	