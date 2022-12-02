CREATE SCHEMA striim_schema;

CREATE TABLE striim_schema.employee (
    id int64 NOT NULL, 
    name_target string NOT NULL, 
    salary int64 NOT NULL
    );