-- Pas 5. Adria Malai, Joan Peña
  
DELIMITER $$ 

DROP PROCEDURE IF EXISTS sincronitzar_cataleg $$ 
 
CREATE PROCEDURE sincronitzar_cataleg() 
BEGIN 
    DECLARE done INT DEFAULT 0; 
    DECLARE v_nom VARCHAR(255); 
     
    DECLARE cur1 CURSOR FOR 
        SELECT DISTINCT nom_plat  
        FROM comandes_raw  
        WHERE LOWER(TRIM(nom_plat)) NOT IN (SELECT nom_plat FROM MD_plat); 
         
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
 
    OPEN cur1; 
 
    bucle: LOOP 
        FETCH cur1 INTO v_nom; 
        IF done = 1 THEN 
            LEAVE bucle; 
        END IF; 
         
        SET v_nom = LOWER(TRIM(v_nom)); 
        INSERT INTO MD_plat (nom_plat, categoria, descripcio, preu_base) 
        VALUES (v_nom, 'sense categoria', 'Descripció pendent', 0.00); 
 
    END LOOP bucle; 
 
    CLOSE cur1; 
END $$ 
 
DELIMITER ;

-- Comprobació de que procedure s'ha creat:
SHOW PROCEDURE STATUS WHERE Db = 'lstaste_track' AND Name = 'sincronitzar_cataleg';