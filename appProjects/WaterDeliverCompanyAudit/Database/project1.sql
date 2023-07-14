

CREATE DATABASE waterDeliver;



USE waterDeliver;

CREATE TABLE market(id INTEGER AUTO_INCREMENT PRIMARY KEY
					, name VARCHAR(50) NOT NULL
                    , address VARCHAR(150) NOT NULL
                    , moneyPerOrder INTEGER NOT NULL
                    , endContract DATETIME NOT NULL);
                    
CREATE TABLE workers(id INTEGER AUTO_INCREMENT PRIMARY KEY
					, name VARCHAR(100) NOT NULL
                    , egn CHAR(10) NOT NULL
                    , salaryPerOrder INTEGER NOT NULL
                    , endContract DATETIME NOT NULL);
                    
CREATE TABLE Orders(id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
					, workerId INTEGER NOT NULL
					, marketId INTEGER NOT NULL
				
					, FOREIGN KEY (workerId) REFERENCES workers(id)
					, FOREIGN KEY (marketId) REFERENCES market(id));
                            
CREATE TABLE OrdersHistory(UID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
							, beginDate DATETIME NOT NULL
                            , endDate DATETIME
							, id INTEGER
							, marketId INTEGER
							, workerId INTEGER);
                           
CREATE TABLE MarketsHistory(UID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
							, beginDate DATETIME NOT NULL
                            , endDate DATETIME
							, id INTEGER
							, name VARCHAR(50) 
							, address VARCHAR(150)
                            , moneyPerOrder INTEGER
                            , endContract DATETIME);
                            
CREATE TABLE WorkersHistory(UID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
							, beginDate DATETIME NOT NULL
                            , endDate DATETIME
							, id INTEGER
							, name VARCHAR(50)
							, egn CHAR(10)
                            , salaryPerOrder INTEGER
                            , endContract DATETIME);

DELIMITER $
CREATE TRIGGER WorkersInsert AFTER INSERT ON workers 
FOR EACH ROW BEGIN
INSERT INTO WorkersHistory (beginDate, endDate, id, name, egn, salaryPerOrder, endContract)
VALUES(NOW(), null, NEW.id, NEW.name, NEW.egn, NEW.salaryPerOrder, NEW.endContract);
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER WorkersUpdate AFTER Update ON workers 
FOR EACH ROW BEGIN

UPDATE WorkersHistory SET endDate = NOW()
WHERE id = OLD.id AND endDate IS NULL;

INSERT INTO WorkersHistory (beginDate, endDate, id, name, egn, salaryPerOrder, endContract)
VALUES(NOW(), null, NEW.id, NEW.name, NEW.egn, NEW.salaryPerOrder, NEW.endContract);
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER WorkersDelete AFTER Delete ON workers 
FOR EACH ROW BEGIN
UPDATE WorkersHistory SET endDate = NOW()
WHERE id = OLD.id AND endDate IS NULL;
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER MarketInsert AFTER INSERT ON market 
FOR EACH ROW BEGIN
INSERT INTO MarketsHistory (beginDate, endDate, id, name, address, moneyPerOrder, endContract)
VALUES(NOW(), null, NEW.id, NEW.name, NEW.address, NEW.moneyPerOrder, NEW.endContract);
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER MarketUpdate AFTER Update ON market 
FOR EACH ROW BEGIN

UPDATE MarketsHistory SET endDate = NOW()
WHERE id = OLD.id AND endDate IS NULL;

INSERT INTO MarketsHistory (beginDate, endDate, id, name, address, moneyPerOrder, endContract)
VALUES(NOW(), null, NEW.id, NEW.name, NEW.address, NEW.moneyPerOrder, NEW.endContract);
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER MarketsDelete AFTER Delete ON market 
FOR EACH ROW BEGIN
UPDATE MarketsHistory SET endDate = NOW()
WHERE id = OLD.id AND endDate IS NULL;
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER OrdersInsert AFTER INSERT ON Orders 
FOR EACH ROW BEGIN
INSERT INTO OrdersHistory (beginDate, endDate, id, marketId, workerId)
VALUES(NOW(), null, NEW.id, NEW.marketId, NEW.workerId);
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER OrdersUpdate AFTER Update ON Orders 
FOR EACH ROW BEGIN

UPDATE OrdersHistory SET endDate = NOW()
WHERE id = OLD.id AND endDate IS NULL;

INSERT INTO OrdersHistory (beginDate, endDate, id, marketId, workerId)
VALUES(NOW(), null, NEW.id, NEW.marketId, NEW.workerId);
END
$
DELIMITER ;

DELIMITER $
CREATE TRIGGER OrdersDelete AFTER Delete ON Orders 
FOR EACH ROW BEGIN
UPDATE OrdersHistory SET endDate = NOW()
WHERE id = OLD.id AND endDate IS NULL;
END
$
DELIMITER ;

INSERT INTO market (name, address, moneyPerOrder, endContract) 
VALUES("ivel", "stelbishte11", 40, "2023-06-30")
	, ("billa", "levskiG 18", 30, "2023-05-31")
    , ("lidl", "zona B5 23", 20, "2023-06-30");
    
INSERT INTO workers (name, egn, salaryPerOrder, endContract)
VALUES("Ivan", "1234567890", 5, "2023-06-30")
	, ("Matey", "3456789012", 6, "2023-05-31");
    
INSERT INTO Orders (marketId, workerId)
VALUES(1, 2)
	, (2, 2)
    , (2, 2)
    , (3, 1)
    , (2, 1)
    , (3, 2)
    , (2, 1);
    


UPDATE workers SET endContract = "2023-06-30", salaryPerOrder = 10 WHERE id = 2;

UPDATE market SET endContract = "2023-06-30", moneyPerOrder = 20 WHERE id = 2;

SELECT * FROM MarketsHistory;

DELETE FROM Orders WHERE id = 1;
DELETE FROM Orders WHERE id = 4;

UPDATE Orders SET workerId = 2 WHERE id = 5;
UPDATE Orders SET workerId = 1 WHERE id = 2;
UPDATE Orders SET workerId = 1 WHERE id = 3;

DELETE FROM Orders WHERE id = 2;

DELETE FROM Orders WHERE id = 3;

SELECT market.name, market.address, workers.name, workers.egn
FROM Orders
LEFT JOIN market
ON market.id = Orders.marketId
LEFT JOIN workers
ON workers.id = Orders.workerId;

SELECT * FROM OrdersHistory;

SELECT oldOH.UID, oldOH.beginDate, oldOH.endDate, oldOH.id, MarketsHistory.name, MarketsHistory.moneyPerOrder, WorkersHistory.name, WorkersHistory.salaryPerOrder
FROM OrdersHistory oldOH
LEFT JOIN MarketsHistory
ON MarketsHistory.id = oldOH.marketId 
AND MarketsHistory.beginDate <= oldOH.endDate 
AND MarketsHistory.endContract >= oldOH.endDate
LEFT JOIN WorkersHistory
ON WorkersHistory.id = oldOH.workerId 
AND WorkersHistory.beginDate <= oldOH.endDate 
AND WorkersHistory.endContract >= oldOH.endDate
LEFT JOIN OrdersHistory newOH
ON newOH.UID > oldOH.UID AND newOH.id = oldOH.id 
WHERE oldOH.endDate >= '2023-06-01' AND oldOH.endDate <= '2023-06-30';