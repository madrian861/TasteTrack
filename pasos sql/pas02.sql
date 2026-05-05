-- Pas 2. Adria Malai, Joan Peña

USE lstaste_track;

DROP TABLE IF EXISTS comandes_net;
CREATE TABLE comandes_net LIKE comandes_raw;

-- Modificar valoracio: de NULL a NOT NULL DEFAULT 0
ALTER TABLE comandes_net 
    MODIFY COLUMN valoracio INT NOT NULL DEFAULT 0;

-- Afegir les columnes addicionals
ALTER TABLE comandes_net
    ADD COLUMN es_cap_de_setmana BOOLEAN    NOT NULL,
    ADD COLUMN import_total      DECIMAL(7,2) NOT NULL;


DROP PROCEDURE IF EXISTS carregar_comandes_net;
DELIMITER $$    
CREATE PROCEDURE carregar_comandes_net()
BEGIN
    INSERT INTO comandes_net (
        id_comanda, id_taula, data_comanda, hora_comanda,
        nom_plat, categoria_plat, preu, quantitat,
        id_cambrer, valoracio, es_cap_de_setmana, import_total
    )
    SELECT
        id_comanda, id_taula, data_comanda, hora_comanda,
        nom_plat, categoria_plat, preu, quantitat,
        id_cambrer,
        IF(valoracio IS NULL, 0, valoracio),
        DAYOFWEEK(data_comanda) IN (1, 7),
        preu * quantitat
    FROM comandes_raw;
END$$
DELIMITER ;

-- comprobació amb count per assegurar que els 100 s'han carregat:
CALL carregar_comandes_net();
SELECT COUNT(*) AS total_registres FROM comandes_net;