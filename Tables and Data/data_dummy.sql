INSERT INTO
	[Role]([namaRole])
VALUES
	('Admin'),
	('Kader'),
	('Penanggung Jawab')

--Insert User
--Dearen = Admin
--Edo = Kader
--Neil = Penanggung Jawab
INSERT INTO
	[User]([username], [password], [idRole])
VALUES
	('dearen', 'password', '1'),
	('edo', 'password', '2'),
	('neil', 'password', '3')

INSERT INTO
	[Survei]([namaSurvei], [timestamp], [tombstone])
VALUES
	('Covid19', CURRENT_TIMESTAMP, 1),
	('Demam Berdarah', CURRENT_TIMESTAMP, 1),
	('Diare', CURRENT_TIMESTAMP, 1)

INSERT INTO
	[MengaksesSurvei]([idUser], [idSurvei])
VALUES
	(2, 1),
	(2, 2),
	(2, 3)

/*INSERT INTO
	[PertanyaanSurvei]([pertanyaan], [tipeJawaban], [timestamp], [tombstone], [idSurvei])
VALUES
	('Nama anda siapa?', 'STRING', CURRENT_TIMESTAMP, 1, 1),
	('Umur anda berapa?', 'NUMERIC', CURRENT_TIMESTAMP, 1, 1),
	('Sudah vaksin kedua?', 'STRING', CURRENT_TIMESTAMP, 1, 1),
	('Vaksin terakhir tanggal berapa?', 'DATE', CURRENT_TIMESTAMP, 1, 1),
	('Pernah terjangkit Covid19?', 'STRING', CURRENT_TIMESTAMP, 1, 1),

	('Nama anda siapa?', 'STRING', CURRENT_TIMESTAMP, 1, 2),
	('Umur anda berapa?', 'NUMERIC', CURRENT_TIMESTAMP, 1, 2),
	('Kapan terakhir mengalami demam berdarah?', 'DATE', CURRENT_TIMESTAMP, 1, 2),
	('Apakah lingkungan tempat tinggal anda banyak nyamuk?', 'STRING', CURRENT_TIMESTAMP, 1, 2),
	('Sudah berapa kali anda terkena demam berdarah?', 'NUMERIC', CURRENT_TIMESTAMP, 1, 2),

	('Nama anda siapa?', 'STRING', CURRENT_TIMESTAMP, 1, 3),
	('Umur anda berapa?', 'NUMERIC', CURRENT_TIMESTAMP, 1, 3),
	('Kapan terakhir mengalami diare?', 'DATE', CURRENT_TIMESTAMP, 1, 3),
	('Apakah anda sering membeli makanan di luar?', 'STRING', CURRENT_TIMESTAMP, 1, 3),
	('Apakah anda memiliki riwayat penyakit perut?', 'STRING', CURRENT_TIMESTAMP, 1, 3)*/

DECLARE @pertanyaanSurvei1 NVarChar(2150) = 
'[
	{
		"pertanyaan": "Nama anda siapa?",
		"tipeJawaban": "STRING"
	},
	{
		"pertanyaan": "Umur anda berapa?",
		"tipeJawaban": "NUMERIC"
	},
	{
		"pertanyaan": "Sudah vaksin kedua?",
		"tipeJawaban": "STRING"
	},
	{
		"pertanyaan": "Vaksin terakhir tanggal berapa?",
		"tipeJawaban": "DATE"
	},
	{
		"pertanyaan": "Pernah terjangkit Covid19?",
		"tipeJawaban": "STRING"
	},
]'

DECLARE @pertanyaanSurvei2 NVarChar(2150) = 
'[
	{
		"pertanyaan": "Nama anda siapa?",
		"tipeJawaban": "STRING"
	},
	{
		"pertanyaan": "Umur anda berapa?",
		"tipeJawaban": "NUMERIC"
	},
	{
		"pertanyaan": "Kapan terakhir mengalami demam berdarah?",
		"tipeJawaban": "DATE"
	},
	{
		"pertanyaan": "Apakah lingkungan tempat tinggal anda banyak nyamuk?",
		"tipeJawaban": "STRING"
	},
	{
		"pertanyaan": "Sudah berapa kali anda terkena demam berdarah?",
		"tipeJawaban": "NUMERIC"
	},
]'

DECLARE @pertanyaanSurvei3 NVarChar(2150) = 
'[
	{
		"pertanyaan": "Nama anda siapa?",
		"tipeJawaban": "STRING"
	},
	{
		"pertanyaan": "Umur anda berapa?",
		"tipeJawaban": "NUMERIC"
	},
	{
		"pertanyaan": "Kapan terakhir mengalami diare?",
		"tipeJawaban": "DATE"
	},
	{
		"pertanyaan": "Apakah anda sering membeli makanan di luar?",
		"tipeJawaban": "STRING"
	},
	{
		"pertanyaan": "Apakah anda sering membeli makanan di luar?",
		"tipeJawaban": "STRING"
	},
]'

EXEC InsertPertanyaan 1, @pertanyaanSurvei1
EXEC InsertPertanyaan 2, @pertanyaanSurvei2
EXEC InsertPertanyaan 3, @pertanyaanSurvei3