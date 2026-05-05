-- Pas 3. Adria Malai, Joan Peña


DROP TABLE IF EXISTS control_carregues;
CREATE TABLE control_carregues (
    id              INT             NOT NULL AUTO_INCREMENT,
    nom_fitxer      VARCHAR(255)    NOT NULL,
    files_inserides INT             NOT NULL,
    data_carrega    DATETIME        NOT NULL,
    PRIMARY KEY (id)
);

DROP PROCEDURE IF EXISTS carregar_comandes_net;
DELIMITER $$
CREATE PROCEDURE carregar_comandes_net(IN p_nom_fitxer VARCHAR(255))
BEGIN
    TRUNCATE TABLE comandes_net; 
    INSERT INTO comandes_net (
        id_comanda, id_taula, data_comanda, hora_comanda,
        nom_plat, categoria_plat, preu, quantitat,
        id_cambrer, valoracio, es_cap_de_setmana, import_total
    )
    SELECT
        id_comanda,
        id_taula,
        data_comanda,
        hora_comanda,
        nom_plat,
        categoria_plat,
        preu,
        quantitat,
        id_cambrer,
        IF(valoracio IS NULL, 0, valoracio),
        DAYOFWEEK(data_comanda) IN (1, 7),
        preu * quantitat
    FROM comandes_raw;

    -- Registre de control al final de cada execució
    INSERT INTO control_carregues (nom_fitxer, files_inserides, data_carrega)
    VALUES (p_nom_fitxer, ROW_COUNT(), NOW());

	-- IMPORTANT! ASEGURAR-SE D'HAVER CREAT ABANS EN PAS 5 EL PROCEDURE "sincronitzar_cataleg"; SINO ERROR!!
    CALL sincronitzar_cataleg();

END$$
DELIMITER ;

CALL carregar_comandes_net('comandes.csv');


DROP PROCEDURE IF EXISTS exportar_control;
DELIMITER $$
CREATE PROCEDURE exportar_control(IN p_ruta VARCHAR(500))
BEGIN
    SET @aux = CONCAT(
        "SELECT id, nom_fitxer, files_inserides, data_carrega ",
        "INTO OUTFILE '", p_ruta, "' ",
        "FIELDS TERMINATED BY ';' ",
        "OPTIONALLY ENCLOSED BY '\"' ",
        "LINES TERMINATED BY '\n' ",
        "FROM control_carregues"
    );

    PREPARE execucio FROM @aux;
    EXECUTE execucio;
    DEALLOCATE PREPARE execucio;
END$$
DELIMITER ;

-- Comprobació de que els registres s'han insertat adecuadament:
SELECT * FROM control_carregues;