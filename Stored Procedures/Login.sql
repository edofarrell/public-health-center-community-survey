ALTER PROCEDURE [Login]
	@username [VARCHAR](20),
	@password [VARCHAR](20)
AS
	DECLARE 
		@isSuccess [BIT]

	SET 
		@isSuccess = 0

	SELECT
		
	FROM
		[User]
	WHERE
		[username] = @username
		AND [password] = @password

	SET 
		@isSuccess = 1

	SELECT 
		@isSuccess