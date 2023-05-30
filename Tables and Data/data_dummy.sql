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

INSERT INTO
	[PertanyaanSurvei]([pertanyaan], [timestamp], [tombstone], [idSurvei])
VALUES
	('Nama anda siapa?', CURRENT_TIMESTAMP, 1, 1),
	('Umur anda berapa?', CURRENT_TIMESTAMP, 1, 1),
	('Sudah vaksin kedua?', CURRENT_TIMESTAMP, 1, 1),
	('Vaksin terakhir tanggal berapa?', CURRENT_TIMESTAMP, 1, 1),
	('Pernah terjangkit Covid19?', CURRENT_TIMESTAMP, 1, 1),

	('Nama anda siapa?', CURRENT_TIMESTAMP, 1, 2),
	('Umur anda berapa?', CURRENT_TIMESTAMP, 1, 2),
	('Kapan terakhir mengalami demam berdarah?', CURRENT_TIMESTAMP, 1, 2),
	('Apakah lingkungan tempat tinggal anda banyak nyamuk?', CURRENT_TIMESTAMP, 1, 2),
	('Sudah berapa kali anda terkena demam berdarah?', CURRENT_TIMESTAMP, 1, 2),

	('Nama anda siapa?', CURRENT_TIMESTAMP, 1, 3),
	('Umur anda berapa?', CURRENT_TIMESTAMP, 1, 3),
	('Kapan terakhir mengalami diare?', CURRENT_TIMESTAMP, 1, 3),
	('Apakah anda sering membeli makanan di luar?', CURRENT_TIMESTAMP, 1, 3),
	('Apakah anda memiliki riwayat penyakit perut?', CURRENT_TIMESTAMP, 1, 3)