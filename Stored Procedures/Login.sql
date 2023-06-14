ALTER PROCEDURE [Login]
	@username [VARCHAR](20),
	@password [VARCHAR](20)
AS
	DECLARE 
		@isSuccess [BIT],
		@idUserCounter [INT]

	BEGIN TRANSACTION
	BEGIN TRY
		SELECT
			@idUserCounter = COUNT([idUser])
		FROM
			[User]
		WHERE
			[username] = @username
			AND [password] = @password
		
		IF(@idUserCounter <> 0)
		BEGIN
			SET @isSuccess = 1
		END
		ELSE
		BEGIN
			SET @isSuccess = 0
		END

		SELECT
			@isSuccess

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET @isSuccess = 0

		SELECT
			@isSuccess

		ROLLBACK TRANSACTION
	END CATCH