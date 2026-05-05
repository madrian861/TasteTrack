-- Pas 6. Adria Malai, Joan Peña

-- Taula d'auditoria per a comandes 
DROP TABLE IF EXISTS auditoria_comandes; 
CREATE TABLE auditoria_comandes ( 
    id INT AUTO_INCREMENT PRIMARY KEY, 
    operacio VARCHAR(10),     -- INSERT/UPDATE/DELETE 
    id_comanda INT, 
    usuari VARCHAR(100),      -- CURRENT_USER() 
    data_operacio DATETIME,   -- NOW() 
    detall TEXT 
); 
 
DELIMITER $$ 
 
DROP TRIGGER IF EXISTS trg_auditoria_insert_comanda $$ 
 
CREATE TRIGGER trg_auditoria_insert_comanda 
AFTER INSERT ON comandes_net 
FOR EACH ROW 
BEGIN 
    INSERT INTO auditoria_comandes (operacio, id_comanda, usuari, data_operacio, detall) 
    VALUES ( 
        'INSERT',  
        NEW.id_comanda,  
        CURRENT_USER(),  
        NOW(),  
        CONCAT('S’ha registrat una nova comanda del plat: ', NEW.nom_plat) 
    ); 
END $$ 
 
DELIMITER ; 
 -- Taula d'auditoria per a MD_plat 
DROP TABLE IF EXISTS auditoria_plats; 
CREATE TABLE auditoria_plats ( 
    id INT AUTO_INCREMENT PRIMARY KEY, -- Recomanat per tenir un ordre 
    nom_anterior VARCHAR(100),  
    nom_nou VARCHAR(100),  
    usuari VARCHAR(100),     
    data_operacio DATETIME 
); 
 
DELIMITER $$ 
 -- Trigger per a canvis (UPDATE) 
DROP TRIGGER IF EXISTS trg_update_md_plat $$ 
 
CREATE TRIGGER trg_update_md_plat 
AFTER UPDATE ON MD_plat 
FOR EACH ROW 
BEGIN 
    INSERT INTO auditoria_plats (nom_anterior, nom_nou, usuari, data_operacio) 
    VALUES ( 
        OLD.nom_plat, -- Corregit: En MySQL s'usa OLD, no O 
        NEW.nom_plat, -- Corregit: En MySQL s'usa NEW, no N[cite: 1] 
        CURRENT_USER(),  
        NOW() 
    ); 
END $$ 
 -- Trigger per a eliminacions (DELETE)[cite: 1] 
DROP TRIGGER IF EXISTS trg_delete_md_plat $$ 
 
CREATE TRIGGER trg_delete_md_plat 
AFTER DELETE ON MD_plat 
FOR EACH ROW 
BEGIN 
    INSERT INTO auditoria_plats (nom_anterior, nom_nou, usuari, data_operacio) 
    VALUES ( 
        OLD.nom_plat,  
        NULL,         -- Corregit: En un DELETE no hi ha "nom nou", posem NULL[cite: 1] 
        CURRENT_USER(),  
        NOW() 
    ); 
END $$ 
 
DELIMITER ;

LOAD DATA LOCAL INFILE 'C:\\laragon\\data\\mysql-8.4\\lstaste_track\\comandes2.csv'
INTO TABLE md_plat
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'   -- ← canvi aquí
IGNORE 1 ROWS
(id_comanda, id_taula, data_comanda, hora_comanda, nom_plat, 
 categoria_plat, preu, quantitat, id_cambrer, @valoracio)
SET valoracio = NULLIF(TRIM(@valoracio), '');  -- ← TRIM() afegit

SELECT * FROM comandes_raw;

SELECT * FROM auditoria_plats;
