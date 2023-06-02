ALTER PROCEDURE [UpdateUser]
	@newUsername [VARCHAR](20),
	@newPassword [VARCHAR](20),
	@idUser [INT]
AS
	DECLARE
		@isSuccess [BIT]

	UPDATE 
		[User]
	SET
		[username] = @newUsername,
		[password] = @newPassword
	WHERE
		[idUser] = @idUser

	SET
		@isSuccess = 1

	SELECT
		@isSuccess