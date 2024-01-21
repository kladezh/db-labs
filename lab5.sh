
#  	SELECT random()*(b-a)+a;
# b - верхняя граница, a - нижняя граница

1)

# генерация чисел в указанном промежутке
SELECT * FROM generate_series(1,5);

# генерация даты за указанныфй промежуток с указанным шагом
SELECT date( generate_series(now(), now() + '1week','1day') );

# генерация таблицы с ключами от 1 до 10 в первом столбце
# случайными числами от 0 до 100 с 2 знаками после запятой во втором столбце
# строкой состоящей из символа «1» длинной от 1 до 25 символов:  в третьем столбце
SELECT 
    generate_series(1,10) AS key, 
    (random() * 100)::numeric(4,2), repeat ('1', (random() * 25)::integer);

# генерация 3 чисел в промежутке от 22 до 43
SELECT (random() * 21 + 22)::int AS size FROM generate_series(1,3);

# генерирует 3 строки странного текста. с помощью 128-битный алгоритм хеширования
SELECT md5(random()::text) AS product_name FROM generate_series(1, 3);

# 5 раз выбирает случайный цвет из массива с цветами
SELECT (array['red', 'green', 'blue'])[ceil(random() * 3)] AS color FROM generate_series(1, 5);

# преобразовывает 3 числа в булевые значения
SELECT random()::int::bool FROM generate_series(1, 3);


2)

# считает записи в таблице
SELECT count(*) FROM employ;

# подсчитывает примерно 1% из общего количества строк
SELECT round((count(*) * 0.01)::numeric, 4) AS one_percent_count
FROM employ;


3)

# создает случайную дату, добавляя к начальной дате (в Unix-формате 1388534400)
# случайное количество секунд (от 0 до 63071999 секунд).
SELECT to_timestamp(1388534400 + random() * 63071999);

# генерирует 10 различных дат путем вычитания различных интервалов из текущей даты 
SELECT now() - interval '1 day' * round(random() * 467) - interval '1 hour' * round(random() * 100) - interval '1 minute' * round(random() * 100) 
FROM generate_series(1, 10);

# создаст случайные даты в прошлом, вычитая случайный интервал в диапазоне от 0 до 19 дней от 
# текущей даты для каждой строки в диапазоне от 1 до 3
SELECT now() - (floor(random() * 20) || ' days')::interval AS date 
FROM generate_series(1, 3);


4)

# выводит таблицу с различными случайными данными, представляющими товары.
SELECT 
    generate_series(1, 5) AS id, 
    md5(random()::text)::char(10) AS name, 
    (random() * 1000)::numeric(10, 2) AS price, 
    (random() * 21 + 22)::int AS size, 
    (array['cyan', 'magenta'])[(ceil(random() * 2))] AS color, 
    (now() - interval '1 day' * round(random() * 100))::timestamp(0) AS updated_at, 
    (now() - interval '2 year' + interval '1 year' * random())::date AS built, 
    random()::int::bool AS is_available;


5)
#######
CREATE TABLE tran_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(32),
    salary INTEGER,
    post VARCHAR(32),
    employ_date DATE
);

INSERT INTO tran_table (name, salary, post, employ_date)
    SELECT
        regexp_replace(md5(random()::text)::varchar(32), '\d', '', 'g') AS name,
        (random() * (9999 - 1000) + 1000)::integer AS salary,
        (array['admin', 'accountant', 'cleaner', 'intern'])[ceil(random()*4)] AS post,
        (now() - interval '5 years' * random())::date AS employ_date
    FROM generate_series(1, 10000);
######


# создает таблицу "товары" и заполняет её случайными значениями
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name CHAR(10),
    price NUMERIC(10, 2),
    size INT,
    color VARCHAR(7),
    updated_at TIMESTAMP,
    built DATE,
    is_available BOOLEAN
);

INSERT INTO products (id, name, price, size, color, updated_at, built, is_available)
    SELECT
        generate_series(1, 1000) AS id,
        md5(random()::text)::char(10) AS name,
        (random()*1000)::numeric(10, 2) AS price,
        (random()*21+22)::int AS size,
        (array['cyan', 'brown', 'magenta'])[ceil(random()*3)] AS color,
        (now() - interval '1 day' * round(random()*100))::timestamp(0) AS updated_at,
        (now() - interval '2 year' + interval '1 year' * random())::date AS built,
        random()::int::bool AS is_available
    FROM generate_series(1, 1000);


6)

# создает столбец n, который содержит случайные значения типа boolean (истина или ложь)
# для каждой строки в диапазоне от 1 до 1000
WITH numbers AS (
    SELECT round(random()::numeric, 2) AS num
    FROM generate_series(1,1000)
)
SELECT 
    num, 
    CASE WHEN num <= 0.03 THEN false ELSE true END AS is_greater_then_0_03
FROM numbers;

7)

# создаем таблицу на сто тысяч рандомных записей
CREATE TABLE IF NOT EXISTS customer AS
SELECT
    generate_series(1, 100000) AS id,
    floor(random() * (999999 - 100000 + 1) + 100000)::text AS zipcode;

# просмотор план выполнения запроса
EXPLAIN ANALYZE SELECT * FROM tran_table WHERE salary='6674'; 
# добавление индекса на столбец для оптимизации запросов
CREATE INDEX idx_salary ON tran_table(salary);

# используется для управления хранением данных и обновления статистики. 
# Она может быть полезна для оптимизации выполнения запросов.
VACUUM ANALYZE customer; 

EXPLAIN SELECT id FROM customer WHERE zipcode='789990';

EXPLAIN SELECT * FROM customer ORDER BY zipcode DESC LIMIT 3;

8)

# возвращает информацию о текущих активных запросах и времени их выполнения. 
# Результат будет содержать столбцы running_for (время выполнения) и query (SQL-запрос). 
# Он покажет пять запросов, которые выполняются дольше всего.
SELECT now() - query_start AS running_for, query FROM pg_stat_activity ORDER BY 1 DESC;

# выбирает все блокировки, которые не были предоставлены (то есть ожидают разблокировки).
# Результат содержит информацию о блокировках в базе данных.
SELECT 
    locktype,
    database,
    relation,
    virtualtransaction,
    pid,
    mode,
    granted,
    fastpath,
    waitstart
FROM pg_locks WHERE NOT granted;

# Этот запрос возвращает информацию о блокировках и ожидающих запросах в базе данных.
# Он показывает, какие запросы блокируются и блокируют другие запросы, 
# а также какие таблицы находятся под блокировкой.
SELECT 
    a1.query AS blocking_query,
    a2.query AS waiting_query, 
    t.schemaname || '.' || t.relname AS locked_table 
FROM pg_stat_activity a1 
    JOIN pg_locks p1 ON a1.pid = p1.pid 
AND p1.granted 
    JOIN pg_locks p2 ON p1.relation = p2.relation 
AND NOT p2.granted 
    JOIN pg_stat_activity a2 ON a2.pid = p2.pid 
JOIN pg_stat_all_tables t ON p1.relation = t.relid;