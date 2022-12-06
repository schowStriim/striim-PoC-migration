BEGIN
FOR v_LoopCounter IN 1..150000 LOOP
        INSERT INTO striim_schema.employee (id,name_target,salary) 
            VALUES (TO_CHAR(v_LoopCounter),'John Doe',64);

END LOOP;
COMMIT;
END;
