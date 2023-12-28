-- Типы данных в PostGIS:

-- Геометрические типы данных:
-- - Geometry (объект): представляет собой абстрактный геометрический объект, который может быть точкой, линией или полигоном в пространстве
-- - Point (точка): Определена своими координатами x, y.
-- - LineString (линия): Упорядоченный набор точек, соединенных прямыми линиями.
-- - Polygon (полигон): Замкнутая линия, представляющая собой упорядоченный набор точек, образующих замкнутую область.

-- Географические типы данных:
-- - Geography (география): Тип для представления данных в сферической географической системе координат, например, широты и долготы. Поддерживает глобальные объекты и расчет расстояний на поверхности Земли.


-- Операции в PostGIS:

-- Создание объектов:
-- - ST_GeomFromText: Создание геометрии из текстового представления.
-- - ST_Point, ST_LineString, ST_Polygon: Создание точек, линий и полигонов.
-- - ST_StartPoint, ST_EndPoint: Возвращают начальную и конечную точку (Point) линии (LineString)

-- Пространственные отношения:
-- - ST_Intersects: Проверка пересечения объектов.
-- - ST_Contains: Проверка, содержит ли объект A в себе объект B
-- - ST_Within: Проверяет, вложен ли объект A полностью в объект B
-- - ST_DWithin: Прверяет, находится ли объект A в пределах указанного расстояния от объекта B
-- - ST_Distance: Расчет расстояния между объектами.

-- Анализ:
-- - ST_Area, ST_Length: Расчет площади и длины объектов соответственно.
-- - ST_Azimuth: Расчет азимута - угла между направлением на север и линии, соединяющей две точки
-- - ST_Centroid, ST_PointOnSurface: Нахождение центроида и точки на поверхности объекта.

-- Трансформации:
-- - ST_Transform: Преобразование геометрии из одной системы координат в другую.
-- - ST_Buffer: Создание буферной зоны вокруг объекта.

----------------------------------------------------------------------------------------------------------------------------------------------

--
-- GEOMETRY - тип геометрического объекта,
-- который используется для хранения точек на поверхности Земли в географических координатах.

-- POINT - точка на карте, принимает координаты

-- 4326 - система координат WGS 84

-- Polygon - это геометрический объект в контексте географических информационных систем (ГИС),
-- представляющий собой замкнутую область на плоскости. В контексте PostGIS, Polygon может быть использован
-- для представления геометрических объектов, таких как зоны, границы, ограничивающие области и т.д.
-- Polygon принимает вершины полигона, например,
-- Пример: Создание прямоугольного полигона в системе координат WGS 84 (SRID: 4326):
ST_GeomFromText('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))', 4326)::GEOMETRY(Polygon, 4326)

-- ST_GeomFromText - это функция в PostGIS, которая используется для создания геометрического объекта
-- на основе текстового представления этого объекта. 

-- LINESTRING представляет собой геометрический объект, представляющий собой набор упорядоченных точек,
-- соединенных линиями. Эти линии могут быть прямыми или кривыми.
-- Пример: Создание линии (линии, состоящей из двух вершин) в системе координат WGS 84.
ST_GeomFromText('LINESTRING(55.1234 37.5678, 55.2345 37.6789)', 4326)::GEOMETRY(LineString, 4326)

-- Если кратко, то POINT - используется для представления конкретных точек, например
-- местоположения городов, достопримечатлеьностей и так далее, а LINESTRING - используется для представления линий или кривых,
-- таких как дороги, реки, границы и т.д.

-- ST_Distance - это функция, которая используется для вычисления расстояния между двумя геометрическими объектами.
-- Это расстояние измеряется в тех же единицах, что и система координат объектов.
-- Функция может принимать различные типы геометрий, такие как точки, линии, полигоны и другие.

-- 0101000020E6100000F54A5986388E41407B832F4CA6AA2E40 - Это бинарные данные, представляющие координаты точки в формате WKB.

