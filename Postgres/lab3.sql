\df
SELECT prosrc FROM pg_proc WHERE proname = ''



-- 1

-- Создание главной таблицы
CREATE TABLE UserVisits (
    UserID SERIAL PRIMARY KEY,
    UserName VARCHAR(50),
    VisitDate TIMESTAMP,
    PageVisited VARCHAR(100)
);

-- Создание дочерней таблицы
CREATE TABLE MonthlyUserActions (
    ActionID SERIAL PRIMARY KEY,
    ActionDescription VARCHAR(255)
) INHERITS (UserVisits);

INSERT INTO UserVisits (UserName, VisitDate, PageVisited)
VALUES 
    ('JohnDoe', '2023-01-01 10:00:00', 'Homepage'),
    ('JaneDoe', '2023-01-02 12:30:00', 'ProductPage'),
    ('BobSmith', '2023-12-03 15:45:00', 'ContactPage');

-- Функция для триггера
CREATE OR REPLACE FUNCTION PopulateMonthlyUserActions()
RETURNS TRIGGER AS $$
BEGIN
    IF EXTRACT(MONTH FROM NEW.VisitDate) = 12 THEN
        -- Вставка записи в дочернюю таблицу
        INSERT INTO MonthlyUserActions (ActionDescription)
        VALUES ('Visited page: ' || NEW.PageVisited);
    ELSE
        -- Вывод ошибки, если месяц не декабрь
        RAISE EXCEPTION 'Data can only be inserted in December.';
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER MonthlyUserActionsTrigger
BEFORE INSERT ON UserVisits
FOR EACH ROW
EXECUTE FUNCTION PopulateMonthlyUserActions();

-- Проверка триггера (добавляем запись в таблицу UserVisits)
INSERT INTO UserVisits (UserName, VisitDate, PageVisited)
VALUES ('JohnDoe', CURRENT_TIMESTAMP, 'Homepage');

-- Проверим содержимое дочерней таблицы MonthlyUserActions
SELECT * FROM MonthlyUserActions;









-- 1

-- таблица посещения пользователем страниц
CREATE TABLE UserVisits (
    UserID SERIAL PRIMARY KEY,
    UserName VARCHAR(50),
    VisitDate TIMESTAMP,
    PageVisited VARCHAR(100)
);

-- таблица действия пользователя
CREATE TABLE MonthlyUserActions (
    VisitDescription VARCHAR(255)
);

-- функция для триггера
CREATE OR REPLACE FUNCTION PopulateMonthlyUserActions()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO MonthlyUserActions (UserID, ActionDate, ActionDescription)
    VALUES (NEW.UserID, NEW.VisitDate, 'Visited page: ' || NEW.PageVisited);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер
CREATE TRIGGER MonthlyUserActionsTrigger
AFTER INSERT ON UserVisits
FOR EACH ROW
EXECUTE FUNCTION PopulateMonthlyUserActions();

-- Триггер будет автоматически добавлять записи 
-- в таблицу MonthlyUserActions 
-- при вставке новых данных в таблицу UserVisits

-- Проверка триггера (добавляем запись в таблицу UserVisits)
INSERT INTO UserVisits (UserName, VisitDate, PageVisited)
VALUES ('Alex100', CURRENT_TIMESTAMP, 'Youtube');

-- Проверим содержимое дочерней таблицы MonthlyUserActions, чтобы проверить, сработал ли триггер
SELECT * FROM MonthlyUserActions;


-- 2

CREATE TABLE Employees (
    EmployeeID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2)
);

-- Функция для триггера
CREATE OR REPLACE FUNCTION CheckEmployeeInsert()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Salary < 0 THEN
        RAISE EXCEPTION 'Salary cannot be negative';
    END IF;

    IF NEW.FirstName = '' OR NEW.FirstName IS NULL THEN
        RAISE EXCEPTION 'First name cannot be empty';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер
CREATE TRIGGER BeforeInsertEmployee
BEFORE INSERT ON Employees
FOR EACH ROW
EXECUTE FUNCTION CheckEmployeeInsert();

-- Триггер проверяет при вставке в таблицу Employees
-- Зарпалата не отрицательная
-- Имя не пустое


-- Попытка вставить запись с отрицательной зарплатой
INSERT INTO Employees (FirstName, LastName, Salary)
VALUES ('John', 'Doe', -1000);

