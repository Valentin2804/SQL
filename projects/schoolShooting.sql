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

CREATE TABLE Teachers(
	Id INTEGER AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150)
);

INSERT INTO Students(Id, Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 101, 'Зюмбюл Петров', 10, 11, 'а', '1999-02-28', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Исидор Иванов', 15, 10, 'б', '2000-02-29', '0042294120' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Панчо Лалов', 20, 10, 'б', '2000-05-01', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Петраки Ганьов', 20, 10, 'а', '1999-12-25', '9912256301' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Александър Момчев', 1, 8, 'а', '2002-06-11', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Благой Георгиев', 3, 9, 'б', '2000-03-01', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Момчил Момчилов', 15, 12, 'г', '1998-02-28', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Александър Драгомиров', 1, 7, 'ж', '2005-07-10', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Георги Драгомиров', 9, 7, 'ж', '2005-07-10', NULL );

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
INSERT INTO StudentMarks VALUES( 105, 11, '2017-04-07', 5.50 );
INSERT INTO StudentMarks VALUES( 105, 12, '2017-04-07', 3.50 );
INSERT INTO StudentMarks VALUES( 106, 12, '2017-04-07', 5.00 );
INSERT INTO StudentMarks VALUES( 107, 13, '2017-04-07', 2.00 );
INSERT INTO StudentMarks VALUES( 109, 13, '2017-04-07', 6.00 );

INSERT INTO MarkWords VALUES( 2, 2.50, 'Слаб' );
INSERT INTO MarkWords VALUES( 2.50, 3.50, 'Среден' );
INSERT INTO MarkWords VALUES( 3.50, 4.50, 'Добър' );
INSERT INTO MarkWords VALUES( 4.50, 5.50, 'Мн. добър' );
INSERT INTO MarkWords VALUES( 5.50, 6, 'Отличен' );

INSERT INTO Teachers(Name) VALUES('Иван');
INSERT INTO Teachers(Name) VALUES('Николай');
INSERT INTO Teachers(Name) VALUES('Мария');

SELECT Name, CONCAT(ClassNum, ClassLetter) as Position
FROM Students
WHERE Students.ClassNum = 8 || Students.ClassNum = 9 || Students.ClassNum = 11
UNION ALL
SELECT Name, 'Преподавател'
FROM Teachers
ORDER BY 1;

SELECT *
FROM(
SELECT Students.Name, Students.ClassNum, CONCAT(ClassNum, ClassLetter) as Class, AVG(StudentMarks.Mark) as Average
FROM Students
LEFT JOIN StudentMarks
ON Students.id = StudentMarks.studentId
GROUP BY Students.id
HAVING AVG(StudentMarks.Mark) IS NOT NULL
ORDER BY average DESC
LIMIT 3
) AS T1
UNION
SELECT *
FROM((
SELECT Students.Name, Students.ClassNum, CONCAT(ClassNum, ClassLetter) as Class, AVG(StudentMarks.Mark) as Average
FROM Students
LEFT JOIN StudentMarks
ON Students.id = StudentMarks.studentId
GROUP BY Students.id
HAVING AVG(StudentMarks.Mark) IS NOT NULL
ORDER BY average ASC
LIMIT 3
)ORDER BY Average DESC) AS T2;

CREATE VIEW AvarageMarks
(Class, AvarageMark)
AS
SELECT CONCAT(ClassNum, ClassLetter), AVG(StudentMarks.Mark)
FROM Students
LEFT JOIN StudentMarks
ON Students.id = StudentMarks.studentId
GROUP BY Students.ClassNum, Students.ClassLetter;

SELECT * FROM AvarageMarks;

SELECT CONCAT(ClassNum, ClassLetter) AS Class, Students.name, AVG(StudentMarks.Mark), AvarageMarks.AvarageMark
FROM Students
LEFT JOIN StudentMarks
ON Students.id = StudentMarks.studentId
LEFT JOIN AvarageMarks
ON AvarageMarks.Class = Class
GROUP BY Students.Name
HAVING AVG(StudentMarks.Mark) > AvarageMarks.AvarageMark;

