INSERT INTO
	[Role]([namaRole])
VALUES
	('Admin'),
	('Kader'),
	('Penanggung Jawab')

--Create User
--Dearen = Admin
--Edo = Kader
--Neil = Penanggung Jawab
EXEC CreateUser 'dearen','password',1
EXEC CreateUser 'edo','password',2
EXEC CreateUser 'neil','password',3

--Create Survei
EXEC CreateSurvei 'Covid19'
EXEC CreateSurvei 'Demam Berdarah'
EXEC CreateSurvei 'Diare'

--Create Akses ke Survei
INSERT INTO
	[MengaksesSurvei]([idUser], [idSurvei])
VALUES
	(1, 1),
	(2, 2),
	(3, 3)

--Insert Jawaban Survei
EXEC InsertJawaban 1,1,'
[
	{
		"idPertanyaan": 1,
		"jawaban": "Edo Farrell"
	},
	{
		"idPertanyaan": 2,
		"jawaban": 20
	},
	{
		"idPertanyaan": 3,
		"jawaban": "Sudah"
	},
	{
		"idPertanyaan": 4,
		"jawaban": "2023-01-20"
	},
	{
		"idPertanyaan": 5,
		"jawaban": "Pernah"
	}
]'

EXEC InsertJawaban 1,1,'
[
	{
		"idPertanyaan": 1,
		"jawaban": "Erwin Darsono"
	},
	{
		"idPertanyaan": 2,
		"jawaban": 45
	},
	{
		"idPertanyaan": 3,
		"jawaban": "Sudah"
	},
	{
		"idPertanyaan": 4,
		"jawaban": "2018-05-23"
	},
	{
		"idPertanyaan": 5,
		"jawaban": "Belum"
	}
]'

EXEC InsertJawaban 2,2,'
[
	{
		"idPertanyaan": 6,
		"jawaban": "Dearen Hippy"
	},
	{
		"idPertanyaan": 7,
		"jawaban": 19
	},
	{
		"idPertanyaan": 8,
		"jawaban": "2022-10-18"
	},
	{
		"idPertanyaan": 9,
		"jawaban": "Iyaa"
	},
	{
		"idPertanyaan": 10,
		"jawaban": 1
	}
]'

EXEC InsertJawaban 3,3,'
[
	{
		"idPertanyaan": 11,
		"jawaban": "Neil Christopher"
	},
	{
		"idPertanyaan": 12,
		"jawaban": 19
	},
	{
		"idPertanyaan": 13,
		"jawaban": "2012-11-05"
	},
	{
		"idPertanyaan": 14,
		"jawaban": "Sering"
	},
	{
		"idPertanyaan": 15,
		"jawaban": "Punya"
	}
]'

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
	}
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
	}
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
	}
]'

EXEC InsertPertanyaan 1, @pertanyaanSurvei1
EXEC InsertPertanyaan 2, @pertanyaanSurvei2
EXEC InsertPertanyaan 3, @pertanyaanSurvei3