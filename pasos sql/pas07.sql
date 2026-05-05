-- pas 7. Adria Malai, Joan Peña

CREATE DATABASE IF NOT EXISTS lstaste_track_backup
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

DELIMITER $$ 
 
DROP PROCEDURE IF EXISTS fer_backup $$ 
 
CREATE PROCEDURE fer_backup() 
BEGIN 
    DECLARE done INT DEFAULT 0; 
    DECLARE v_nom_taula VARCHAR(255); 
    DECLARE v_data_suffix VARCHAR(8); 

	DECLARE cur_taules CURSOR FOR  
        SELECT TABLE_NAME  
        FROM INFORMATION_SCHEMA.TABLES  
        WHERE TABLE_SCHEMA = 'lstaste_track';
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
        
    SET v_data_suffix = DATE_FORMAT(NOW(), '%Y%m%d'); 
 
    OPEN cur_taules; 
 
    bucle: LOOP 
        FETCH cur_taules INTO v_nom_taula; 
        IF done = 1 THEN 
            LEAVE bucle; 
        END IF; 
 
        SET @sql_text = CONCAT( 
            'CREATE TABLE lstaste_track_backup.', v_nom_taula, '_', v_data_suffix,  
            ' AS SELECT * FROM lstaste_track.', v_nom_taula 
        ); 
        PREPARE stmt FROM @sql_text; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
 
    END LOOP bucle; 
 
    CLOSE cur_taules; 
END $$ 
 
DELIMITER ; 
 
 
DROP EVENT IF EXISTS backup_setmanal; 
 
CREATE EVENT backup_setmanal 
ON SCHEDULE EVERY 1 WEEK 
STARTS '2024-05-05 23:00:00'
ENDS '2026-12-31 23:59:59'
DO 
CALL fer_backup(); 

-- Comprobació backup:
CALL fer_backup();
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'lstaste_track_backup'
ORDER BY TABLE_NAME;