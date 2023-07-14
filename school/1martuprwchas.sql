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

CREATE VIEW avarageMarkBySub (Name, SubId, avarage)
AS
SELECT Students.Name , m.SubjectId, AVG(m.Mark) 
FROM StudentMarks m
LEFT JOIN Students
ON Students.Id = m.StudentId
GROUP BY m.StudentId, m.SubjectId
ORDER BY m.StudentId, m.SubjectId;

SELECT * FROM avarageMarkBySub;

CREATE VIEW avarageMarkEveryStudent (Name, avarage)
AS
SELECT Students.Name , AVG(m.Mark) 
FROM StudentMarks m
LEFT JOIN Students
ON Students.Id = m.StudentId
GROUP BY m.StudentId
ORDER BY m.StudentId;

DELIMITER $
CREATE FUNCTION CalculateStudentPointsTechnical (name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE result NUMERIC (4, 2);
    DECLARE avarageMath NUMERIC (4, 2);
    DECLARE avaragePhisics NUMERIC (4, 2);
    
    SELECT avarage INTO result
    FROM avarageMarkEveryStudent
    WHERE avarageMarkEveryStudent.Name = name;
    
    SELECT avarage INTO avarageMath
    FROM avarageMarkBySub
    WHERE name = avarageMarkBySub.Name AND avarageMarkBySub.SubId = 13;
    
    SELECT avarage INTO avaragePhisics
    FROM avarageMarkBySub
    WHERE name = avarageMarkBySub.Name AND avarageMarkBySub.SubId = 15;
    
    SET avarageMath = 2*avarageMath;
    SET avaragePhisics = 2*avaragePhisics;
    SET result = result + avarageMath + avaragePhisics;
    
    RETURN result;
    
    END;
$
DELIMITER ;

DELIMITER $
CREATE FUNCTION CalculateStudentPointsHumanitarian (name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE result NUMERIC (4, 2);
    DECLARE avarageBEL NUMERIC (4, 2);
    DECLARE avarageHistory NUMERIC (4, 2);
    
    SELECT avarage INTO result
    FROM avarageMarkEveryStudent
    WHERE avarageMarkEveryStudent.Name = name;
    
    SELECT avarage INTO avarageBEL
    FROM avarageMarkBySub
    WHERE name = avarageMarkBySub.Name AND avarageMarkBySub.SubId = 12;
    
    SELECT avarage INTO avarageHistory
    FROM avarageMarkBySub
    WHERE name = avarageMarkBySub.Name AND avarageMarkBySub.SubId = 11;
    
    SET avarageBEL = 2*avarageBEL;
    SET avarageHistory = 2*avarageHistory;
    SET result = result + avarageBEL + avarageHistory;
    
    RETURN result;
    
    END;
$
DELIMITER ;

SELECT Students.Name,
CASE
WHEN CalculateStudentPointsHumanitarian(Name) > CalculateStudentPointsTechnical(Name) THEN 'hum'
ELSE 'tech'
END AS speciality,
CASE
WHEN CalculateStudentPointsHumanitarian(Name) > CalculateStudentPointsTechnical(Name) THEN CalculateStudentPointsHumanitarian(Name)
ELSE CalculateStudentPointsTechnical(Name)
END AS bal
FROM Students;