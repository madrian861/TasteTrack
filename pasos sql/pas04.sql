-- Pas 4. Adria Malai, Joan Peña


DROP TABLE IF EXISTS MD_plat;
CREATE TABLE MD_plat (
    id_plat     INT             NOT NULL AUTO_INCREMENT,
    nom_plat    VARCHAR(100)    NOT NULL,
    categoria   VARCHAR(50)     NOT NULL,
    descripcio  TEXT            NULL,
    preu_base   DECIMAL(5,2)    NOT NULL,
    PRIMARY KEY (id_plat),
    UNIQUE (nom_plat)
);

INSERT INTO MD_plat (nom_plat, categoria, preu_base)
SELECT DISTINCT
    nom_plat,
    categoria_plat,
    preu
FROM comandes_raw
ORDER BY nom_plat;


ALTER TABLE comandes_net
    ADD COLUMN id_plat INT NULL;
    
UPDATE comandes_net cn
    JOIN MD_plat mp ON cn.nom_plat = mp.nom_plat
SET cn.id_plat = mp.id_plat;

ALTER TABLE comandes_net
    ADD CONSTRAINT fk_comandes_plat
    FOREIGN KEY (id_plat) REFERENCES MD_plat(id_plat);
    
-- Comprobació de que taula md_plat te les dades ben carregades:
SELECT * FROM MD_plat LIMIT 10;
