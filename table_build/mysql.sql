CREATE SCHEMA striim_schema;

CREATE TABLE striim_schema.employee (
    id bigint NOT NULL, 
    name_target varchar(120) NOT NULL, 
    salary bigint NOT NULL, 
    PRIMARY KEY (id));