CREATE USER striim_schema IDENTIFIED BY striim_password
CREATE TABLE employee (
    id int NOT NULL, 
    name_target VARCHAR2(120) NOT NULL, 
    salary int NOT NULL, 
    PRIMARY KEY (id));