ALTER PROCEDURE [CreateAkses]
	@idUser [INT],
	@idSurvei [INT]
AS
	DECLARE 
		@isSuccess [BIT]

	SET @isSuccess = 0

	INSERT INTO 
		[MengaksesSurvei]([idUser], [idSurvei])
	VALUES
		(@idUser,@idSurvei)

	SET @isSuccess = 1

	SELECT 
		@isSuccess
