/* 
	Input Format (JSON Array):
	[
		{
			"idPertanyaan": 1,
			"lowerBound": "2",
			"upperBound": "4"
		},
		{
			"idPertanyaan": 2,
			"lowerBound": "2023-01-01",
			"upperBound": "20203-01-02"
		}
	]

	Output Format:
	idPertanyaan	lowerBound		upperBound		tipeJawaban
	[INT]			[VARCHAR](15)	[VARCHAR](15)	[VARCHAR](10)
*/

ALTER FUNCTION [ParseFilter] 
(
	@json [NVARCHAR](1000)
)
RETURNS @result TABLE
(
	[idPertanyaan] [INT],
	[lowerBound] [VARCHAR](15),
	[upperBound] [VARCHAR](15),
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
			[j].[lowerBound],
			[j].[upperBound],
			[PertanyaanSurvei].[tipeJawaban]
		FROM
			[PertanyaanSurvei]
			INNER JOIN OPENJSON(@currFilter)
			WITH
				(
					[idPertanyaan] [INT] '$.idPertanyaan',
					[lowerBound] [VARCHAR](15) '$.lowerBound',
					[upperBound] [VARCHAR](15) '$.upperBound'
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