-- Попытка вставить запись с пустым именем
INSERT INTO Employees (FirstName, LastName, Salary)
VALUES ('', 'Smith', 2000);

-- Верная вставка
INSERT INTO Employees (FirstName, LastName, Salary)
VALUES ('Alice', 'Johnson', 3000);

-- Проверим содержимое таблицы Employees
SELECT * FROM Employees;


-- 3

CREATE TABLE stock (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INT
);

INSERT INTO stock (product_name, quantity) VALUES
('Product A', 4),
('Product B', 15),
('Product C', 8);

CREATE TABLE reorder_stock (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity_to_order INT -- разница между (10 - quantity)
);


-- Функция для триггера
CREATE OR REPLACE PROCEDURE DoReorder()
AS $$
DECLARE
    reorder_threshold INT := 10; -- фиксированная велчина кол-ва товаров
BEGIN
    -- Вставляем данные о товарах для дозаказа в таблицу reorder_stock
    INSERT INTO reorder_stock (product_id, product_name, quantity_to_order)
    SELECT product_id, product_name, (reorder_threshold - quantity) AS quantity_to_order
    FROM stock
    WHERE quantity < reorder_threshold; -- Если кол-во товара меньше макс. величины
END;
$$ LANGUAGE plpgsql;

-- Вызвать функцию триггера
CALL DoReorder();

-- Посмотрим содержимое таблицы stock
SELECT * FROM stock;

-- Посмотрим содержимое таблицы reorder_stock
SELECT * FROM reorder_stock;

-- Результат выполнения этой процедуры - в таблицу reorder_stock добавятся те записи, в которых quantity < 10 (то есть Product A и Product C)


-- 4

-- функция для триггера
CREATE OR REPLACE FUNCTION UpdateReorderStock()
RETURNS TRIGGER AS $$
DECLARE
    reorder_threshold INT := 10; -- фиксированная велчина кол-ва товаров
    product_exists BOOLEAN;
    new_quantity INT;
BEGIN
    IF NEW.quantity < reorder_threshold THEN
        new_quantity := GREATEST(0, reorder_threshold - NEW.quantity);

        SELECT EXISTS (SELECT 1 FROM reorder_stock WHERE product_id = NEW.product_id) INTO product_exists;
        IF product_exists THEN
            UPDATE reorder_stock
            SET quantity_to_order = new_quantity
            WHERE product_id = NEW.product_id;
        ELSE
            INSERT INTO reorder_stock (product_id, product_name, quantity_to_order)
            VALUES (NEW.product_id, NEW.product_name, new_quantity);
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Привяжем триггер к таблице stock после выполнения UPDATE
CREATE OR REPLACE TRIGGER AfterUpdateStock
AFTER UPDATE OR INSERT ON stock
FOR EACH ROW
EXECUTE FUNCTION UpdateReorderStock();

-- Обновим количество товаров
UPDATE stock SET quantity = 9 WHERE product_id = 1;

-- Посмотрим содержимое таблицы stock
SELECT * FROM stock;

-- Посмотрим содержимое таблицы reorder_stock
SELECT * FROM reorder_stock;


-- 5

-- Создадим таблицу клиентов
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100)
);

-- Создадим таблицу заказов
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    status VARCHAR(20) -- 'unfulfilled', 'fulfilled', или другие статусы
);

-- Вставим некоторые примеры данных
INSERT INTO customers (customer_name) VALUES
    ('Customer A'),
    ('Customer B'),
    ('Customer C');

-- unfulfilled - невыполнен
-- fulfilled - выполнен
INSERT INTO orders (customer_id, status) VALUES
    (1, 'unfulfilled'),
    (1, 'fulfilled'),
    (2, 'unfulfilled'),
    (3, 'fulfilled');

-- Создадим триггер
CREATE OR REPLACE FUNCTION PreventDeleteCustomer()
RETURNS TRIGGER AS $$
DECLARE
    has_unfulfilled_orders BOOLEAN;
