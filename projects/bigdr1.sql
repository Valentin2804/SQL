DROP DATABASE IF EXISTS PlayerStats;
-- 1
CREATE DATABASE PlayerStats;

USE PlayerStats;
-- 2
CREATE TABLE StatTypes(StatCode VARCHAR(3) PRIMARY KEY
						, name VARCHAR(13));

INSERT INTO StatTypes VALUES('G', 'Гол');
INSERT INTO StatTypes VALUES('A', 'Асистенция');
INSERT INTO StatTypes VALUES('R', 'Червен картон');
INSERT INTO StatTypes VALUES('Y', 'Жълт картон');
INSERT INTO StatTypes VALUES('OG', 'Автогол');
INSERT INTO StatTypes VALUES('IN', 'Смяна влиза');
INSERT INTO StatTypes VALUES('OUT', 'Смяна излиза');

-- 3
CREATE TABLE Positions(PositionCode CHAR(2) PRIMARY KEY
						, name VARCHAR(19));

INSERT INTO Positions VALUES('GK', 'Вратар');
INSERT INTO Positions VALUES('RB', 'Десен защитник');
INSERT INTO Positions VALUES('LB', 'Ляв защитник');
INSERT INTO Positions VALUES('CB', 'Централен защитник');
INSERT INTO Positions VALUES('RM', 'Десен полузащитник');
INSERT INTO Positions VALUES('LM', 'Ляв полузащитник');
INSERT INTO Positions VALUES('CM', 'Полузащитник');
INSERT INTO Positions VALUES('CF', 'Централен нападател');

-- 4
CREATE TABLE Players(id INTEGER AUTO_INCREMENT PRIMARY KEY
					, name VARCHAR(50) NOT NULL
                    , num INTEGER
                    , PositionCode CHAR(2)
                    
                    , FOREIGN KEY (PositionCode) REFERENCES Positions (PositionCode));

INSERT INTO Players(name, num, PositionCode) VALUES('Ivaylo Trifonov', 1, 'GK');
INSERT INTO Players(name, num, PositionCode) VALUES('Valko Trifonov', 2, 'RB');
INSERT INTO Players(name, num, PositionCode) VALUES('Ognyan Yanev', 3, 'CB');
INSERT INTO Players(name, num, PositionCode) VALUES('Zahari Dragomirov', 4, 'CB');
INSERT INTO Players(name, num, PositionCode) VALUES('Bozhidar Chilikov', 5, 'LB');
INSERT INTO Players(name, num, PositionCode) VALUES('Timotei Zahariev', 6, 'CM');
INSERT INTO Players(name, num, PositionCode) VALUES('Marin Valentinov', 7, 'CM');
INSERT INTO Players(name, num, PositionCode) VALUES('Mitre Cvetkov', 99, 'CF');
INSERT INTO Players(name, num, PositionCode) VALUES('Zlatko Genov', 9, 'CF');
INSERT INTO Players(name, num, PositionCode) VALUES('Matey Goranov', 10, 'RM');
INSERT INTO Players(name, num, PositionCode) VALUES('Sergei Zhivkov', 11, 'LM');

-- 5
CREATE TABLE Tournaments (id INTEGER PRIMARY KEY AUTO_INCREMENT
							, name VARCHAR(21));
                            
INSERT INTO Tournaments (name) VALUE('Шампионска лига');
INSERT INTO Tournaments (name) VALUE('Първа лига');
INSERT INTO Tournaments (name) VALUE('Купа на България');
INSERT INTO Tournaments (name) VALUE('Суперкупа на България');

-- 6

CREATE TABLE Matches (id INTEGER AUTO_INCREMENT PRIMARY KEY
						, MatchDate DATE
                        , TournamentId INTEGER NOT NULL
                        
                        , FOREIGN KEY (TournamentId) REFERENCES Tournaments (Id));

INSERT INTO Matches(MatchDate, TournamentId) VALUES('2018-04-08', 2);
INSERT INTO Matches(MatchDate, TournamentId) VALUES('2018-04-13', 2);
INSERT INTO Matches(MatchDate, TournamentId) VALUES('2018-04-21', 2);
INSERT INTO Matches(MatchDate, TournamentId) VALUES('2018-04-28', 2);
INSERT INTO Matches(MatchDate, TournamentId) VALUES('2018-05-06', 2);
INSERT INTO Matches(MatchDate, TournamentId) VALUES('2018-05-11', 2);
INSERT INTO Matches(MatchDate, TournamentId) VALUES('2017-09-21', 3);
INSERT INTO Matches(MatchDate, TournamentId) VALUES('2017-10-26', 3);

