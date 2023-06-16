CREATE PROCEDURE [GetDetailUser]
AS
	BEGIN TRANSACTION
	BEGIN TRY
		SELECT
			[User].[Username],
			[User].[Password],
			[Role].[NamaRole]
		FROM
			[User]
			INNER JOIN [Role]
			ON [User].[idRole] = [Role].[idRole]

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
			0
		ROLLBACK TRANSACTION
	END CATCH