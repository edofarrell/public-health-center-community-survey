ALTER PROCEDURE [GetUser]
AS
	BEGIN TRANSACTION
	BEGIN TRY
		SELECT
			[User].[username],
			[User].[password],
			[Role].[namaRole]
		FROM
			[User]
			INNER JOIN [Role]
		ON
			[User].[idRole] = [Role].[idRole]

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT
			0

		ROLLBACK TRANSACTION
	END CATCH