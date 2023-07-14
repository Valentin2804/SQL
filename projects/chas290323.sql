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

INSERT INTO Students(Id, Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 101, 'Зюмбюл Петров', 10, 11, 'а', '1999-02-28', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Исидор Иванов', 15, 10, 'б', '2000-02-29', '0042294120' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Панчо Лалов', 20, 10, 'б', '2000-05-01', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Петраки Ганьов', 20, 10, 'а', '1999-12-25', '9912256301' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Александър Момчев', 1, 8, 'а', '2002-06-11', NULL );

INSERT INTO Subjects(Id, Name) VALUES( 11, 'Английски език' );
INSERT INTO Subjects(Name) VALUES( 'Литература' );
INSERT INTO Subjects(Name) VALUES( 'Математика' );
INSERT INTO Subjects(Name) VALUES( 'СУБД' );

INSERT INTO StudentMarks VALUES( 101, 11, '2017-03-03', 6 );
INSERT INTO StudentMarks VALUES( 101, 11, '2017-03-31', 5.50 );
INSERT INTO StudentMarks VALUES( 102, 11, '2017-04-28', 5 );
INSERT INTO StudentMarks VALUES( 103, 12, '2017-04-28', 4 );
INSERT INTO StudentMarks VALUES( 104, 13, '2017-03-03', 5 );
INSERT INTO StudentMarks VALUES( 104, 13, '2017-04-07', 6 );
INSERT INTO StudentMarks VALUES( 104, 11, '2017-04-07', 4.50 );

INSERT INTO MarkWords VALUES( 2, 2.50, 'Слаб' );
INSERT INTO MarkWords VALUES( 2.50, 3.50, 'Среден' );
INSERT INTO MarkWords VALUES( 3.50, 4.50, 'Добър' );
INSERT INTO MarkWords VALUES( 4.50, 5.50, 'Мн. добър' );
INSERT INTO MarkWords VALUES( 5.50, 6, 'Отличен' );

CREATE VIEW avarageMarkEveryStudent (Name, avarage)
AS
SELECT Students.Name , AVG(m.Mark) 
FROM StudentMarks m
LEFT JOIN Students
ON Students.Id = m.StudentId
GROUP BY m.StudentId
ORDER BY m.StudentId;

ALTER TABLE Students ADD COLUMN avgSuccess NUMERIC(7, 6);

DELIMITER $
CREATE FUNCTION CalculateAvgSuc (Id INTEGER)
RETURNS NUMERIC(7, 6)
DETERMINISTIC
BEGIN
	DECLARE result NUMERIC (7, 6);
    
    SELECT AVG(StudentMarks.Mark) INTO result
    FROM StudentMarks
    WHERE StudentMarks.StudentId = Id;
    
    RETURN result;
    
    END;
$
DELIMITER ;

UPDATE Students 
SET avgSuccess = CalculateAvgSuc(Students.Id);

SELECT * FROM Students;

DELIMITER $
CREATE TRIGGER avgMark
AFTER INSERT
ON StudentMarks FOR EACH ROW
BEGIN

DECLARE result NUMERIC (7, 6);
    
    SELECT AVG(StudentMarks.Mark) INTO result
    FROM StudentMarks
    WHERE StudentMarks.StudentId = new.StudentId;

UPDATE Students
SET Students.avgSuccess = result
WHERE Students.Id = new.StudentId;

END;
$
DELIMITER ;

INSERT INTO StudentMarks VALUES( 101, 11, '2017-03-04', 6 );

SELECT * FROM Students;

DELIMITER $
CREATE TRIGGER avgMarkdel
AFTER DELETE
ON StudentMarks FOR EACH ROW
BEGIN

DECLARE result NUMERIC (7, 6);
    
    SELECT AVG(StudentMarks.Mark) INTO result
    FROM StudentMarks
    WHERE StudentMarks.StudentId = old.StudentId;

UPDATE Students
SET Students.avgSuccess = result
WHERE Students.Id = old.StudentId;

END;
$
DELIMITER ;

DELETE FROM StudentMarks WHERE StudentMarks.ExamDate = '2017-03-04';

SELECT * FROM Students

DELIMITER $
CREATE TRIGGER avgMarkdelup
AFTER UPDATE
ON StudentMarks FOR EACH ROW
BEGIN

DECLARE result NUMERIC (7, 6);
    
    SELECT AVG(StudentMarks.Mark) INTO result
    FROM StudentMarks
    WHERE StudentMarks.StudentId = old.StudentId;

UPDATE Students
SET Students.avgSuccess = result
WHERE Students.Id = old.StudentId;

END;
$
DELIMITER ;

UPDATE StudentMarks
SET StudentMarks.Mark = 5
WHERE StudentMarks.ExamDate = '2017-03-03';

SELECT * FROM Students;