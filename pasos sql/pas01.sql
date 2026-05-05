-- Pas 1. Adria Malai, Joan Peña


CREATE DATABASE IF NOT EXISTS lstaste_track
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE lstaste_track;

DROP TABLE IF EXISTS comandes_raw;

CREATE TABLE comandes_raw (
    id_comanda      INT             NOT NULL,
    id_taula        INT             NOT NULL,
    data_comanda    DATE            NOT NULL,
    hora_comanda    TIME            NOT NULL,
    nom_plat        VARCHAR(100)    NOT NULL,
    categoria_plat  VARCHAR(50)     NOT NULL,
    preu            DECIMAL(5,2)    NOT NULL,
    quantitat       INT             NOT NULL,
    id_cambrer      INT             NOT NULL,
    valoracio       INT             NULL,
    PRIMARY KEY (id_comanda)
);


LOAD DATA LOCAL INFILE 'C:\\laragon\\data\\mysql-8.4\\lstaste_track\\comandes.csv'
INTO TABLE comandes_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_comanda, id_taula, data_comanda, hora_comanda, nom_plat, categoria_plat, preu, quantitat, id_cambrer, @valoracio)
SET valoracio = NULLIF(@valoracio, '');

-- Comprobació de que s'han carregat bé les dades del .csv:
SELECT COUNT(*) FROM comandes_raw;
SELECT * FROM comandes_raw LIMIT 15;