/* 
	Input Format (JSON Array):
	[
		{
			"idPertanyaan": [NUMBER],
			"jawaban":		[STRING]
		},
		{
			"idPertanyaan": [NUMBER],
			"jawaban":		[STRING]
		}
	]

	Output Format:
	idPertanyaan	jawaban
	[INT]			[VARCHAR](300)
*/

ALTER FUNCTION [ParseJawaban] 
(
	@json [NVARCHAR](3350)
)
RETURNS @result TABLE
(
	[idPertanyaan] [INT],
	[jawaban] [VARCHAR](300)
)
AS
BEGIN
	DECLARE 
		@currJawaban [VARCHAR](300)

	DECLARE cursorJawaban CURSOR
	FOR
		SELECT 
			[value]
		FROM
			OPENJSON(@json)
	OPEN cursorJawaban

	FETCH NEXT FROM
		cursorJawaban
	INTO
		@currJawaban

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @result
		SELECT
			[idPertanyaan],
			[jawaban]
		FROM
			OPENJSON(@currJawaban)
		WITH
			(
				[idPertanyaan] [INT] '$.idPertanyaan',
				[jawaban] [VARCHAR](150) '$.jawaban'
			)

		FETCH NEXT FROM
			cursorJawaban
		INTO
			@currJawaban
	END
	
	CLOSE cursorJawaban
	DEALLOCATE cursorJawaban

	RETURN
END