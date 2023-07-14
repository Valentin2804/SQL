-- CREATE DATABASE notes_app;
USE notes_app;



-- CREATE TABLE Notes(id int auto_increment primary key
	-- 			, note varchar(1000) not null
      --                , dueDate date
        --              , closedOn date);
-- insert into Notes
-- values(null, 'бази данни домашно номер 1', '2022-10-09', null);

-- insert into Notes
-- values(null, 'математика домашно номер 3', '2022-10-05', '2022-10-07');

-- insert into Notes
-- values(null, 'математика в училище номер 1', '2022-10-11', null);

-- insert into Notes
-- values(null, 'бази данни в училище номер 1', '2022-10-10', null);

-- insert into Notes
-- values(null, 'бази данни в училище номер 7', null, null);

-- update Notes set closedOn = '2022-10-11' where closedOn is null && note like '%училище%';

update Notes set closedOn = '2022-10-11' where closedOn is null && note like '%училище%';

select * from Notes;