ALTER PROCEDURE [Login]
	@username VARCHAR(50),
	@password VARCHAR(50)
AS
	DECLARE 
		@user VARCHAR(50), 
		@pass VARCHAR(50),
		@status BIT

	SET 
		@status = 0

	SELECT
		@user = [username],
		@pass = [password]
	FROM
		[User]
	WHERE
		[username]=@username AND [password]=@password

	IF(@user IS NOT NULL AND @pass IS NOT NULL)
	BEGIN
		SET @status = 1
	END

	SELECT @status