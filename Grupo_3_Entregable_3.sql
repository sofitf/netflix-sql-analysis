/*------------------------------------------------------------
                   Proyecto Grupo# 3
                    Tema: Netflix
------------------------------------------------------------*/

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS grupo3_netflix;
USE grupo3_netflix;


-- DROP DATABASE grupo3_netflix;

-- En caso de que el servidor se esté ejecutando en modo privado, ejecutar este comando para conocer la ruta disponible
SHOW VARIABLES LIKE 'secure_file_priv';

-- OK
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\content_type.csv' 
INTO TABLE content_type 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' -- considera como un solo campo (el texto del campo description está entre comillas dobles) 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(content_type_id,content_type_name);

-- OK
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\countries.csv' 
INTO TABLE country 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' -- considera como un solo campo (el texto del campo description está entre comillas dobles) 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(country,country_id);

-- OK
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\genres.csv' 
INTO TABLE genre 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' -- considera como un solo campo (el texto del campo description está entre comillas dobles) 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(genre_id,genre);

-- OK
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\rating.csv' 
INTO TABLE rating 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' -- considera como un solo campo (el texto del campo description está entre comillas dobles) 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(rating_id,rating_name);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\shows.csv' 
INTO TABLE shows
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' -- considera como un solo campo (el texto del campo description está entre comillas dobles) 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(show_id,title,synopsis,release_year,date_added,duration,content_type_id_fk,rating_id_fk);

-- OK 
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\shows_countries.csv' 
INTO TABLE shows_country
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' -- considera como un solo campo (el texto del campo description está entre comillas dobles) 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(show_id,country_id);

-- OK
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\shows_genres.csv' 
INTO TABLE shows_genre
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' -- considera como un solo campo (el texto del campo description está entre comillas dobles) 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(show_id,genre_id);


-- Crear tabla shows
CREATE TABLE IF NOT EXISTS shows (
    show_id INT PRIMARY KEY, -- Identificador único del título en el dataset (dado por el dataset, no se utiliza AUTO_INCREMENT).
    title VARCHAR(150) NOT NULL, -- Nombre de la película o serie
    synopsis TEXT NOT NULL, -- Sinopsis corta del contenido
    release_year INT NOT NULL, -- Año de lanzamiento
    date_added DATE NOT NULL, -- Fecha en que se agregó a Netflix
    duration VARCHAR(15) NOT NULL -- Duración
);

-- Crear tabla country (dado que el atributo país en el dataset incumpliría la 1NF, puesto que contiene múltiples valores en una celda).
CREATE TABLE IF NOT EXISTS country (
country VARCHAR (40) NOT NULL UNIQUE, -- Nombre del país
country_id INT AUTO_INCREMENT PRIMARY KEY -- Identificador único de país
 );
 
 
 -- Crear tabla intermedia shows-country (dado que se tendría cardinalidad muchos a muchos (N:M) entre shows y país)
 CREATE TABLE IF NOT EXISTS shows_country(
   show_id INT,
   country_id INT,
   PRIMARY KEY (show_id,country_id) -- PK compuesta (fk)
-- FOREIGN KEY (show_id_fk) REFERENCES shows(show_id) ON DELETE CASCADE ON UPDATE CASCADE, -- Asegura que si se elimina un show, los registros relacionados en la tabla intermedia también se eliminen automáticamente.
-- FOREIGN KEY (country_id_fk) REFERENCES country(country_id)
);
 
-- Crear tabla genre (dado que incumpliría la 1NF, puesto que contiene múltiples valores/forma de lista en una celda).
CREATE TABLE IF NOT EXISTS genre (
 genre_id INT AUTO_INCREMENT PRIMARY KEY,    -- Identificador único de género
 genre VARCHAR (30) NOT NULL UNIQUE     -- Género del título
 );

-- Crear tabla intermedia shows-genre (dado que se tendría cardinalidad muchos a muchos (N:M) entre shows y géneros).
 CREATE TABLE IF NOT EXISTS shows_genre(
   show_id INT,
   genre_id INT,
   PRIMARY KEY (show_id,genre_id) -- PK compuesta, cumple 2NF no habría dependencias parciales
-- FOREIGN KEY (show_id_fk) REFERENCES shows(show_id) ON DELETE CASCADE ON UPDATE CASCADE, -- Asegura que si se elimina un show, los registros relacionados en la tabla intermedia también se eliminen automáticamente.
-- FOREIGN KEY (genre_id_fk) REFERENCES genre(genre_id)
);

-- Debido a redundancias (repetición de datos), se crea las siguientes entidades: content_type, rating, duration.
-- Cardinalidad shows - content_type: 1:M
CREATE TABLE IF NOT EXISTS content_type (          
 content_type_id INT AUTO_INCREMENT PRIMARY KEY,   -- Identificador único de tipo de contenido
 content_type_name VARCHAR (10) NOT NULL UNIQUE   -- Tipo de contenido
 );
 
 -- Cardinalidad shows - rating: 1:M
