/*
	@strIdPertanyaan format:
	"[INT],[INT],[INT]"
*/

ALTER PROCEDURE [DeleteJawaban]
	@idGroupJawaban [INT],
	@strIdPertanyaan [VARCHAR](20)
AS
	DECLARE
		@currTipeJawaban [VARCHAR](10),
		@currIdPertanyaan [INT],
		@isSuccess [BIT]

	DECLARE @tableIdPertanyaan TABLE
	(
		[idPertanyaan] [INT]
	)

	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO @tableIdPertanyaan
		SELECT
			CAST([value] AS [INT])
		FROM
			STRING_SPLIT(@strIdPertanyaan, ',')

		DECLARE cursorIdPertanyaan CURSOR
		FOR
			SELECT
				[@tableIdPertanyaan].[idPertanyaan],
				[PertanyaanSurvei].[tipeJawaban]
			FROM 
				[PertanyaanSurvei]
				INNER JOIN @tableIdPertanyaan
					ON [@tableIdPertanyaan].[idPertanyaan] = [PertanyaanSurvei].[idPertanyaanSurvei]
		OPEN cursorIdPertanyaan

		FETCH NEXT FROM
			cursorIdPertanyaan
		INTO
			@currIdPertanyaan,
			@currTipeJawaban

		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			IF(@currTipeJawaban = 'NUMERIC')
			BEGIN
				UPDATE 
					[JawabanNumeric]
				SET
					[tombstone] = 0
				WHERE
					[JawabanNumeric].[idGroupJawaban] = @idGroupJawaban
					AND [JawabanNumeric].[idPertanyaan] = @currIdPertanyaan
					AND [JawabanNumeric].[tombstone] = 1
			END
			ELSE IF(@currTipeJawaban = 'DATE')
			BEGIN
				UPDATE 
					[JawabanDate]
				SET
					[tombstone] = 0
				WHERE
					[JawabanDate].[idGroupJawaban] = @idGroupJawaban
					AND [JawabanDate].[idPertanyaan] = @currIdPertanyaan
					AND [JawabanDate].[tombstone] = 1
			END
			ELSE
			BEGIN
				UPDATE 
					[JawabanString]
				SET
					[tombstone] = 0
				WHERE
					[JawabanString].[idGroupJawaban] = @idGroupJawaban
					AND [JawabanString].[idPertanyaan] = @currIdPertanyaan
					AND [JawabanString].[tombstone] = 1
			END
			
			FETCH NEXT FROM
				cursorIdPertanyaan
			INTO
				@currIdPertanyaan,
				@currTipeJawaban
		END

		CLOSE cursorIdPertanyaan
		DEALLOCATE cursorIdPertanyaan

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