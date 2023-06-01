/* 
	String Format: "id1:pertanyaan1:tipe1,id2:pertanyaan2:tipe2,...,idn:pertanyaann:tipen"
	First seperator: ','
	Second seperator: ':'
*/

ALTER FUNCTION [ParsePertanyaan] 
(
	@str [VARCHAR](1000)
)
RETURNS @result TABLE
(
	[idPertanyaan] [INT],
	[pertanyaan] [VARCHAR](150),
	[tipeJawaban] [VARCHAR](10)
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
		DECLARE
			@currId [INT],
			@currPertanyaan [VARCHAR](150),
			@currTipeJawaban [VARCHAR](10)

		DECLARE cursorData CURSOR
		FOR
			SELECT
				value
			FROM
				STRING_SPLIT(@currRow, ':')
		OPEN cursorData

		FETCH NEXT FROM
			cursorData
		INTO
			@currId

		FETCH NEXT FROM
			cursorData
		INTO
			@currPertanyaan

		FETCH NEXT FROM
			cursorData
		INTO
			@currTipeJawaban

		CLOSE cursorData
		DEALLOCATE cursorData

		INSERT INTO @result
		SELECT
			@currId,
			@currPertanyaan,
			@currTipeJawaban

		FETCH NEXT FROM
			cursorRow
		INTO
			@currRow
	END
	
	CLOSE cursorRow
	DEALLOCATE cursorRow

	RETURN
END