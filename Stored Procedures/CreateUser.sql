ALTER PROCEDURE CreateUser
	@username VARCHAR(50),
	@password VARCHAR(50),
	@idRole INT
AS

INSERT INTO [User](username,[password],idRole)
VALUES(@username,@password,@idRole)