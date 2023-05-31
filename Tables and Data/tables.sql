DROP TABLE 
	[dbo].[Role],
	[dbo].[User],
	[dbo].[Survei],
	[dbo].[MengaksesSurvei],
	[dbo].[GroupJawaban],
	[dbo].[PertanyaanSurvei],
	[dbo].[JawabanDate],
	[dbo].[JawabanNumeric],
	[dbo].[JawabanString]

CREATE TABLE [dbo].[Role]
(
	[idRole] [INT] PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[namaRole] [VARCHAR](50) NOT NULL,
)

CREATE TABLE [dbo].[User]
(
	[idUser] [INT] PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[username] [VARCHAR](50) NOT NULL,
	[password] [VARCHAR](50) NOT NULL,
	[idRole] [INT] NOT NULL --FK Role(idRole)
)

CREATE TABLE [dbo].[Survei]
(
	[idSurvei] [INT] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[namaSurvei] [VARCHAR](100) NOT NULL,
	[timestamp] [DATETIME] NOT NULL,
	[tombstone] [BIT] NOT NULL
)

CREATE TABLE [dbo].[MengaksesSurvei]
(
	[idUser] [INT] NOT NULL, --FK User(idUser)
	[idSurvei] [INT] NOT NULL, --FK Survei(idSurvei)
	CONSTRAINT UC_AksesSurvei UNIQUE (idUser, idSurvei)
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
	[pertanyaan] [VARCHAR](100) NOT NULL,
	[tipeJawaban] [VARCHAR](10) NOT NULL,
	[timestamp] [DATETIME] NOT NULL,
	[tombstone] [BIT] NOT NULL,
	[idSurvei] [INT] NOT NULL --FK [Survei]([idSurvei])
)

CREATE TABLE [dbo].[JawabanDate]
(
	[idJawabanDate] [INT] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[jawabanDate] [DATETIME] NOT NULL,
	[timestamp] [DATETIME] NOT NULL,
	[tombstone] [BIT] NOT NULL,
	[idPertanyaan] [INT] NOT NULL, --FK PertanyaanSurvei([idPertanyaanSurvei])
	[idGroupJawaban] [INT] NOT NULL, --FK GroupJawaban([idGroupJawaban])
	[idUser] [INT] NOT NULL --FK User([idUser])
)

CREATE TABLE [dbo].[JawabanNumeric]
(
	[idJawabanNumeric] [INT] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[jawabanNumeric] [FLOAT] NOT NULL,
	[timestamp] [DATETIME] NOT NULL,
	[tombstone] [BIT] NOT NULL,
	[idPertanyaan] [INT] NOT NULL, --FK PertanyaanSurvei([idPertanyaanSurvei])
	[idGroupJawaban] [INT] NOT NULL, --FK GroupJawaban([idGroupJawaban])
	[idUser] [INT] NOT NULL --FK User([idUser])
)	

CREATE TABLE [dbo].[JawabanString]
(
	[idJawabanString] [INT] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[jawabanString] [VARCHAR](50) NOT NULL,
	[timestamp] [DATETIME] NOT NULL,
	[tombstone] [BIT] NOT NULL,
	[idPertanyaan] [INT] NOT NULL, --FK PertanyaanSurvei([idPertanyaanSurvei])
	[idGroupJawaban] [INT] NOT NULL, --FK GroupJawaban([idGroupJawaban])
	[idUser] [INT] NOT NULL --FK User([idUser])
)