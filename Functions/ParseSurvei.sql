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
	key				value
	namaSurvei		[VARCHAR](50)
	pertanyaan		[NVARCHAR](2150) (JSON Array)
*/

ALTER FUNCTION [ParseSurvei]
(
	@json [NVARCHAR](2250)
)
RETURNS @result TABLE
(
	[key] [VARCHAR](10),
	[value] [NVARCHAR](2150)
)
AS
BEGIN
	INSERT INTO @result
	SELECT
		[key],
		[value]
	FROM
		OPENJSON(@json)

	RETURN
END