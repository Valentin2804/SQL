DROP DATABASE IF EXISTS Functions;
CREATE DATABASE Functions;

USE Functions;

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

INSERT INTO Students(Id, Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 101, 'Зюмбюл Петров', 10, 11, 'а', '1999-02-28', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Исидор Иванов', 15, 10, 'б', '2000-02-29', '0042294120' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Панчо Лалов', 20, 10, 'б', '2000-05-01', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Петраки Ганьов', 20, 10, 'а', '1999-12-25', '9912256301' );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Александър Момчев', 1, 8, 'а', '2002-06-11', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Благой Георгиев', 3, 9, 'б', '2000-03-01', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Момчил Момчилов', 15, 12, 'г', '1998-02-28', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Александър Драгомиров', 1, 7, 'ж', '2005-07-10', NULL );
INSERT INTO Students(Name, Num, ClassNum, ClassLetter, Birthday, EGN) VALUES( 'Георги Драгомиров', 9, 7, 'ж', '2005-07-10', NULL );

DELIMITER $
CREATE FUNCTION Fibonachi(n INT)
RETURNS BIGINT
DETERMINISTIC
BEGIN 
	DECLARE i INT;
    DECLARE Fib BIGINT;
    DECLARE LastFib BIGINT;
    
    IF n = 0 THEN RETURN 0; END IF;
    
    SET i = 1;
    SET Fib = 1;
    SET LastFib = 0;
    
    WHILE i < n DO
		SET Fib = Fib + LastFib;
        SET LastFib = Fib - LastFib;
        SET i = i + 1;
	END WHILE;
    RETURN Fib;
END;
$
DELIMITER ;

SELECT Num, Fibonachi(Num) FROM Students;