-- ST_AsText - это функция, которая используется для преобразования геометрического объекта
-- в его текстовое представление в формате Well-Known Text (WKT). 
-- WKT - это текстовый формат, используемый для представления геометрических объектов,
-- таких как точки, линии, полигоны и другие, в человекочитаемой форме.

-- ST_Length - это функция, которая используется для вычисления длины геометрического объекта,
-- такого как линия или полигон. Эта функция применяется к геометрическим объектам,
-- которые представляют собой линии (например, LINESTRING) или границы полигонов.
-- Пример: вычисления длины каждой дорожной линии (road_path):
SELECT road_id, road_name, ST_Length(road_path) AS length FROM roads;

-- ST_StartPoint - это функция, которая возвращает точку, представляющую начальную точку линии или полигона.
-- Эта функция применяется к геометрическим объектам,
-- которые представляют собой линии (например, LINESTRING) или границы полигонов.
-- Пример: получение начальной точки каждой дорожной линии
SELECT road_id, road_name, ST_AsText(ST_StartPoint(road_path)) AS start_point FROM roads;

-- ST_EndPoint - это функция, аналогичная ST_StartPoint, но она возвращает точку, представляющую конечную точку линии или полигона.
-- Пример: получение конечной точки каждой дорожной линии
SELECT road_id, road_name, ST_AsText(ST_EndPoint(road_path)) AS end_point FROM roads;

-- ST_Azimuth - это функция, которая вычисляет азимут (направление) между двумя точками на поверхности Земли.
-- Эта функция принимает две геометрические точки (например, точки в формате POINT(x y))
-- и возвращает угол азимута в радианах или градусах, который указывает направление от первой точки ко второй.
-- Пример: вычисление азимута между начальной (ST_StartPoint(road_path)) 
-- и конечной (ST_EndPoint(road_path)) точками каждой дорожной линии.
-- Результат представляет собой угол в радианах, указывающий направление от начальной точки ко конечной.
SELECT road_id, road_name, ST_Azimuth(ST_StartPoint(road_path), ST_EndPoint(road_path)) AS azimuth FROM roads;

-- ST_DWithin - это функция, которая определяет,
-- находятся ли две геометрические объекты (точки, линии, полигоны и т. д.) внутри заданного расстояния друг от друга. 
-- Функция возвращает true, если объекты находятся в пределах указанного расстояния, и false в противном случае.
-- Пример: выбор всех достопримечательностей,
-- находящихся в пределах 10 единиц расстояния от заданной точки (координаты 52.1234, 33.5678).
SELECT landmark_id, landmark_name
FROM landmarks
WHERE ST_DWithin(landmark_location, ST_GeomFromText('POINT(52.1234 33.5678)', 4326), 10);





-- создаем базу для лабы (в ней работаем)
CREATE DATABASE mapdb;

-- добавить  постгис в базу
CREATE EXTENSION postgis; 
-- проверить   
SELECT postgis_version();    


1)

-- Создание таблицы для городов
CREATE TABLE cities (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(50),
    city_location GEOMETRY(Point, 4326)
);

-- Создание таблицы для дорог
CREATE TABLE roads (
    road_id SERIAL PRIMARY KEY,
    road_name VARCHAR(50),
    road_path GEOMETRY(LineString, 4326),
    city_id INTEGER REFERENCES cities(city_id) 
);

-- Создание таблицы для достопримечательностей
CREATE TABLE landmarks (
    landmark_id SERIAL PRIMARY KEY,
    landmark_name VARCHAR(50),
    landmark_location GEOMETRY(Point, 4326),
    city_id INTEGER REFERENCES cities(city_id)
);

-- Создание таблицы для зон торговых центров
CREATE TABLE shopping_zones (
    zone_id SERIAL PRIMARY KEY,
    zone_name VARCHAR(50),
    zone_area GEOMETRY(Polygon, 4326),
    city_id INTEGER REFERENCES cities(city_id)
);

