/* 
	@jsonPertanyaan Format (JSON Array):
	[
		{
			"pertanyaan":	[STRING],
			"tipeJawaban":	[STRING]
		},
		{
			"pertanyaan": 	[STRING],
			"tipeJawaban":	[STRING]
		}
	]

	Output Format:
	pertanyaan		tipeJawaban
	[VARCHAR](150)	[VARCHAR](10)

	"tipeJawaban" field: "NUMERIC", "DATE", "STRING"
*/

ALTER PROCEDURE [InsertPertanyaan]
	@idSurvei [INT],
	@jsonPertanyaan [NVARCHAR](2150)
AS
	DECLARE @tabelPertanyaan TABLE
	(
		[pertanyaan] [VARCHAR](150),
		[tipeJawaban] [VARCHAR](10)
	)

	DECLARE 
		@currPertanyaan [VARCHAR](150),
		@currTipeJawaban [VARCHAR](10),
		@isSuccess [BIT]

	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO @tabelPertanyaan
		SELECT
			[pertanyaan],
			[tipeJawaban]
		FROM
			ParsePertanyaan(@jsonPertanyaan)

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

		SET @isSuccess = 1

		SELECT
			@isSuccess

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET @isSuccess = 0

		SELECT
			@isSuccess

		ROLLBACK TRANSACTION
	END CATCH