CREATE TABLE IF NOT EXISTS rating (
 rating_id INT AUTO_INCREMENT PRIMARY KEY,      -- Identificador único del rating
 rating_name VARCHAR (15) NOT NULL UNIQUE       -- Clasificación por edad (ej. TV-14, TV-MA, PG).
 );


/*Debido a que la cardindalidad entre content_type, rating, duration con respecto a shows sería 1:M (Uno a muchos).
 Se debe agregar la clave foránea en la entidad shows (puesto que sería la relación que tendría el "muchos"), así se mantiene la integridad referencial*/

-- Agregar claves foráneas a la tabla shows
ALTER TABLE shows 
ADD COLUMN content_type_id_fk INT NOT NULL, 
ADD COLUMN rating_id_fk INT NOT NULL;

ALTER TABLE shows
ADD CONSTRAINT fk_content_type
FOREIGN KEY (content_type_id_fk) REFERENCES content_type(content_type_id) ON DELETE CASCADE;

ALTER TABLE shows
ADD CONSTRAINT fk_rating
FOREIGN KEY (rating_id_fk) REFERENCES rating(rating_id) ON DELETE CASCADE;

-- TRES CONSULTAS DE ANÁLISIS 

-- 3. Análisis de películas y series publicadas desde el 2000 hasta la actualidad.
-- Técnicas: JOIN, COUNT, WHERE, GROUP BY
-- Descriptivo del objetivo de la consulta: Comparación de películas vs series.

SELECT ct.content_type_name, COUNT(*) AS total_titles
FROM shows s
INNER JOIN content_type ct ON s.content_type_id_fk = ct.content_type_id
WHERE s.release_year >= 2000
GROUP BY ct.content_type_name;

-- Consulta para identificar los años con más películas (Top 10):

SELECT 
    release_year AS Anio,
    COUNT(*) AS Peliculas
FROM shows
WHERE release_year >= 2000
  AND content_type_id_fk = 2
GROUP BY release_year
ORDER BY Peliculas DESC
LIMIT 10;

-- Consulta para identificar los años con más series (Top 10):
SELECT 
    release_year AS Anio,
    COUNT(*) AS Series
FROM shows
WHERE release_year >= 2000
  AND content_type_id_fk = 1
GROUP BY release_year
ORDER BY Series DESC
LIMIT 10;

-- 2.Top 5 de películas y series por género.
-- Técnicas: JOIN, GROUP BY, ORDER BY, LIMIT
--  OBJETIVO: Determinar qué géneros son los más populares.

-- GENERAL: SERIES Y PELÍCULAS (TOP 5)
SELECT 
    g.genre AS Genero,
    COUNT(sg.show_id) AS Total_Shows
FROM shows_genre sg
JOIN genre g ON sg.genre_id = g.genre_id
GROUP BY g.genre
ORDER BY Total_Shows DESC
LIMIT 5;

--  OBJETIVO: Identificar las preferencias en géneros con respecto a las películas
-- ESPECÍFICO : Género con más películas (TOP 5)
SELECT 
    g.genre AS Genero,
    COUNT(sg.show_id) AS Total_Peliculas
FROM shows_genre sg
INNER JOIN genre g ON sg.genre_id = g.genre_id
INNER JOIN shows s ON sg.show_id = s.show_id
WHERE s.content_type_id_fk = 2  -- 2 representa "Movie"
GROUP BY g.genre
ORDER BY Total_Peliculas DESC
LIMIT 5;

--  OBJETIVO: Identificar las preferencias en géneros con respecto a las series
-- ESPECÍFICO : Género con más series (TOP 5)
SELECT 
    g.genre AS Genero,
    COUNT(sg.show_id) AS Total_Series
FROM shows_genre sg
INNER JOIN genre g ON sg.genre_id = g.genre_id
INNER JOIN shows s ON sg.show_id = s.show_id
WHERE s.content_type_id_fk = 1  -- 1 representa "Series"
GROUP BY g.genre
ORDER BY Total_Series DESC
LIMIT 5;

-- 10. Análisis de las 10 películas y series más antiguas por país.
-- Técnicas: JOIN, ROW_NUMBER(), OVER (), PARTITION BY, ORDER BY
-- Descriptivo del objetivo de la consulta: Mostrar los 10 títulos históricos que se conservan en el catálogo por país de producción.

WITH ranked_content AS (
  SELECT 
      c.country,
      s.title,
      s.release_year,
      ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY s.release_year ASC) AS rank_antiguedad
  FROM shows s
  JOIN shows_country sc ON s.show_id = sc.show_id
  JOIN country c ON sc.country_id = c.country_id
)
SELECT country, title, release_year
FROM ranked_content
WHERE rank_antiguedad <= 10;



