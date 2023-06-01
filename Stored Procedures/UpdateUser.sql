CREATE PROCEDURE [UpdateUser]
	@newUsername [VARCHAR](50),
	@newPassword [VARCHAR](50),
	@idUser [INT]
AS
	UPDATE 
		[User]
	SET
		[username] = @newUsername,
		[password] = @newPassword
	WHERE
		[idUser] = @idUser