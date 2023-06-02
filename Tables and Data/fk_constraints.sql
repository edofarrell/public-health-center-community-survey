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