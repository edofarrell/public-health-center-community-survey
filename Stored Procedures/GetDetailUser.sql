ALTER PROCEDURE [GetDetailUser]
	@idUser INT
AS
	BEGIN TRANSACTION
	BEGIN TRY
		SELECT
			[User].[Username],
			[User].[Password]
		FROM
			[User]
		WHERE
			[User].[idUser] = @idUser

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
			0

		ROLLBACK TRANSACTION
	END CATCH