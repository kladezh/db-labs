CREATE TABLE strings (
    id serial PRIMARY KEY,
    string text
);


INSERT INTO strings (string) VALUES
    ('Мама123'),
    ('Мыло456a'),
    ('Р789аму'),
    ('example@email.com'),
    ('Слово: Значение'),
    ('Текстовый_файл.txt'),
    ('Иванов Иван Иванович'),
    ('+79234567890'),
    ('+7(495)123-45-67'),
    ('123456 Город улица Дом 123');


-- 1) проверить, есть ли в строке число
SELECT string FROM strings WHERE string ~ '[0-9]';


-- 2) найти в строке электронный адрес
INSERT INTO strings (string) VALUES 
    ('hbh1b4adbfarra@yandex.ruaj jabgjb');

SELECT string FROM strings WHERE string ~ E'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}';

^[A-Za-z0-9._%+-]+:  строка должна начинаться с одного 
    или более символов, которые могут быть буквами в верхнем и нижнем регистре, 
    цифрами, точка, подчеркивание, процент, плюс и дефис.
Затем @
[A-Za-z0-9.-]+ - домен (буквы, цифры, точка ".", тире "-")
\\. - точка
2, 3 или 4 буквы


-- 3) найти сроку, начинающуюся с буквы с следом ":"

INSERT INTO strings (string) VALUES
    ('F:fvzxvsd'),
    ('fdsf: sf'),
    ('2:frwfsdf');

-- буква в любом регистре, двоеточие, не пробелы
SELECT string FROM strings WHERE string ~ '^[a-zA-z]:\S.*';


-- 4) найти файлы с расширением .txt

INSERT INTO strings (string) VALUES
    ('fsdf.txt'),
    ('sdfsf.bat');


SELECT string FROM strings WHERE string ~ '\.txt$';


-- 5) разделить поле ФИО на имя, фамилию, отчество
CREATE TABLE people (
    id serial PRIMARY KEY,
    full_name text
);


INSERT INTO people (full_name) VALUES
    ('Иванов Иван Иванович'),
    ('Петров Петр Петрович'),
    ('Сидоров Сидор Сидорович');


SELECT
  full_name AS "Полное имя",
  SPLIT_PART(full_name, ' ', 1) AS "Фамилия",
  SPLIT_PART(full_name, ' ', 2) AS "Имя",
  SPLIT_PART(full_name, ' ', 3) AS "Отчество"
FROM people;


-- 6) преобразовать номер мобильного телефона к виду '+7(495)123-45-67'

INSERT INTO strings (string) VALUES
    ('74951234567');

UPDATE strings
SET string = REGEXP_REPLACE(string, '(\d{1})(\d{3})(\d{3})(\d{2})(\d{2})', '+\1(\2)\3-\4-\5')
WHERE string ~ '^\d{11}$';


-- 8) вывести код оператора номера телефона в отделнюю колонку

ALTER TABLE strings ADD COLUMN operator_code text;

UPDATE strings
SET operator_code = substring(string from '\((\d{3})\)'); 
--ищем (3 цифры)


-- 9) извлечь из строки данные адреса: индекс, город, улица или проспект, название улицы, номер дома

INSERT INTO strings (string) VALUES
('123456, Москва, ул. Профсоюзная, 25'),
('630001, Новосибирск, ул. Ленина, 10Б'),
('190000, Санкт-Петербург, Невский проспект, 50');


SELECT
    split_part(split_part(string, ', ', 1), ', ', 1) AS index,
    split_part(split_part(string, ', ', 2), ', ', 1) AS city,
    split_part(split_part(string, ', ', 3), ', ', 1) AS street,
    split_part(string, ', ', 4) AS house_number
FROM strings
WHERE string LIKE '______, %, %, %';


-- 10) убрать мусорные данные (цифры и символы от слов)

CREATE TABLE trash(string text);

INSERT INTO trash (string) VALUES
    ('Мама123'),
    ('Мыл456а'),
    ('Р789аму');

UPDATE trash
SET string = REGEXP_REPLACE(string, '[^a-zA-Zа-яА-Я]', '', 'g');
--заменяем все, что не буквы на пустую строку, где есть 1 или более цифр



