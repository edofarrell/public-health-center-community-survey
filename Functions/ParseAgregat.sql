/* 
	Input Format (JSON Array):
	[
		{
			"idPertanyaan": [NUMBER],
			"agregat": [STRING]
		},
		{
			"idPertanyaan": [NUMBER],
			"agregat": [STRING]
		}
	]

	Output Format:
	idPertanyaan	filter			tipeJawaban
	[INT]			[VARCHAR](10)	[VARCHAR](10)

	"agregat" field: "SUM", "MIN", "MAX", "AVG", "COUNT"
*/

ALTER FUNCTION [ParseAgregat]
(
	@json [NVARCHAR](1000)
)
RETURNS @result TABLE
(
	[idPertanyaan] [INT],
	[agregat] [VARCHAR](10),
	[tipeJawaban] [VARCHAR](10)
)
AS
BEGIN
	DECLARE 
		@currAgregat [VARCHAR](100)

	DECLARE cursorAgregat CURSOR
	FOR
		SELECT 
			[value]
		FROM
			OPENJSON(@json)
	OPEN cursorAgregat

	FETCH NEXT FROM
		cursorAgregat
	INTO
		@currAgregat

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @result
		SELECT
			[J].[idPertanyaan],
			[J].[agregat],
			[PertanyaanSurvei].[tipeJawaban]
		FROM
			[PertanyaanSurvei]
			INNER JOIN OPENJSON(@currAgregat)
			WITH
				(
					[idPertanyaan] [INT] '$.idPertanyaan',
					[agregat] [VARCHAR](30) '$.agregat'
				) J
				ON [J].[idPertanyaan] = [PertanyaanSurvei].[idPertanyaanSurvei] 

		FETCH NEXT FROM
			cursorAgregat
		INTO
			@currAgregat
	END
	
	CLOSE cursorAgregat
	DEALLOCATE cursorAgregat

	RETURN
END