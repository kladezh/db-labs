
1) 
SELECT firstname, post, salary, AVG(salary) OVER (PARTITION BY post) AS avg_salary FROM employ;

SELECT firstname, post, salary, SUM(salary) OVER (PARTITION BY post) as salary_sum FROM employ;

SELECT firstname, post, salary, RANK() OVER (PARTITION BY post ORDER BY salary DESC) AS salary_rank FROM employ;


2)
CREATE TABLE tran_table (id SERIAL, name TEXT);
INSERT INTO tran_table (name) VALUES ('SLAVAN');

a)
BEGIN ISOLATION LEVEL REPEATABLE READ;
BEGIN;
COMMIT;
ROLLBACK;

SELECT * FROM tran_table;
DELETE FROM tran_table;


б)
-- заблочить все операции
LOCK TABLE tran_table IN ACCESS EXCLUSIVE MODE;

-- заблочить всё, кроме чтения
LOCK TABLE tran_table IN SHARE MODE;

SAVEPOINT sp1;
ROLLBACK TO SAVEPOINT sp1;


3)
WITH worker AS (
  SELECT CONCAT(firstname, ' ', lastname) AS name, salary
  FROM employ
  WHERE post = 'worker'
)
SELECT *
FROM worker
WHERE salary > 5000;

--

WITH avg_sal AS (
    SELECT post, AVG(salary) AS average_salary
    FROM employ 
    GROUP BY post
)

SELECT 
    e.id,
    e.firstname,
    e.lastname,
    e.post,
    e.salary,
    a.average_salary
FROM employ AS e
JOIN avg_sal AS a ON a.post = e.post;

-- 

CREATE TABLE geo (
    id int not null primary key, 
    parent_id int references geo(id),  
    name varchar(1000)
);

INSERT INTO geo 
(id, parent_id, name) 
VALUES 
(1, null, 'Планета Земля'),
(2, 1, 'Континент Евразия'),
(3, 1, 'Континент Северная Америка'),
(4, 2, 'Европа'),
(5, 4, 'Россия'),
(6, 4, 'Германия'),
(7, 5, 'Москва'),
(8, 5, 'Санкт-Петербург'),
(9, 6, 'Берлин');

WITH RECURSIVE r AS (
   SELECT id, parent_id, name
   FROM geo
   WHERE parent_id = 4

   UNION

   SELECT geo.id, geo.parent_id, geo.name
   FROM geo
      JOIN r
          ON geo.parent_id = r.id
)

SELECT * FROM r;

--

WITH RECURSIVE t(i) AS (
    SELECT 1 AS i

    UNION

    SELECT i+1 FROM t WHERE i < 100
)
SELECT sum(i) FROM t;

--

4)
\df
SELECT prosrc FROM pg_proc WHERE proname = 'get_employ_info';

DROP FUNCTION get_employ_info;
SELECT * FROM get_employ_info(1);

CREATE OR REPLACE FUNCTION get_employ_info(employ_id INT)
RETURNS TABLE(name TEXT, post TEXT)
AS $$
    SELECT
        CONCAT(firstname, ' ', lastname) AS name,
        employ.post::TEXT as post
    FROM
        employ
    WHERE
        employ.id = employ_id;
$$ LANGUAGE SQL;


5)
SELECT * FROM get_employees_by_salary(6000.00, 7000.00) ORDER BY salary ASC;

CREATE OR REPLACE FUNCTION get_employees_by_salary(min_salary NUMERIC, max_salary NUMERIC)
RETURNS TABLE(id INT, firstname TEXT, lastname TEXT, salary NUMERIC)
AS $$
    SELECT
        employ.id,
        employ.firstname,
        employ.lastname,
        employ.salary
    FROM
        employ
    WHERE
        employ.salary BETWEEN min_salary AND max_salary;
$$ LANGUAGE SQL;


6)
SELECT * FROM get_employee_info_uppercase();

CREATE OR REPLACE FUNCTION get_employee_info_uppercase()
RETURNS TABLE(lastname_upper TEXT, salary NUMERIC)
AS $$
    SELECT
        UPPER(employ.lastname) AS lastname_upper,
        employ.salary
    FROM
        employ;
$$ LANGUAGE SQL;
