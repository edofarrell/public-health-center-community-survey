DROP TABLE 
	[dbo].[JawabanString],
	[dbo].[JawabanNumeric],
	[dbo].[JawabanDate],
	[dbo].[PertanyaanSurvei],
	[dbo].[GroupJawaban],
	[dbo].[MengaksesSurvei],
	[dbo].[Survei],
	[dbo].[User],
	[dbo].[Role]

CREATE TABLE [dbo].[Role]
(
	[idRole] [INT] PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[namaRole] [VARCHAR](20) NOT NULL,
)

CREATE TABLE [dbo].[User]
(
	[idUser] [INT] PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[username] [VARCHAR](20) NOT NULL,
	[password] [VARCHAR](20) NOT NULL,
	[idRole] [INT] NOT NULL --FK Role(idRole)
)

CREATE TABLE [dbo].[Survei]
(
	[idSurvei] [INT] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[namaSurvei] [VARCHAR](50) NOT NULL,
	[timestamp] [DATETIME] NOT NULL,
	[tombstone] [BIT] NOT NULL
)

CREATE TABLE [dbo].[MengaksesSurvei]
(
	[idUser] [INT] NOT NULL, --FK User(idUser)
	[idSurvei] [INT] NOT NULL, --FK Survei(idSurvei)
	CONSTRAINT UC_AksesSurvei UNIQUE(idUser, idSurvei)
)

CREATE TABLE [dbo].[GroupJawaban]
(
	[idGroupJawaban] [INT] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[timestamp] [DATETIME] NOT NULL,
	[idSurvei] [INT] NOT NULL --FK [Survei]([idSurvei])
)

/*
	Tipe Jawaban:
	'NUMERIC', 'DATE', 'STRING'
*/
CREATE TABLE [dbo].[PertanyaanSurvei]
(
	[idPertanyaanSurvei] [INT] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[pertanyaan] [VARCHAR](150) NOT NULL,
	[tipeJawaban] [VARCHAR](10) NOT NULL,
	[timestamp] [DATETIME] NOT NULL,
	[tombstone] [BIT] NOT NULL,
	[idSurvei] [INT] NOT NULL --FK [Survei]([idSurvei])
)

CREATE TABLE [dbo].[JawabanDate]
(
	[idJawabanDate] [INT] PRIMARY KEY NONCLUSTERED IDENTITY(1,1) NOT NULL,
	[jawabanDate] [DATETIME] NOT NULL,
	[timestamp] [DATETIME] NOT NULL,
	[tombstone] [BIT] NOT NULL,
	[idPertanyaan] [INT] NOT NULL, --FK PertanyaanSurvei([idPertanyaanSurvei])
	[idGroupJawaban] [INT] NOT NULL, --FK GroupJawaban([idGroupJawaban])
	[idUser] [INT] NOT NULL --FK User([idUser])
)
CREATE CLUSTERED INDEX idxIdPertanyaan ON [JawabanDate](idPertanyaan)

CREATE TABLE [dbo].[JawabanNumeric]
(
	[idJawabanNumeric] [INT] PRIMARY KEY NONCLUSTERED IDENTITY(1,1) NOT NULL,
	[jawabanNumeric] [FLOAT] NOT NULL,
	[timestamp] [DATETIME] NOT NULL,
	[tombstone] [BIT] NOT NULL,
	[idPertanyaan] [INT] NOT NULL, --FK PertanyaanSurvei([idPertanyaanSurvei])
	[idGroupJawaban] [INT] NOT NULL, --FK GroupJawaban([idGroupJawaban])
	[idUser] [INT] NOT NULL --FK User([idUser])
)	
CREATE CLUSTERED INDEX idxIdPertanyaan ON [JawabanNumeric](idPertanyaan)

CREATE TABLE [dbo].[JawabanString]
(
	[idJawabanString] [INT] PRIMARY KEY NONCLUSTERED IDENTITY(1,1) NOT NULL,
	[jawabanString] [VARCHAR](300) NOT NULL,
	[timestamp] [DATETIME] NOT NULL,
	[tombstone] [BIT] NOT NULL,
	[idPertanyaan] [INT] NOT NULL, --FK PertanyaanSurvei([idPertanyaanSurvei])
	[idGroupJawaban] [INT] NOT NULL, --FK GroupJawaban([idGroupJawaban])
	[idUser] [INT] NOT NULL --FK User([idUser])
)
CREATE CLUSTERED INDEX idxIdPertanyaan ON [JawabanString](idPertanyaan)


-- Script untuk tambah constraint FK
ALTER TABLE [User]
ADD FOREIGN KEY (idRole) REFERENCES [Role](idRole)

ALTER TABLE [MengaksesSurvei]
ADD FOREIGN KEY (idUser) REFERENCES [User](idUser)

ALTER TABLE [MengaksesSurvei]
ADD FOREIGN KEY (idSurvei) REFERENCES [Survei](idSurvei)

ALTER TABLE [GroupJawaban]
ADD FOREIGN KEY (idSurvei) REFERENCES [Survei](idSurvei)

ALTER TABLE [PertanyaanSurvei]
ADD FOREIGN KEY (idSurvei) REFERENCES [Survei](idSurvei)

ALTER TABLE [JawabanDate]
ADD FOREIGN KEY (idPertanyaan) REFERENCES PertanyaanSurvei(idPertanyaanSurvei)

ALTER TABLE [JawabanDate]
ADD FOREIGN KEY (idGroupJawaban) REFERENCES GroupJawaban(idGroupJawaban)

ALTER TABLE [JawabanDate]
ADD FOREIGN KEY (idUser) REFERENCES [User](idUser)

ALTER TABLE [JawabanNumeric]
ADD FOREIGN KEY (idPertanyaan) REFERENCES PertanyaanSurvei(idPertanyaanSurvei)

ALTER TABLE [JawabanNumeric]
ADD FOREIGN KEY (idGroupJawaban) REFERENCES GroupJawaban(idGroupJawaban)

ALTER TABLE [JawabanNumeric]
ADD FOREIGN KEY (idUser) REFERENCES [User](idUser)

ALTER TABLE [JawabanString]
ADD FOREIGN KEY (idPertanyaan) REFERENCES PertanyaanSurvei(idPertanyaanSurvei)

ALTER TABLE [JawabanString]
ADD FOREIGN KEY (idGroupJawaban) REFERENCES GroupJawaban(idGroupJawaban)

ALTER TABLE [JawabanString]
ADD FOREIGN KEY (idUser) REFERENCES [User](idUser)