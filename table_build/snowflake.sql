CREATE SCHEMA striim_schema;

CREATE TABLE striim_schema.employee (
    id integer NOT NULL, 
    name_target VARCHAR(120) NOT NULL, 
    salary integer NOT NULL, 
    PRIMARY KEY (id)
    );