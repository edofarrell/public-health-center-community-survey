/*
	@jsonSurvei Format:
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
	
	Each Field (namaSurvei, pertanyaan) is optional
*/

ALTER PROCEDURE [UpdateSurvei]
	@idSurvei [INT],
	@jsonSurvei [NVARCHAR](2250)
AS
	DECLARE
		@namaSurvei [VARCHAR](50),
		@jsonPertanyaan [NVARCHAR](2150),
		@currIdPertanyaan [INT],
		@currPertanyaan [VARCHAR](150),
		@currTipeJawaban [VARCHAR](10),
		@isSuccess [BIT]

	BEGIN TRANSACTION
	BEGIN TRY
		SELECT
			@namaSurvei = [namaSurvei],
			@jsonPertanyaan = [pertanyaan] 
		FROM
			ParseSurvei(@jsonSurvei)

		IF(@namaSurvei IS NOT NULL)
		BEGIN
			UPDATE
				[Survei]
			SET
				[namaSurvei] = @namaSurvei
			WHERE
				[Survei].[idSurvei] = @idSurvei
		END

		IF(@jsonPertanyaan IS NOT NULL)
		BEGIN
			DECLARE @tabelPertanyaan TABLE
			(
				[idPertanyaan] [INT],
				[pertanyaan] [VARCHAR](150),
				[tipeJawaban] [VARCHAR](10)
			)

			INSERT INTO @tabelPertanyaan
			SELECT
				[idPertanyaan],
				[pertanyaan],
				[tipeJawaban]
			FROM
				ParsePertanyaan(@jsonPertanyaan)

			DECLARE cursorPertanyaan CURSOR
			FOR
				SELECT
					[idPertanyaan],
					[pertanyaan],
					[tipeJawaban]
				FROM
					@tabelPertanyaan
			OPEN cursorPertanyaan

			FETCH NEXT FROM 
				cursorPertanyaan
			INTO
				@currIdPertanyaan,
				@currPertanyaan,
				@currTipeJawaban

			WHILE(@@FETCH_STATUS = 0)
			BEGIN
				UPDATE
					[PertanyaanSurvei]
				SET
					[pertanyaan] = @currPertanyaan,
					[tipeJawaban] = @currTipeJawaban
				WHERE
					[idSurvei] = @idSurvei
					AND [idPertanyaanSurvei] = @currIdPertanyaan

				FETCH NEXT FROM 
					cursorPertanyaan
				INTO
					@currIdPertanyaan,
					@currPertanyaan,
					@currTipeJawaban
			END

			CLOSE cursorPertanyaan
			DEALLOCATE cursorPertanyaan
		END

		SET @isSuccess = 1

		SELECT
			@isSuccess

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET @isSuccess = 0

		SELECT
			@isSuccess

		ROLLBACK TRANSACTION
	END CATCH