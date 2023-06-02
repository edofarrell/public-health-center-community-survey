ALTER PROCEDURE [CreateUser]
	@username [VARCHAR](20),
	@password [VARCHAR](20),
	@idRole [INT]
AS
	INSERT INTO 
		[User]([username], [password], [idRole])
	VALUES
		(@username, @password, @idRole)