ALTER PROCEDURE [CreateUser]
	@username [VARCHAR](20),
	@password [VARCHAR](20),
	@idRole [INT]
AS
	DECLARE
		@isSuccess [BIT]

	INSERT INTO 
		[User]([username], [password], [idRole])
	VALUES
		(@username, @password, @idRole)

	SET
		@isSuccess = 1

	SELECT
		@isSuccess