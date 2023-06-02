/*
	Input Format:
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
	namaSurvei		[VARCHAR](15)
	pertanyaan		[NVARCHAR](1000), JSON Array
*/

ALTER FUNCTION [ParseSurvei]
(
	@str [NVARCHAR](2048)
)
RETURNS @result TABLE
(
	[key] [VARCHAR](15),
	[value] [NVARCHAR](1000)
)
AS
BEGIN
	INSERT INTO @result
	SELECT
		[key],
		[value]
	FROM
		OPENJSON(@str)

	RETURN
END