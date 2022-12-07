WITH salary_list AS (
    SELECT '{1000, 2000, 5000}'::INT[] salary
)
INSERT INTO striim_schema.employee
(id, name_target, salary)
SELECT n, 'Employee ' || n as name_target, salary[1 + mod(n, array_length(salary, 1))]
FROM salary_list, generate_series(150001, 250000) as n;