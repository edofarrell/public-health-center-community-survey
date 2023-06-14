ALTER PROCEDURE [GetRole]
	@idUser [INT]
AS
	DECLARE @isSuccess [BIT]
	BEGIN TRANSACTION;
	BEGIN TRY
		SELECT
			[Role].[idRole],
			[Role].[namaRole]
		FROM
			[User] INNER JOIN
			[Role]
		ON
			[User].[idRole] = [Role].[idRole]
		WHERE
			[User].[idUser] = @idUser

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET 
			@isSuccess = 0
		SELECT
			@isSuccess
	ROLLBACK TRANSACTION
	END CATCH