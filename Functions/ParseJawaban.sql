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
	key				value
	idPertanyaan	[INT]
	jawaban			[VARCHAR](150)
*/

ALTER FUNCTION [ParseJawaban] 
(
	@str [NVARCHAR](1000)
)
RETURNS @result TABLE
(
	[idPertanyaan] [INT],
	[jawaban] [VARCHAR](150)
)
AS
BEGIN
	DECLARE 
		@currJawaban [VARCHAR](150)

	DECLARE cursorJawaban CURSOR
	FOR
		SELECT 
			[value]
		FROM
			OPENJSON(@str)
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

/* 
	String Format: "id1:jawaban1,id2:jawaban2,...,idn:jawabann"
	First seperator: ','
	Second seperator: ':'
*/

/*ALTER FUNCTION [ParseJawaban] 
(
	@str [VARCHAR](1000)
)
RETURNS @result TABLE
(
	[idPertanyaan] [INT],
	[jawaban] [VARCHAR](150)
)
AS
BEGIN
	DECLARE cursorRow CURSOR
	FOR
		SELECT 
			value
		FROM
			STRING_SPLIT(@str, ',')
	OPEN cursorRow

	DECLARE @currRow varchar(150)
	FETCH NEXT FROM
		cursorRow
	INTO
		@currRow

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @result
		SELECT
			SUBSTRING(@currRow, 0, CHARINDEX(':', @currRow)),
			SUBSTRING(@currRow, CHARINDEX(':', @currRow)+1, LEN(@currRow))

		FETCH NEXT FROM
			cursorRow
		INTO
			@currRow
	END
	
	CLOSE cursorRow
	DEALLOCATE cursorRow

	RETURN
END*/