
1)
pg_ctl -w -D "C:/Program Files/PostgreSQL/16/data" status
pg_ctl -w -D "C:/Program Files/PostgreSQL/16/data" start
pg_ctl -w -D "C:/Program Files/PostgreSQL/16/data" stop
pg_ctl -w -D "C:/Program Files/PostgreSQL/16/data" restart


2)
psql -U postgres
[1111]

\conninfo

SELECT * FROM pg_database;

CREATE DATABASE testdb;


3)
\c testdb

CREATE TABLE table1 (id INT, name CHAR(8));
INSERT INTO table1 VALUES (10, 'uu'), (77, 'gfhh'), (899, 'ghjk');

\dt


4)
\set test 'HELLO WORLD'
\echo :test
\unset test
\echo :test

SELECT NOW() AS curr_time \gset
\echo :curr_time

SELECT :SERVER_VERSION_NUM >= 100000 AS pgsql10 \gset
\echo pgsql10: :pgsql10

\! echo WAL size: & (du -h -s "C:/Program Files/PostgreSQL/16/data/pg_wal");


5) НЕ РАБОТАЕТ
pg_config --sysconfdir
[.psqlrc | psqlrc.conf]

\set top5 'SELECT tablename, pg_total_relation_size(schemaname||''.''|| tablename) AS bytes FROM pg_tables ORDER BY bytes DESC LIMIT 5;'


7)
\d pg_tables


8)

\i 'C:/University Labs/Databases/Postgres/Files/create.sql'
\i 'C:/University Labs/Databases/Postgres/Files/insert.sql'
\i 'C:/University Labs/Databases/Postgres/Files/delete.sql'


9)
-- вывести роли
\du

SELECT * FROM information_schema.role_table_grants;

CREATE DATABASE roledb;

CREATE ROLE "user" WITH LOGIN PASSWORD 'user';
CREATE ROLE "admin" WITH LOGIN PASSWORD 'admin';

GRANT CONNECT ON DATABASE roledb TO "user";
GRANT CONNECT ON DATABASE roledb TO "admin";

\c roledb
GRANT USAGE, CREATE ON SCHEMA public TO "admin";
GRANT USAGE ON SCHEMA public TO "user";

REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT CREATE ON SCHEMA public TO "admin";

\c roledb admin
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "user";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO "user";

\c roledb user
CREATE TABLE t1 (id INT, name CHAR(8));
-- выведет: отказано в доступе

\c roledb admin
CREATE TABLE t1 (id INT, name CHAR(8));
-- успешно выполнится

\c roledb user
SELECT * FROM t1;
-- разрешено

INSERT INTO t1 (id, name) VALUES (1, 'fjadj');
-- заперещено

-- удалить роли
REASSIGN OWNED BY "admin" TO postgres;
DROP OWNED BY "admin";
DROP ROLE "admin";

REASSIGN OWNED BY "user" TO postgres;
DROP OWNED BY "user";
DROP ROLE "user";

10)
\copy table1 to 'C:/University Labs/Databases/Postgres/Files/dump.txt' with delimiter ',' csv header
\copy table1 from 'C:/University Labs/Databases/Postgres/Files/dump.txt' with delimiter ',' csv header


11)
\dT
CREATE TYPE post AS ENUM('worker', 'teacher');

\dT+ post

SELECT * FROM pg_enum;

-- Изменить значение
ALTER TYPE post RENAME VALUE 'teacher' TO 'teacher1';

-- Удалить значение из типа
UPDATE employ SET post=DEFAULT WHERE post='teacher1';\
DELETE FROM pg_enum WHERE enumlabel='teacher1';

12)
CREATE TABLE employ (id SERIAL, firstname TEXT, lastname TEXT, workdays INTEGER[], post post, salary NUMERIC(7, 2));

\d employ

INSERT INTO employ (firstname, lastname, workdays, post, salary) VALUES
('John', 'Doe',   '{1,1,1,1,1,0,0}', 'worker', 5000.00),
('Jane', 'Smith', '{1,1,1,1,1,1,0}', 'teacher', 6000.00),
('Bob', 'Johnson','{1,0,1,0,1,1,0}', 'worker', 5500.00);


13)
SELECT 
CASE WHEN workdays[2]::bool THEN 'yes' ELSE 'no' END AS is_working_on_tuesday
FROM employ
WHERE id = 2;

SELECT id, firstname, lastname, workdays 
FROM employ
WHERE workdays[3:6] = ARRAY[0, 0];

UPDATE employ SET workdays[1] = 0;

14)
SELECT UPPER(CONCAT(firstname, ' ', lastname)) AS fullname FROM employ;


15)
ALTER TYPE post ADD VALUE 'admin';

ALTER TYPE post DROP VALUE 'admin';


16)
ALTER TABLE employ
ADD COLUMN vacation_startdate DATE,
ADD COLUMN vacation_duration INTEGER;

UPDATE employ
SET vacation_startdate = '2023-01-01', vacation_duration = 12
WHERE id = 3;


17)
UPDATE employ
SET vacation_startdate = vacation_startdate + INTERVAL '14 days'
WHERE id = 3;


18)
ALTER TABLE employ
ADD COLUMN birthdate INTEGER;

UPDATE employ
SET birthdate = 19900926
WHERE id = 1;

-- Поменять дату INT на DATE
ALTER TABLE employ
ALTER COLUMN birthdate TYPE DATE
USING TO_DATE(birthdate::TEXT, 'YYYYMMDD');

-- Поменять дату DATE на INT
ALTER TABLE employ
ALTER COLUMN birthdate TYPE INTEGER
USING TO_CHAR(birthdate, 'YYYYMMDD')::INTEGER;

---- обновить auto-increment поля id
ALTER SEQUENCE employ_id_seq RESTART WITH 1;
UPDATE employ SET "id"=nextval('employ_id_seq');
----

INSERT INTO employ (firstname, lastname, workdays, post, salary, vacation_startdate, vacation_duration, birthdate)
VALUES
  ('Alice', 'Smith', '{1,1,1,1,1,0,0}', 'worker', 5500.00, '2023-03-01', 14, '1992-03-01'),
  ('Bob', 'Johnson', '{1,0,1,0,1,1,0}', 'worker', 6000.00, '2023-03-15', 10, '1992-10-15'),
  ('Charlie', 'Williams', '{1,1,1,1,1,1,0}', 'admin', 7000.00, '2023-04-01', 7, '1993-04-01'),
  ('David', 'Brown', '{1,1,0,1,1,1,0}', 'teacher', 5000.00, '2023-05-01', 21, '1995-05-01'),
  ('Eva', 'Davis', '{1,0,1,0,1,0,1}', 'worker', 5800.00, '2023-06-01', 14, '1996-06-01'),
  ('Frank', 'Miller', '{1,1,1,0,1,1,0}', 'teacher', 6200.00, '2023-07-01', 7, '1997-07-01'),
  ('Grace', 'Anderson', '{1,1,1,1,1,0,0}', 'worker', 6800.00, '2023-08-01', 14, '1998-08-01'),
  ('Harry', 'White', '{1,1,1,1,1,0,0}', 'worker', 6000.00, '2023-09-01', 14, '1999-09-01'),
  ('Ivy', 'Johnson', '{1,1,1,1,1,0,0}', 'teacher', 5200.00, '2023-10-01', 14, '2000-10-01'),
  ('Jack', 'Harris', '{1,1,1,1,1,0,0}', 'admin', 7500.00, '2023-11-01', 14, '2001-11-01');