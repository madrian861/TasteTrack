-- Pas 8. Adria Malai, Joan Peña

DROP USER IF EXISTS 'tt_data_loader'@'[localhost](http://localhost)';
DROP USER IF EXISTS 'tt_user'@'[localhost](http://localhost)';
DROP USER IF EXISTS 'tt_backup'@'[localhost](http://localhost)';
DROP USER IF EXISTS 'tt_auditor'@'[localhost](http://localhost)';
DROP USER IF EXISTS 'tt_admin'@'[localhost](http://localhost)';


CREATE USER 'tt_data_loader'@'localhost' IDENTIFIED BY 'Password1234'; 
CREATE USER 'tt_user'@'localhost' IDENTIFIED BY 'Password1234'; 
CREATE USER 'tt_backup'@'localhost' IDENTIFIED BY 'Password1234'; 
CREATE USER 'tt_auditor'@'localhost' IDENTIFIED BY 'Password1234'; 
CREATE USER 'tt_admin'@'localhost' IDENTIFIED BY 'Password1234'; 
GRANT FILE ON *.* TO 'tt_data_loader'@'localhost'; 
GRANT SELECT, INSERT, UPDATE, DELETE ON lstaste_track.comandes_raw TO 
'tt_data_loader'@'localhost'; 
GRANT EXECUTE ON lstaste_track.* TO 'tt_user'@'localhost';
GRANT FILE ON *.* TO 'tt_user'@'localhost'; -- Per exportar fitxers 
GRANT SELECT, INSERT, UPDATE, DELETE ON lstaste_track.* TO 
'tt_user'@'localhost';
GRANT SELECT ON lstaste_track.* TO 'tt_backup'@'localhost';
GRANT ALL PRIVILEGES ON lstaste_track_backup.* TO 'tt_backup'@'localhost';
GRANT SELECT ON lstaste_track.* TO 'tt_auditor'@'localhost';
GRANT SELECT ON lstaste_track_backup.* TO 'tt_auditor'@'localhost';
GRANT ALL PRIVILEGES ON lstaste_track.* TO 'tt_admin'@'localhost';
GRANT ALL PRIVILEGES ON lstaste_track_backup.* TO 'tt_admin'@'localhost';
FLUSH PRIVILEGES; 


-- Comprobacions de persmisos amb tt_data_loader
-- llegir comandes_raw: SI
SELECT COUNT(*) FROM lstaste_track.comandes_raw;

-- accedir a MD_plat: NO
SELECT COUNT(*) FROM lstaste_track.MD_plat;