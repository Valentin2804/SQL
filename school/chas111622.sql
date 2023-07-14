use school;

 -- create table Students2(
	-- 			 id int auto_increment primary key,
      --           name varchar(150) NOT NULL,
        --         nInClass smallint,
          --       class varchar(3) NOT NULL,
            --     egn char(10),
              --   birthday date,
                -- enteranceExam numeric(3, 2)
                  -- );

-- create table StudentMarks(
	-- 				id int auto_increment primary key,
      --               studentid int not null,
        --             subject varchar(50),
          --           examDate date,
            --         mark numeric(3, 2)
              --       )

 -- create table MarksAsWord(
	-- 				 minmark numeric(3, 2),
       --               maxmark numeric(3, 2),
          --           markword varchar(9)
			-- 	        );

 -- insert into Students2 values (null, 'Valentin', 5, '11A', 0884723451, '2005-04-28', 5.50);
 -- insert into Students2 values (null, 'Krum', 17, '10B', 5378125111, '1999-12-13', 5.51);
 -- insert into Students2 values (null, 'Koko', 14, '12K', 1819191451, '2019-04-07', 5.52);
 -- insert into Students2 values (null, 'Vesko', 7, '2E', 1878187818, '2003-07-15', 6.00);
 -- insert into Students2 values (null, 'Nikich', 20, '10A', 1718112309, '2007-08-29', 2.50);

-- insert into StudentMarks values (null, 1, 'БД', '2022-10-10', 5.50);
-- insert into StudentMarks values (null, 1, 'мат', '2022-11-10', 5.60);
-- insert into StudentMarks values (null, 2, 'бел', '2022-09-20', 3.50);
-- insert into StudentMarks values (null, 2, 'мат', '2022-11-10', 2.00);
-- insert into StudentMarks values (null, 3, 'БД', '2022-10-10', 4.50);
-- insert into StudentMarks values (null, 3, 'био', '2022-12-12', 3.29);
-- insert into StudentMarks values (null, 4, 'БД', '2022-10-10', 3.69);
-- insert into StudentMarks values (null, 4, 'история', '2022-10-29', 3.00);
-- insert into StudentMarks values (null, 5, 'мат', '2022-11-10', 2.00);
-- insert into StudentMarks values (null, 5, 'ГО', '2022-10-01', 4.99);

-- insert into MarksAsWord values(2.00, 2.49, 'Слаб');
-- insert into MarksAsWord values(2.50, 3.49, 'Среден');
-- insert into MarksAsWord values(3.50, 4.49, 'Добър');
-- insert into MarksAsWord values(4.50, 5.49, 'Мн. добър');
-- insert into MarksAsWord values(5.50, NULL, 'Отличен');

-- select name, nInClass, class, subject, markword, mark
-- from Students2 //  !StudentMarks!
-- inner join StudentMarks // !Students2!
-- on StudentMarks.studentid = Students2.id && StudentMarks.mark > 3.50
-- left join MarksAsWord
-- on StudentMarks.mark < MarksAsWord.maxmark && StudentMarks.mark >= MarksAsWord.minmark;
-- OR is null

select name, nInClass, class
from Students2
left join StudentMarks
on StudentMarks.studentid = Students2.id && StudentMarks.subject = 'БД'
where StudentMarks.id is null;