ALTER PROCEDURE [CreateRole]
	@namaRole [VARCHAR](20)
AS
	DECLARE 
		@isSuccess [BIT]

	SET @isSuccess = 0

	INSERT INTO 
		[Role]([namaRole])
	VALUES
		(@namaRole)

	SET @isSuccess = 1

	SELECT 
		@isSuccess
