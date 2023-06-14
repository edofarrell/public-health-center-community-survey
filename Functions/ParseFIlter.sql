/* 
	Input Format (JSON Array):
	[
		{
			"idPertanyaan": 1,
			"filter": "abc"
		},
		{
			"idPertanyaan": 2,
			"filter": "1,2"
		},
		{
			"idPertanyaan": 3,
			"filter": "2023-01-01,2023-01-02"
		}
	]

	Output Format:
	idPertanyaan	filter			tipeJawaban
	[INT]			[VARCHAR](50)	[VARCHAR](10)
*/

ALTER FUNCTION [ParseFilter] 
(
	@json [NVARCHAR](1000)
)
RETURNS @result TABLE
(
	[idPertanyaan] [INT],
	[filter] [VARCHAR](50),
	[tipeJawaban] [VARCHAR](10)
)
AS
BEGIN
	DECLARE 
		@currFilter [VARCHAR](100)

	DECLARE cursorFilter CURSOR
	FOR
		SELECT 
			[value]
		FROM
			OPENJSON(@json)
	OPEN cursorFilter

	FETCH NEXT FROM
		cursorFilter
	INTO
		@currFilter

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @result
		SELECT
			[j].[idPertanyaan],
			[j].[filter],
			[PertanyaanSurvei].[tipeJawaban]
		FROM
			[PertanyaanSurvei]
			INNER JOIN OPENJSON(@currFilter)
			WITH
				(
					[idPertanyaan] [INT] '$.idPertanyaan',
					[filter] [VARCHAR](30) '$.filter'
				) J
				ON J.[idPertanyaan] = [PertanyaanSurvei].[idPertanyaanSurvei] 

		FETCH NEXT FROM
			cursorFilter
		INTO
			@currFilter
	END
	
	CLOSE cursorFilter
	DEALLOCATE cursorFilter

	RETURN
END