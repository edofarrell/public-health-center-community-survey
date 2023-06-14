ALTER PROCEDURE [Login]
	@username [VARCHAR](20),
	@password [VARCHAR](20)
AS
	DECLARE 
		@passDB [VARCHAR](20),
		@isSuccess [BIT]

	SET 
		@isSuccess = 0

	SELECT
		@passDB = [password]
	FROM
		[User]
	WHERE
		[username] = @username
		AND @passDB = @password

	SET 
		@isSuccess = 1

	SELECT 
		@isSuccess