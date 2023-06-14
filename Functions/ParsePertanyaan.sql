 /* 
	Input Format (JSON Array):
	[
		{
			"idPertanyaan": [NUMBER],
			"pertanyaan":	[STRING],
			"tipeJawaban":	[STRING]
		},
		{
			"idPertanyaan": [NUMBER],
			"pertanyaan": 	[STRING],
			"tipeJawaban":	[STRING]
		}
	]

	Output Format:
	idPertanyaan	pertanyaan		tipeJawaban
	[INT]			[VARCHAR](150)	[VARCHAR](10)

	"tipeJawaban" field: "NUMERIC", "DATE", "STRING"
*/

ALTER FUNCTION [ParsePertanyaan] 
(
	@json [NVARCHAR](2150)
)
RETURNS @result TABLE
(
	[idPertanyaan] [INT],
	[pertanyaan] [VARCHAR](150),
	[tipeJawaban] [VARCHAR](10)
)
AS
BEGIN
	DECLARE
		@currPertanyaan [VARCHAR](150)

	DECLARE cursorPertanyaan CURSOR
	FOR
		SELECT
			[value]
		FROM
			OPENJSON(@json)
	OPEN cursorPertanyaan

	FETCH NEXT FROM
		cursorPertanyaan
	INTO
		@currPertanyaan

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		INSERT INTO @result
		SELECT
			[idPertanyaan],
			[pertanyaan],
			[tipeJawaban]
		FROM
			OPENJSON(@currPertanyaan)
		WITH
			(
				[idPertanyaan] [INT] '$.idPertanyaan',
				[pertanyaan] [VARCHAR](150) '$.pertanyaan',
				[tipeJawaban] [VARCHAR](11) '$.tipeJawaban'
			)

		FETCH NEXT FROM
			cursorPertanyaan
		INTO
			@currPertanyaan
	END

	CLOSE cursorPertanyaan
	DEALLOCATE cursorPertanyaan

	RETURN
END