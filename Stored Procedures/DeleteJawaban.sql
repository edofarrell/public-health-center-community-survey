ALTER PROCEDURE DeleteJawaban
	@idGroupJawaban INT,
	@idPertanyaan INT
AS
	DECLARE
		@currIdGroupJawaban INT,
		@currIdPertanyaanSurvei INT,
		@currTipeJawaban VARCHAR(10),
		@isSuccess BIT
	
	DECLARE cursorDeleteJawaban CURSOR
	FOR
		SELECT
			GroupJawaban.idGroupJawaban,
			PertanyaanSurvei.idPertanyaanSurvei,
			PertanyaanSurvei.tipeJawaban
		FROM
			GroupJawaban
				INNER JOIN 
						PertanyaanSurvei
						ON GroupJawaban.idSurvei = PertanyaanSurvei.idSurvei
	OPEN cursorDeleteJawaban

	FETCH NEXT FROM
		cursorDeleteJawaban
	INTO
		@currIdGroupJawaban,
		@currIdPertanyaanSurvei,
		@currTipeJawaban

	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @currTipeJawaban = 'NUMERIC'
				BEGIN
					UPDATE 
						JawabanNumeric
					SET
						tombstone = 0
					WHERE
						idGroupJawaban = @idGroupJawaban
						AND
						idPertanyaan = @idPertanyaan
						AND
						tombstone = 1
				END
			ELSE IF @currTipeJawaban = 'DATE'
				BEGIN
					UPDATE 
						JawabanDate
					SET
						tombstone = 0
					WHERE
						idGroupJawaban = @idGroupJawaban
						AND
						idPertanyaan = @idPertanyaan
						AND
						tombstone = 1
				END
			ELSE
				BEGIN
					UPDATE 
						JawabanString
					SET
						tombstone = 0
					WHERE
						idGroupJawaban = @idGroupJawaban
						AND
						idPertanyaan = @idPertanyaan
						AND
						tombstone = 1
				END

			FETCH NEXT FROM
				cursorDeleteJawaban
			INTO
				@currIdGroupJawaban,
				@currIdPertanyaanSurvei,
				@currTipeJawaban
		END
	CLOSE cursorDeleteJawaban
	DEALLOCATE cursorDeleteJawaban

	SET
		@isSuccess = 1

	SELECT
		@isSuccess