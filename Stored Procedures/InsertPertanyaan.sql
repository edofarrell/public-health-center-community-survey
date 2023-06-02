ALTER PROCEDURE [InsertPertanyaan]
	@idSurvei [INT],
	@jsonPertanyaan [NVARCHAR](2150)
AS
	DECLARE @tabelPertanyaan TABLE
	(
		[pertanyaan] [VARCHAR](150),
		[tipeJawaban] [VARCHAR](10)
	)

	INSERT INTO @tabelPertanyaan
	SELECT
		[pertanyaan],
		[tipeJawaban]
	FROM
		ParsePertanyaan(@jsonPertanyaan)

	DECLARE 
		@currPertanyaan [VARCHAR](150),
		@currTipeJawaban [VARCHAR](10),
		@isSuccess [BIT]

	DECLARE cursorPertanyaan CURSOR
	FOR
		SELECT
			[pertanyaan],
			[tipeJawaban]
		FROM
			@tabelPertanyaan
	OPEN cursorPertanyaan

	FETCH NEXT FROM 
		cursorPertanyaan
	INTO
		@currPertanyaan,
		@currTipeJawaban

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		INSERT INTO 
			[PertanyaanSurvei]([pertanyaan], [tipeJawaban], [timestamp], [tombstone], [idSurvei])
		VALUES
			(@currPertanyaan, @currTipeJawaban, CURRENT_TIMESTAMP, 1, @idSurvei)

		FETCH NEXT FROM 
			cursorPertanyaan
		INTO
			@currPertanyaan,
			@currTipeJawaban
	END

	CLOSE cursorPertanyaan
	DEALLOCATE cursorPertanyaan

	SET
		@isSuccess = 1

	SELECT
		@isSuccess