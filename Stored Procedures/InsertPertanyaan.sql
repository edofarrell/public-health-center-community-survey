ALTER PROCEDURE InsertPertanyaan
	@idSurvei INT,
	@pertanyaan VARCHAR(500)
AS

DECLARE @tabelPertanyaan TABLE(
	idPertanyaan INT,
	pertanyaan VARCHAR(100),
	tipeJawaban VARCHAR(10)
)
INSERT INTO @tabelPertanyaan
SELECT
	*
FROM
	ParsePertanyaan(@pertanyaan)

DECLARE @currIdPertanyaan INT
DECLARE @currPertanyaan VARCHAR(100)
DECLARE @currTipeJawaban VARCHAR(10)

DECLARE cursorPertanyaan CURSOR
FOR
	SELECT
		idPertanyaan,
		pertanyaan,
		tipeJawaban
	FROM
		@tabelPertanyaan
OPEN cursorPertanyaan

FETCH NEXT FROM cursorPertanyaan
INTO
	@currIdPertanyaan,
	@currPertanyaan,
	@currTipeJawaban

WHILE(@@FETCH_STATUS=0)
BEGIN
	INSERT INTO [PertanyaanSurvei](pertanyaan,tipeJawaban,[timestamp],tombstone,idSurvei)
	VALUES(@currPertanyaan,@currTipeJawaban,CURRENT_TIMESTAMP,1,@idSurvei)

	FETCH NEXT FROM cursorPertanyaan
	INTO
		@currIdPertanyaan,
		@currPertanyaan,
		@currTipeJawaban
END

CLOSE cursorPertanyaan
DEALLOCATE cursorPertanyaan
