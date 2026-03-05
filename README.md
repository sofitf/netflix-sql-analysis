# Database_SQL_and_query_optimization

## Proyecto 1: Netflix
## 1. Objetivo del Proyecto

El objetivo de este proyecto es diseñar, crear y gestionar una **base de datos relacional normalizada** que permita almacenar, consultar y analizar la información de las facturas y ventas registradas en el sistema.
A partir del dataset **Netflix.csv**, se aplican principios de:  
* Modelado de datos
* Normalización de bases de datos
* Creación de consultas en **MySQL**
Con el fin de obtener información clave sobre **clientes, productos, categorías y facturas**.

---

## 2. Campos del Dataset

| Campo        | Tipo MySQL | Descripción                                       |
| ------------ | ---------- | ------------------------------------------------- |
| show_id      | INT        | Identificador único del título en el dataset      |
| title        | VARCHAR    | Nombre de la película o serie                     |
| description  | TEXT       | Sinopsis corta del contenido                      |
| release_year | INT        | Año de lanzamiento del título                     |
| date_added   | DATE       | Fecha en que se agregó a Netflix                  |
| type         | VARCHAR    | Tipo de contenido: *Movie* o *TV Show*            |
| rating       | VARCHAR    | Clasificación por edad (ej. TV-14, TV-MA, PG)     |
| duration     | VARCHAR    | Duración como texto (ej. “109 min” o “3 Seasons”) |
| countries    | VARCHAR    | País o países de producción (separados por comas) |
| genres       | VARCHAR    | Género o géneros del título (separados por comas) |

---

## 3. Diseño de la Base de Datos
La base de datos se normalizó para evitar redundancias y soportar análisis:

- **shows** – tabla principal con los títulos  
- **content_type** – tipo de contenido (Movie o TV Show)  
- **rating** – clasificación por edad  
- **country** – países de producción  
- **genre** – géneros del contenido  
- **shows_country** – relación muchos a muchos entre shows y países  
- **shows_genre** – relación muchos a muchos entre shows y géneros  

Esto permite consultas flexibles y mantiene la integridad de los datos.

---

## 4. Normalización Aplicada
- **1NF**: Se eliminaron atributos multivaluados como múltiples géneros o países en una sola celda.  
- **2NF**: Se separaron entidades para eliminar dependencias parciales (content_type, rating).  
- **3NF**: Todos los atributos dependen únicamente de la clave primaria, evitando dependencias transitivas.

---

## 5. Insights Clave
El catálogo de Netflix creció significativamente después del año 2000, con una mezcla de películas y series.
Algunos géneros dominan el catálogo, reflejando las preferencias del público.
La producción de contenido varía por año, mostrando picos en determinados periodos.
Los títulos provienen de múltiples países, mostrando diversidad internacional.
