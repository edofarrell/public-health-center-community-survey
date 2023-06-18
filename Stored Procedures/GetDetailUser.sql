ALTER PROCEDURE [GetDetailUser]
	@idUser INT
AS
	BEGIN TRANSACTION
	BEGIN TRY
		SELECT
			[User].[Username],
			[User].[Password],
			[Role].[namaRole]
		FROM
			[User]
			INNER JOIN [Role]
				ON [User].[idRole] = [Role].[idRole]
		WHERE
			[User].[idUser] = @idUser

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
			0

		ROLLBACK TRANSACTION
	END CATCH