BEGIN
    -- Проверим наличие невыполненных заказов
    SELECT EXISTS (SELECT 1 FROM orders WHERE customer_id = OLD.customer_id AND status = 'unfulfilled')
    INTO has_unfulfilled_orders;

    -- Если есть невыполненные заказы, предотвратим удаление клиента
    IF has_unfulfilled_orders THEN
        RAISE EXCEPTION 'Cannot delete customer with unfulfilled orders';
    ELSE
        -- Удалим связанные заказы перед удалением клиента
        DELETE FROM orders WHERE customer_id = OLD.customer_id;
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Привяжем триггер к таблице customers перед выполнением DELETE
CREATE OR REPLACE TRIGGER BeforeDeleteCustomer
BEFORE DELETE ON customers
FOR EACH ROW
EXECUTE FUNCTION PreventDeleteCustomer();

-- Попробуем удалить клиента с невыполненным заказом
DELETE FROM customers WHERE customer_id = 1;

-- Удалим клиента без невыполненных заказов
DELETE FROM customers WHERE customer_id = 3;


-- 6

CREATE TABLE employee_audit (
    audit_id SERIAL PRIMARY KEY,
    action_type VARCHAR(10) NOT NULL,
    employee_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10, 2),
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создаем функцию для триггера аудита
CREATE OR REPLACE FUNCTION EmployeeAuditFunction()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO employee_audit (action_type, employee_id, first_name, last_name, salary)
        VALUES ('INSERT', NEW.EmployeeID, NEW.FirstName, NEW.LastName, NEW.Salary);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO employee_audit (action_type, employee_id, first_name, last_name, salary)
        VALUES ('UPDATE', NEW.EmployeeID, NEW.FirstName, NEW.LastName, NEW.Salary);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO employee_audit (action_type, employee_id, first_name, last_name, salary)
        VALUES ('DELETE', OLD.EmployeeID, OLD.FirstName, OLD.LastName, OLD.Salary);
    ELSIF TG_OP = 'TRUNCATE' THEN
        INSERT INTO employee_audit (action_type, employee_id, first_name, last_name, salary)
        VALUES ('TRUNCATE', NULL, NULL, NULL, NULL);
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER employee_audit_truncate_trigger
AFTER TRUNCATE 
ON Employees
FOR EACH STATEMENT
EXECUTE FUNCTION EmployeeAuditFunction();

-- Создаем триггер аудита для таблицы сотрудников
CREATE OR REPLACE TRIGGER employee_audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON Employees
FOR EACH ROW
EXECUTE FUNCTION EmployeeAuditFunction();


-- Проверка триггера
-- Вставка
INSERT INTO Employees (FirstName, LastName, Salary) VALUES ('John', 'Doe', 50000.00);

-- Обновление
UPDATE Employees SET Salary = 55000.00 WHERE EmployeeID = 4;

-- Удаление
DELETE FROM Employees WHERE EmployeeID = 4;

-- Просмотр записей в таблице аудита
SELECT * FROM employee_audit;

-- Создаем функцию-обертку
CREATE OR REPLACE FUNCTION superuser_copy()
RETURNS VOID AS $$
BEGIN
    -- Проверяем, является ли текущий пользователь суперпользователем
    IF current_user = 'postgres' THEN
        -- Если пользователь суперпользователь, выполняем операцию COPY
        COPY Employees TO 'C:/University Labs/Databases/Postgres/Files/Employees_copied.csv' WITH (FORMAT CSV, HEADER);
    ELSE
        -- Если пользователь не суперпользователь, предоставляем ему права суперпользователя
        GRANT COPY ON DATABASE testdb TO current_user;
        COPY Employees TO 'C:/University Labs/Databases/Postgres/Files/Employees_copied.csv' WITH (FORMAT CSV, HEADER);
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION superuser_copy(filepath text)
RETURNS VOID AS $$
BEGIN
    -- Проверяем, является ли текущий пользователь суперпользователем
    IF current_user = 'postgres' THEN
        -- Если пользователь суперпользователь, выполняем операцию COPY
        EXECUTE format('COPY Employees TO %L WITH (FORMAT CSV, HEADER)', filepath);
    ELSE
        -- Если пользователь не суперпользователь, предоставляем ему права суперпользователя
        SET SESSION AUTHORIZATION postgres;
        EXECUTE format('COPY Employees TO %L WITH (FORMAT CSV, HEADER)', filepath);
        RESET SESSION AUTHORIZATION;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Пример вызова функции
SELECT superuser_copy();
