ALTER PROCEDURE [UpdateUser]
	@newUsername [VARCHAR](20),
	@newPassword [VARCHAR](20),
	@idUser [INT]
AS
	UPDATE 
		[User]
	SET
		[username] = @newUsername,
		[password] = @newPassword
	WHERE
		[idUser] = @idUser