-- Заполнение таблиц данными
-- Пример заполнения таблиц данными (пять строк каждой таблицы):
INSERT INTO cities (city_name, city_location) VALUES
    ('City1', ST_GeomFromText('POINT(50.1234 30.5678)', 4326)),
    ('City2', ST_GeomFromText('POINT(40.9876 20.5432)', 4326)),
    ('City3', ST_GeomFromText('POINT(45.1111 25.2222)', 4326)),
    ('City4', ST_GeomFromText('POINT(35.4444 15.6666)', 4326)),
    ('City5', ST_GeomFromText('POINT(55.7777 10.8888)', 4326));

INSERT INTO roads (road_name, road_path, city_id) VALUES
    ('Road1', ST_GeomFromText('LINESTRING(50.1234 30.5678, 40.9876 20.5432)', 4326),1),
    ('Road2', ST_GeomFromText('LINESTRING(55.1234 30.5678, 45.9876 20.5432)', 4326),1),
    ('Road3', ST_GeomFromText('LINESTRING(55.7777 10.8888, 50.1234 30.5678)', 4326),3),
    ('Road4', ST_GeomFromText('LINESTRING(40.9876 20.5432, 45.1111 25.2222)', 4326),2),
    ('Road5', ST_GeomFromText('LINESTRING(40.9876 25.5432, 10.1111 25.2222)', 4326),4),
    ('Road6', ST_GeomFromText('LINESTRING(53.1234 30.5678, 40.9876 20.5432)', 4326),2),
    ('Road7', ST_GeomFromText('LINESTRING(53.1234 30.5678, 40.9876 20.5432)', 4326),2),
    ('Road8', ST_GeomFromText('LINESTRING(53.1234 35.5678, 40.9876 25.5432)', 4326),1);


INSERT INTO landmarks (landmark_name, landmark_location, city_id) VALUES
    ('Landmark1', ST_GeomFromText('POINT(50.2222 30.4444)', 4326),1),
    ('Landmark2', ST_GeomFromText('POINT(40.5555 20.7777)', 4326),2),
    ('Landmark3', ST_GeomFromText('POINT(45.8888 25.9999)', 4326),4),
    ('Landmark4', ST_GeomFromText('POINT(35.1111 15.3333)', 4326),2),
    ('Landmark5', ST_GeomFromText('POINT(55.6666 10.2222)', 4326),2);

INSERT INTO shopping_zones (zone_name, zone_area, city_id) VALUES
    ('Zone1', ST_GeomFromText('POLYGON((50.0 30.0, 50.0 31.0, 51.0 31.0, 51.0 30.0, 50.0 30.0))', 4326),1),
    ('Zone2', ST_GeomFromText('POLYGON((40.0 20.0, 40.0 21.0, 41.0 21.0, 41.0 20.0, 40.0 20.0))', 4326),1),
    ('Zone3', ST_GeomFromText('POLYGON((45.0 25.0, 45.0 26.0, 46.0 26.0, 46.0 25.0, 45.0 25.0))', 4326),3),
    ('Zone4', ST_GeomFromText('POLYGON((35.0 15.0, 35.0 16.0, 36.0 16.0, 36.0 15.0, 35.0 15.0))', 4326),3),
    ('Zone5', ST_GeomFromText('POLYGON((55.0 10.0, 55.0 11.0, 56.0 11.0, 56.0 10.0, 55.0 10.0))', 4326),2);


2)

-- передаем в ST_Distance в качестве landmark_location локацию достопримечательности,
-- затем в ST_GeomFromText захардкоженную позицию человека, в результате мы получаем id,
-- название близжайшей достопримечательности и расстояние до нее

SELECT
  landmark_id,
  landmark_name,
  ST_Distance(landmark_location, ST_GeomFromText('POINT(50.1234 30.5678)', 4326)::GEOMETRY) AS distance
FROM landmarks
ORDER BY distance
LIMIT 1;


3)

