DROP DATABASE IF EXISTS school;
CREATE DATABASE school CHARSET 'utf8';
USE school;

CREATE TABLE Students(
	Id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Name VARCHAR(150) NOT NULL,
	Num INTEGER NOT NULL,
	ClassNum INTEGER NOT NULL,
	ClassLetter CHAR(1) NOT NULL,
	Birthday DATE,
	EGN CHAR(10),
	EntranceExamResult NUMERIC(3,2)
);

CREATE TABLE Subjects(
	Id INTEGER NOT NULL AUTO_INCREMENT,
	Name VARCHAR(100),
	
	PRIMARY KEY(Id)
);

CREATE TABLE StudentMarks(
	StudentId INTEGER NOT NULL,
	SubjectId INTEGER NOT NULL,
	ExamDate DATETIME NOT NULL,
	Mark NUMERIC(3,2) NOT NULL,
	
	PRIMARY KEY( StudentId, SubjectId, ExamDate ),
	FOREIGN KEY (StudentId) REFERENCES Students(Id),
	FOREIGN KEY (SubjectId) REFERENCES Subjects(Id)
);

CREATE TABLE MarkWords(
	RangeStart NUMERIC(3,2) NOT NULL,
	RangeEnd NUMERIC(3,2) NOT NULL,
	MarkAsWord VARCHAR(15),
	
	PRIMARY KEY(RangeStart, RangeEnd)
);

CREATE TABLE H_Students(
	UID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	EventDate DATETIME NOT NULL,
	EventType CHAR(1),
	Id INTEGER,
	Name VARCHAR(150),
	Num INTEGER,
	ClassNum INTEGER,
	ClassLetter CHAR(1),
	Birthday DATE,
	EGN CHAR(10),
	EntranceExamResult NUMERIC(3,2)
);

CREATE TABLE H_StudentMarks(
	UID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	EventDate DATETIME NOT NULL,
	EventType CHAR(1),
    
	StudentId INTEGER,
	SubjectId INTEGER,
	ExamDate DATETIME,
	Mark NUMERIC(3,2)
);

DELIMITER $ 

CREATE TRIGGER Students_AI_Hist AFTER INSERT ON Students FOR EACH ROW
BEGIN
	INSERT INTO H_Students
    VALUES(NULL, NOW(), 'I', NEW.Id, NEW.Name, NEW.Num,
			NEW.ClassNum, NEW.ClassLetter, NEW.Birthday, NEW.EGN, NEW.EntranceExamResult);
END$

CREATE TRIGGER Students_AU_Hist AFTER UPDATE ON Students FOR EACH ROW
BEGIN
	INSERT INTO H_Students
    VALUES(NULL, NOW(), 'U', NEW.Id, NEW.Name, NEW.Num,
			NEW.ClassNum, NEW.ClassLetter, NEW.Birthday, NEW.EGN, NEW.EntranceExamResult);
END$

CREATE TRIGGER Students_AD_Hist AFTER DELETE ON Students FOR EACH ROW
BEGIN
	INSERT INTO H_Students
    VALUES(NULL, NOW(), 'D', OLD.Id, OLD.Name, OLD.Num,
			OLD.ClassNum, OLD.ClassLetter, OLD.Birthday, OLD.EGN, OLD.EntranceExamResult);
END$

CREATE TRIGGER StudentMarks_AI_Hist AFTER INSERT ON StudentMarks FOR EACH ROW
BEGIN
	INSERT INTO H_StudentMarks
    VALUES(NULL, NOW(), 'I', NEW.StudentId, NEW.SubjectId, NEW.ExamDate, NEW.Mark);
END$

CREATE TRIGGER StudentMarks_AU_Hist AFTER UPDATE ON StudentMarks FOR EACH ROW
BEGIN
	INSERT INTO H_StudentMarks
    VALUES(NULL, NOW(), 'U', NEW.StudentId, NEW.SubjectId, NEW.ExamDate, NEW.Mark);
END$

CREATE TRIGGER StudentMarkss_AD_Hist AFTER DELETE ON StudentMarks FOR EACH ROW
BEGIN
	INSERT INTO H_StudentMarks
    VALUES(NULL, NOW(), 'D', OLD.StudentId, OLD.SubjectId, OLD.ExamDate, OLD.Mark);
END$

DELIMITER ;

INSERT INTO Students(Id, Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 101, 'Зюмбюл Петров', 10, 11, 'а', '1999-02-28', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Исидор Иванов', 15, 10, 'б', '2000-02-29', '0042294120' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Панчо Лалов', 20, 10, 'б', '2000-05-01', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Петраки Ганьов', 20, 10, 'а', '1999-12-25', '9912256301' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Александър Момчев', 1, 8, 'а', '2002-06-11', NULL );

INSERT INTO Subjects(Id, Name) VALUES( 11, 'Английски език' );
INSERT INTO Subjects(Name) VALUES( 'Литература' );
INSERT INTO Subjects(Name) VALUES( 'Математика' );
INSERT INTO Subjects(Name) VALUES( 'СУБД' );

INSERT INTO StudentMarks VALUES( 101, 11, '2018-03-03', 6 );
INSERT INTO StudentMarks VALUES( 101, 11, '2018-03-31', 5.50 );
INSERT INTO StudentMarks VALUES( 102, 11, '2018-04-28', 5 );
INSERT INTO StudentMarks VALUES( 103, 12, '2018-04-28', 4 );
INSERT INTO StudentMarks VALUES( 104, 13, '2018-03-03', 5 );
INSERT INTO StudentMarks VALUES( 104, 13, '2018-04-07', 6 );
INSERT INTO StudentMarks VALUES( 104, 11, '2018-04-07', 4.50 );

INSERT INTO MarkWords VALUES( 2, 2.50, 'Слаб' );
INSERT INTO MarkWords VALUES( 2.50, 3.50, 'Среден' );
INSERT INTO MarkWords VALUES( 3.50, 4.50, 'Добър' );
INSERT INTO MarkWords VALUES( 4.50, 5.50, 'Мн. добър' );
INSERT INTO MarkWords VALUES( 5.50, 6, 'Отличен' );

UPDATE StudentMarks 
SET Mark = 4.00 
WHERE StudentMarks.StudentId = 101 
AND StudentMarks.SubjectId = 11 
AND StudentMarks.ExamDate = '2018-03-03'; 

SELECT hs.*, hsm.Mark
FROM H_Students hs
LEFT JOIN H_Students later
ON hs.Id = later.Id AND hs.UID < later.UID
LEFT JOIN H_StudentMarks hsm
ON hsm.StudentId = hs.Id
LEFT JOIN H_StudentMarks laterHsm
ON laterHsm.UID > hsm.UID 
AND laterHsm.StudentId = hsm.StudentId 
AND laterHsm.SubjectId = hsm.SubjectId 
AND laterHsm.ExamDate = hsm.ExamDate
WHERE later.UID IS NULL 
AND hs.EventType <> 'D' 
AND hsm.Mark IS NOT NULL 
AND laterHsm.UID IS NULL;