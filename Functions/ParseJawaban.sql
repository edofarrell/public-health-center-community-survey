/* 
	String Format: "key1:value1,key2:value2,...,keyn:valuen"
	First seperator: ','
	Second seperator: ':'
*/

ALTER FUNCTION [ParseJawaban] 
(
	@str [VARCHAR](1000)
)
RETURNS @result TABLE
(
	[key] [VARCHAR](150),
	[value] [VARCHAR](150)
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
END