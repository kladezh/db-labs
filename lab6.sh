# добавить  постгис в базу
CREATE EXTENSION postgis; 
# проверить   
SELECT postgis_version();    


1)

# Создание таблицы для городов
CREATE TABLE cities (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(50),
    city_location GEOMETRY(Point, 4326) # GEOMETRY тип для координат города
);

# Создание таблицы для дорог
CREATE TABLE roads (
    road_id SERIAL PRIMARY KEY,
    road_name VARCHAR(50),
    road_path GEOMETRY(LineString, 4326), # GEOMETRY тип для пути дороги
    city_id INTEGER REFERENCES cities(city_id) 
);

# Создание таблицы для достопримечательностей
CREATE TABLE landmarks (
    landmark_id SERIAL PRIMARY KEY,
    landmark_name VARCHAR(50),
    landmark_location GEOMETRY(Point, 4326),
    city_id INTEGER REFERENCES cities(city_id)  # GEOMETRY тип для координат достопримечательностей
);

# Создание таблицы для зон торговых центров
CREATE TABLE shopping_zones (
    zone_id SERIAL PRIMARY KEY,
    zone_name VARCHAR(50),
    zone_area GEOMETRY(Polygon, 4326),
    city_id INTEGER REFERENCES cities(city_id) # GEOMETRY тип для прямоугольных зон торговых центров
);

# Заполнение таблиц данными
# Пример заполнения таблиц данными (пять строк каждой таблицы):
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

SELECT
  landmark_id,
  landmark_name,
  ST_Distance(landmark_location, ST_GeomFromText('POINT(50.1234 30.5678)', 4326)::GEOMETRY) AS distance
FROM landmarks
ORDER BY distance
LIMIT 1;


3)

# вывести  Azimuth 
WITH parallel_roads AS ( 
    SELECT
        r1.road_name AS road_name1, 
        r2.road_name AS road_name2, 
        ST_Length(r1.road_path) AS length1, 
        ST_Length(r2.road_path) AS length2, 
        ST_Azimuth(ST_StartPoint(r1.road_path), 
        ST_EndPoint(r1.road_path)) AS azimuth1, 
        ST_Azimuth(ST_StartPoint(r2.road_path), 
        ST_EndPoint(r2.road_path)) AS azimuth2 
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
    length2,
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
  WHERE ST_DWithin(sz.zone_area, tr.road_path, 100.0) # - это расстояние  
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
  # Получаем местоположение первого объекта
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

  # Получаем местоположение второго объекта
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

  # Рассчитываем расстояние между объектами
  distance := ST_Distance(object1_location, object2_location);

  RETURN distance;
END;
$$ LANGUAGE plpgsql;


SELECT calculate_distance(1, 'city', 2, 'landmark');
SELECT calculate_distance(1, 'landmark', 2, 'city');
SELECT calculate_distance('cities', 1, 'landmarks', 2);