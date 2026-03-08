
## 1. Descripción
Los datasets de contenido suelen venir en formatos no estructurados, donde múltiples valores se almacenan en una sola columna. Esto dificulta realizar análisis eficientes y consultas complejas.

El objetivo de este proyecto es transformar un dataset crudo de Netflix en una base de datos relacional estructurada, aplicando principios de:
Modelado de datos
Normalización de bases de datos
Consultas analíticas en MySQL

A partir del dataset Netflix.csv, se diseña una base de datos que permite almacenar, consultar y analizar información sobre títulos, géneros, países y clasificaciones del catálogo de Netflix.

---
## 2. Dataset
El dataset contiene información sobre películas y series disponibles en Netflix, incluyendo metadatos del contenido.

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

**Diseño de la Base de Datos**
La base de datos se normalizó para evitar redundancias y soportar análisis:

**Tablas principales/hechos:**
- **shows** – tabla principal con los títulos  
- **content_type** – tipo de contenido (Movie o TV Show)  
- **rating** – clasificación por edad  
- **country** – países de producción  
- **genre** – géneros del contenido

**Tablas relaciones/dimensiones:**
- **shows_country** – relación muchos a muchos entre shows y países  
- **shows_genre** – relación muchos a muchos entre shows y géneros  

Esto permite consultas flexibles y mantiene la integridad de los datos.

---
## 3. Herramientas Utilizadas
El proyecto se enfoca en el uso de SQL para estructurar y analizar datasets reales en un entorno de base de datos.

---
## 4. Análisis
Se aplicaron principios de normalización para convertir el dataset original en una base de datos relacional:
**Normalización Aplicada**
- **1NF**: Se eliminaron atributos como múltiples géneros o países en una sola celda.  
- **2NF**: Se separaron entidades para eliminar dependencias parciales.  
- **3NF**: Todos los atributos dependen únicamente de la clave primaria, evitando dependencias transitivas y redundancia de datos.

---
## 5. Hallazgos
A partir de las consultas realizadas sobre la base de datos se identificaron algunos patrones:
- El catálogo de Netflix creció significativamente después del año 2000, con una mezcla de películas y series.
- Algunos géneros dominan el catálogo, reflejando las preferencias del público.
- La producción de contenido varía por año, mostrando picos en determinados periodos.
- El contenido proviene de múltiples países, mostrando diversidad internacional.
Estos resultados muestran cómo una estructura de datos adecuada facilita el análisis exploratorio y la obtención de insights sobre el catálogo de contenido.
