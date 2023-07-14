DROP DATABASE IF EXISTS Library;
CREATE DATABASE Library;

USE Library;

CREATE TABLE Authors(id INTEGER AUTO_INCREMENT PRIMARY KEY
					, FirstName VARCHAR(50)
                    , LastName VARCHAR(50));

CREATE TABLE Books(id INTEGER AUTO_INCREMENT PRIMARY KEY
					, title VARCHAR(150) NOT NULL
                    , DateOfLaunch DATE
                    , isbn VARCHAR(17) NOT NULL);
                    
CREATE TABLE AuthorsBooks(AuthorId INTEGER
						, BookId INTEGER
                        
                        , FOREIGN KEY (AuthorId) REFERENCES Authors(id)
                        , FOREIGN KEY (BookId) REFERENCES Books(id));

INSERT INTO Authors (FirstName, LastName)
VALUES ('Георги', 'Господинов')
	, ('Захари', 'Карабашлиев')
	, ('Момчил', 'Николов')
	, ('Виктор', 'Пасков')
	, ('Станислава', 'Станоева')
	, ('Благой', 'Иванов')
	, ('Благой', 'Георгиев');
    
INSERT INTO Books (title, DateOfLaunch, isbn)
VALUES ('Смълчани поля', '2010-05-19', '978-5-1696-7241-1')
	, ('Зимна приказка', '2010-05-31', '0-1400-8816-4')
    , ('Под елхата', '2010-01-07', '0-1477-3245-X')
    , ('Върхът на вселената', '2015-01-20', '978-5-8860-8313-2')
    , ('Всички са хора', '2016-12-30', '978-6-5004-6385-9')
    , ('Високата планина', '2012-10-06', '0-1109-3268-0')
    , ('Изкуството да прощаваш', '2012-10-06', '0-1109-3468-0')
    , ('Нейните очи', '2022-05-05', '978-6-9066-0979-9')
    , ('Никога не казвай никога', '2022-05-05', '978-6-9066-0989-9')
    , ('Небето не е граница', '2022-05-05', '978-6-9066-0999-9');
    
INSERT INTO AuthorsBooks 
VALUES (1, 1)
	, (2, 2)
    , (3, 3)
    , (4, 4)
    , (5, 5)
    , (1, 6)
    , (3, 6)
    , (4, 6)
    , (3, 7)
    , (4, 7)
    , (5, 8)
    , (1, 9)
    , (5, 9)
    , (5, 10)
    , (4, 10)
    , (3, 10);

SELECT Books.title
FROM Books
WHERE Books.DateOfLaunch BETWEEN '2010-01-01' AND '2010-12-31';

SELECT Books.title, Books.DateOfLaunch, Books.isbn
FROM Books
LEFT JOIN AuthorsBooks
ON AuthorsBooks.BookId = Books.id
LEFT JOIN Authors
ON Authors.Id = AuthorsBooks.AuthorId
WHERE Authors.FirstName = 'Георги' AND Authors.LastName = 'Господинов';

SELECT Authors.FirstName, Authors.LastName
FROM Authors
LEFT JOIN AuthorsBooks
ON AuthorsBooks.AuthorId = Authors.id
LEFT JOIN Books
ON AuthorsBooks.BookId = Books.id
WHERE Books.isbn = '0-1109-3268-0';

SELECT Authors.FirstName, Authors.LastName, COUNT(AuthorsBooks.BookId)
FROM Authors
LEFT JOIN AuthorsBooks
ON Authors.id = AuthorsBooks.AuthorId
GROUP BY Authors.FirstName, Authors.LastName
ORDER BY COUNT(AuthorsBooks.BookId) DESC, Authors.FirstName ASC, Authors.LastName ASC;

SELECT Books.title, COUNT(AuthorsBooks.AuthorId)
FROM Books
LEFT JOIN AuthorsBooks
ON Books.id = AuthorsBooks.BookId
GROUP BY Books.title
HAVING COUNT(AuthorsBooks.AuthorId) > 1
ORDER BY Books.title ASC;