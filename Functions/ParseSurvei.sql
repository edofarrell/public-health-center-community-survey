/*
	Input Format (JSON):
	{
	 "namaSurvei": [STRING],
	 "pertanyaan": 
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
	}

	Output Format:
	namaSurvei			pertanyaan
	[VARCHAR](50)		[NVARCHAR](2150) (JSON Array)

	"tipeJawaban" field: "NUMERIC", "DATE", "STRING"
*/

ALTER FUNCTION [ParseSurvei]
(
	@json [NVARCHAR](2250)
)
RETURNS @result TABLE
(
	[namaSurvei] [VARCHAR](50),
	[pertanyaan] [NVARCHAR](2150)
)
AS
BEGIN
	INSERT INTO @result
	SELECT
		[namaSurvei],
		[pertanyaan]
	FROM
		OPENJSON(@json)
	WITH
		(
			[namaSurvei] [VARCHAR](50) '$.namaSurvei',
			[pertanyaan] [NVARCHAR](MAX) AS JSON
		)

	RETURN
END