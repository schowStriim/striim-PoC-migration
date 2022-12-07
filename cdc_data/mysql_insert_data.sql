CREATE PROCEDURE insertRowsToemployeeCDC()   
BEGIN
DECLARE i INT DEFAULT 15001; 
WHILE (i <= 25000) DO
    INSERT INTO striim_schema.employee ( id, name_target, salary) VALUES (i, 'John Doe', 1);
    SET i = i+1;
END WHILE;
END;

CALL insertRowsToemployeeCDC();