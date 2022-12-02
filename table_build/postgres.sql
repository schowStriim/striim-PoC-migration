CREATE SCHEMA striim_schema;

CREATE TABLE striim_schema.employee (
    Id int8 NOT NULL,
    name_target varchar(120) NOT NULL,
    salary int8 NOT NULL,
    CONSTRAINT emp_pk PRIMARY KEY (id)
);