-- вывести  Azimuth 
WITH parallel_roads AS ( 
    SELECT
        r1.road_name AS road_name1, 
        r2.road_name AS road_name2, 
        ST_Length(r1.road_path) AS length1, 
        ST_Length(r2.road_path) AS length2, 
        ST_Azimuth(ST_StartPoint(r1.road_path), ST_EndPoint(r1.road_path)) AS azimuth1, 
        ST_Azimuth(ST_StartPoint(r2.road_path), ST_EndPoint(r2.road_path)) AS azimuth2 
    FROM roads r1 
    JOIN roads r2 ON r1.road_name < r2.road_name 
    WHERE ST_Azimuth(ST_StartPoint(r1.road_path), ST_EndPoint(r1.road_path)) = 
        ST_Azimuth(ST_StartPoint(r2.road_path), ST_EndPoint(r2.road_path)) 
) 
SELECT 
    road_name1, 
    road_name2, 
    length1, 
    length2, 
    azimuth1, 
    azimuth2 
FROM parallel_roads;

WITH parallel_roads AS (
    SELECT 
        r1.road_name AS road_name1, 
        r2.road_name AS road_name2, 
        ST_Length(r1.road_path) AS length1, 
        ST_Length(r2.road_path) AS length2 
    FROM roads r1 
    JOIN roads r2 ON r1.road_name < r2.road_name 
    WHERE ST_Azimuth(ST_StartPoint(r1.road_path), ST_EndPoint(r1.road_path)) = 
        ST_Azimuth(ST_StartPoint(r2.road_path), ST_EndPoint(r2.road_path)) 
) 
SELECT 
    road_name1,
    road_name2, 
    length1, 
    length2
FROM parallel_roads;


4)

SELECT landmark_name
FROM landmarks
WHERE ST_DWithin(landmark_location, ST_GeomFromText('POINT(52.1234 33.5678)', 4326), 10);


5)

WITH target_road AS (
  SELECT road_name, road_path
  FROM roads
  WHERE road_name = 'Road1'  
)
SELECT 
    sz.zone_name, 
    ST_Area(sz.zone_area) AS zone_area
FROM shopping_zones sz
WHERE EXISTS (
  SELECT 1
  FROM target_road tr
  WHERE ST_DWithin(sz.zone_area, tr.road_path, 100.0) 
)
ORDER BY zone_area DESC
LIMIT 1;


6)

CREATE OR REPLACE FUNCTION calculate_distance(
  object1_id INT,
  object1_type VARCHAR(50),
  object2_id INT,
  object2_type VARCHAR(50)
) RETURNS FLOAT AS $$
DECLARE
  object1_location GEOMETRY;
  object2_location GEOMETRY;
  distance FLOAT;
BEGIN
  CASE object1_type
    WHEN 'city' THEN
      SELECT city_location INTO object1_location FROM cities WHERE city_id = object1_id;
    WHEN 'road' THEN
      SELECT road_path INTO object1_location FROM roads WHERE road_id = object1_id;
    WHEN 'landmark' THEN
      SELECT landmark_location INTO object1_location FROM landmarks WHERE landmark_id = object1_id;
    WHEN 'shopping_zone' THEN
      SELECT zone_area INTO object1_location FROM shopping_zones WHERE zone_id = object1_id;
    ELSE
      RAISE EXCEPTION 'Неверный тип объекта: %', object1_type;
  END CASE;

  CASE object2_type
    WHEN 'city' THEN
      SELECT city_location INTO object2_location FROM cities WHERE city_id = object2_id;
    WHEN 'road' THEN
      SELECT road_path INTO object2_location FROM roads WHERE road_id = object2_id;
    WHEN 'landmark' THEN
      SELECT landmark_location INTO object2_location FROM landmarks WHERE landmark_id = object2_id;
    WHEN 'shopping_zone' THEN
      SELECT zone_area INTO object2_location FROM shopping_zones WHERE zone_id = object2_id;
    ELSE
      RAISE EXCEPTION 'Неверный тип объекта: %', object2_type;
  END CASE;

  distance := ST_Distance(object1_location, object2_location);

  RETURN distance;
END;
$$ LANGUAGE plpgsql;


SELECT calculate_distance(1, 'city', 2, 'landmark');
SELECT calculate_distance(1, 'landmark', 2, 'city');
SELECT calculate_distance('cities', 1, 'landmarks', 2);