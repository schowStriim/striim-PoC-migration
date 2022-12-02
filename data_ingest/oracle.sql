BEGIN
FOR v_LoopCounter IN 1..150000 LOOP
        INSERT INTO ADMIN.employee2 (id,name_target,salary) 
            VALUES (TO_CHAR(v_LoopCounter),'John Doe',64);

END LOOP;
COMMIT;
END;