-- 7
CREATE TABLE MatchStats (Id INTEGER AUTO_INCREMENT PRIMARY KEY
						, MatchId INTEGER NOT NULL
                        , PlayerId INTEGER NOT NULL
                        , EventMinute INTEGER NOT NULL
                        , StatCode VARCHAR(3) NOT NULL
                        
                        , FOREIGN KEY (MatchId) REFERENCES Matches (Id)
                        , FOREIGN KEY (PlayerId) REFERENCES Players (Id)
                        , FOREIGN KEY (StatCode) REFERENCES StatTypes (StatCode));
                        
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (8, 9, 14, 'G');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (8, 8, 14, 'A');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (8, 3, 43, 'Y');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (7, 2, 28, 'Y');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (7, 10, 45, 'Y');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (7, 10, 65, 'R');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (1, 10, 23, 'G');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (1, 9, 23, 'A');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (1, 9, 43, 'G');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (2, 4, 33, 'OG');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (2, 9, 68, 'G');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (2, 1, 68, 'A');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (3, 3, 35, 'G');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (3, 4, 35, 'A');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (3, 8, 55, 'G');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (3, 11, 55, 'A');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (4, 3, 9, 'G');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (4, 8, 9, 'G');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (4, 8, 56, 'OG');
INSERT INTO MatchStats (MatchId, PlayerId, EventMinute, StatCode) VALUES (5, 8, 67, 'G');

-- 8
SELECT Players.Name, Players.Num
FROM Players
WHERE Players.PositionCode LIKE 'LB'
OR Players.PositionCode LIKE 'RB'
OR Players.PositionCode LIKE 'CB';

-- 9
SELECT Matches.MatchDate, Tournaments.name
FROM Matches
LEFT JOIN Tournaments
ON Matches.TournamentId LIKE Tournaments.Id
WHERE Matches.MatchDate <= '2018-04-30'
AND Matches.MatchDate >= '2018-04-01';

-- 10
SELECT Matches.MatchDate
	, Players.name
    , Players.Num
    , MatchStats.EventMinute
    , StatTypes.Name
FROM Players
INNER JOIN MatchStats
ON Players.Id LIKE MatchStats.PlayerId AND Players.Num = 99
LEFT JOIN Matches
ON MatchStats.MatchId LIKE Matches.Id
LEFT JOIN StatTypes
ON MatchStats.StatCode LIKE StatTypes.StatCode;

-- 11
SELECT COUNT(*)
FROM MatchStats
WHERE MatchStats.StatCode LIKE 'OG';

-- 12
SELECT Matches.MatchDate, COUNT(*) 
FROM Matches
LEFT JOIN MatchStats
ON MatchStats.MatchId LIKE Matches.Id
WHERE Matches.MatchDate < '2018-05-01' AND MatchStats.StatCode LIKE 'G'
GROUP BY MatchDate;

-- 13
SELECT Positions.name, COUNT(MatchStats.StatCode)
FROM MatchStats
RIGHT JOIN Players
ON MatchStats.PlayerId LIKE Players.Id AND MatchStats.StatCode LIKE 'G'
LEFT JOIN Positions
ON Players.PositionCode LIKE Positions.PositionCode
WHERE MatchStats.StatCode IS NULL OR MatchStats.StatCode IS NOT NULL
GROUP BY name;

-- 14
SELECT Players.name, Players.Num, Positions.name, COUNT(MatchStats.StatCode)
FROM MatchStats
RIGHT JOIN Players
ON MatchStats.PlayerId LIKE Players.Id
LEFT JOIN Positions
ON Players.PositionCode LIKE Positions.PositionCode
WHERE MatchStats.StatCode IS NOT NULL AND (MatchStats.StatCode LIKE 'Y' OR MatchStats.StatCode LIKE 'R')
GROUP BY Players.name
ORDER BY COUNT(MatchStats.StatCode) DESC, Players.name ASC;