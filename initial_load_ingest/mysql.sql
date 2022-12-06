CREATE PROCEDURE insertRowsToemployee()   
BEGIN
DECLARE i INT DEFAULT 1; 
WHILE (i <= 15000) DO
    INSERT INTO striim_schema.employee ( id, name_target, salary) VALUES (i, 'John Doe', 1);
    SET i = i+1;
END WHILE;
END;

CALL insertRowsToemployee();