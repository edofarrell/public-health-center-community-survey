/*
	Date : YYYY-MM-DD
*/
CREATE PROCEDURE InsertJawaban
	@idUser INT,
	@idSurvei INT,
	@jawabanJSON VARCHAR(1000)
AS

DECLARE @tabelJawaban TABLE(
	[key] INT,
	[value] VARCHAR(100)
)
INSERT INTO @tabelJawaban
SELECT
	CAST([key] AS INT),
	[value]
FROM
	PARSE(@jawabanJSON)

DECLARE curJawaban CURSOR
FOR
SELECT [key],[value] FROM @tabelJawaban

DECLARE @idPertanyaan INT
DECLARE @jawabanTemp VARCHAR(100)
DECLARE @indexGroupJawaban INT

INSERT INTO GroupJawaban([timestamp],idSurvei)
VALUES(CURRENT_TIMESTAMP,@idSurvei)
SET @indexGroupJawaban = @@IDENTITY

OPEN curJawaban

FETCH NEXT FROM curJawaban INTO @idPertanyaan,@jawabanTemp
WHILE(@@FETCH_STATUS=0)
BEGIN
	IF(ISNUMERIC(@jawabanTemp)=1)
	BEGIN
		INSERT INTO [JawabanNumeric](jawabanNumeric,[timestamp],tombstone,idPertanyaan,idUser,idGroupJawaban)
		VALUES(@jawabanTemp,CURRENT_TIMESTAMP,1,@idPertanyaan,@idUser,@indexGroupJawaban)
	END
	ELSE IF(ISDATE(@jawabanTemp)=1)
	BEGIN
		INSERT INTO [JawabanDate](jawabanDate,[timestamp],tombstone,idPertanyaan,idUser,idGroupJawaban)
		VALUES(@jawabanTemp,CURRENT_TIMESTAMP,1,@idPertanyaan,@idUser,@indexGroupJawaban)
	END
	ELSE
	BEGIN
		INSERT INTO [JawabanString](jawabanString,[timestamp],tombstone,idPertanyaan,idUser,idGroupJawaban)
		VALUES(@jawabanTemp,CURRENT_TIMESTAMP,1,@idPertanyaan,@idUser,@indexGroupJawaban)
	END
	FETCH NEXT FROM curJawaban INTO @idPertanyaan,@jawabanTemp
END

CLOSE curJawaban
DEALLOCATE curJawaban