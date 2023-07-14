DROP DATABASE IF EXISTS Marta;
CREATE DATABASE Marta;
USE Marta;

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

INSERT INTO Students(Id, Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 101, 'Зюмбюл Петров', 10, 11, 'а', '1999-02-28', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Исидор Иванов', 15, 10, 'б', '2000-02-29', '0042294120' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Панчо Лалов', 20, 10, 'б', '2000-05-01', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Петраки Ганьов', 20, 10, 'а', '1999-12-25', '9912256301' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Александър Момчев', 1, 8, 'а', '2002-06-11', NULL );

INSERT INTO Subjects(Id, Name) VALUES( 11, 'История' );
INSERT INTO Subjects(Name) VALUES( 'Литература' );
INSERT INTO Subjects(Name) VALUES( 'Математика' );
INSERT INTO Subjects(Name) VALUES( 'СУБД' );
INSERT INTO Subjects(Name) VALUES( 'Физика' );

INSERT INTO StudentMarks VALUES( 101, 11, '2017-03-03', 6 );
INSERT INTO StudentMarks VALUES( 101, 11, '2017-03-31', 5.50 );
INSERT INTO StudentMarks VALUES( 102, 11, '2017-04-28', 5 );
INSERT INTO StudentMarks VALUES( 103, 12, '2017-04-28', 4 );
INSERT INTO StudentMarks VALUES( 104, 13, '2017-03-03', 5 );
INSERT INTO StudentMarks VALUES( 104, 13, '2017-04-07', 6 );
INSERT INTO StudentMarks VALUES( 104, 11, '2017-04-07', 4.50 );
INSERT INTO StudentMarks VALUES( 104, 12, '2017-04-05', 3 );
INSERT INTO StudentMarks VALUES( 104, 12, '2017-04-07', 3 );
INSERT INTO StudentMarks VALUES( 104, 15, '2017-04-07', 4.50 );
INSERT INTO StudentMarks VALUES( 104, 15, '2017-05-07', 5.50 );
INSERT INTO StudentMarks VALUES( 101, 12, '2017-04-07', 6 );
INSERT INTO StudentMarks VALUES( 101, 12, '2017-04-08', 5.50 );
INSERT INTO StudentMarks VALUES( 101, 13, '2017-04-07', 6 );
INSERT INTO StudentMarks VALUES( 101, 13, '2017-04-08', 5 );
INSERT INTO StudentMarks VALUES( 101, 15, '2017-04-07', 3 );
INSERT INTO StudentMarks VALUES( 101, 15, '2017-04-08', 3 );

INSERT INTO MarkWords VALUES( 2, 2.50, 'Слаб' );
INSERT INTO MarkWords VALUES( 2.50, 3.50, 'Среден' );
INSERT INTO MarkWords VALUES( 3.50, 4.50, 'Добър' );
INSERT INTO MarkWords VALUES( 4.50, 5.50, 'Мн. добър' );
INSERT INTO MarkWords VALUES( 5.50, 6, 'Отличен' );

CREATE TABLE H_Students(
						UID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
                        EventDate DATETIME NOT NULL,
                        EventType CHAR(1) NOT NULL,
                        Id INTEGER,
                        Name VARCHAR(150),
                        Num INTEGER,
                        ClassNum INTEGER,
						ClassLetter CHAR(1),
						Birthday DATE,
						EGN CHAR(10),
						EntranceExamResult NUMERIC(3,2)
);

INSERT INTO H_Students
(EventDate, EventType, Id, Name, Num, CLassNum, ClassLetter, Birthday, EGN, EntranceExamResult) 
SELECT NOW(), 'I', Students.Id, Students.Name, Students.Num, Students.ClassNum, Students.ClassLetter, Students.Birthday, Students.EGN, Students.EntranceExamResult FROM Students;

DELIMITER $
CREATE TRIGGER history_students_insert
AFTER INSERT
ON Students FOR EACH ROW
BEGIN
INSERT INTO H_Students
(EventDate, EventType, Id, Name, Num, CLassNum, ClassLetter, Birthday, EGN, EntranceExamResult) 
VALUES(NOW(), 'I', new.Id, new.Name, new.Num, new.ClassNum, new.ClassLetter, new.Birthday, new.EGN, new.EntranceExamResult);
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER history_students_delete
AFTER DELETE
ON Students FOR EACH ROW
BEGIN
INSERT INTO H_Students
(EventDate, EventType, Id, Name, Num, CLassNum, ClassLetter, Birthday, EGN, EntranceExamResult) 
VALUES(NOW(), 'D', old.Id, old.Name, old.Num, old.ClassNum, old.ClassLetter, old.Birthday, old.EGN, old.EntranceExamResult);
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER history_students_update
AFTER UPDATE
ON Students FOR EACH ROW
BEGIN
INSERT INTO H_Students
(EventDate, EventType, Id, Name, Num, CLassNum, ClassLetter, Birthday, EGN, EntranceExamResult) 
VALUES(NOW(), 'U', new.Id, new.Name, new.Num, new.ClassNum, new.ClassLetter, new.Birthday, new.EGN, new.EntranceExamResult);
END
$
DELIMITER ;

INSERT INTO Students (Name, Num, ClassLetter, ClassNum) VALUES('az', 2, 'A', 11);
UPDATE Students SET Name = "pesh" WHERE Name = "az";

SELECT hs.*
FROM H_Students hs
LEFT JOIN H_Students later
ON hs.Id = later.Id AND hs.UID < later.UID
WHERE later.UID IS NULL AND hs.EventType <> 'D';