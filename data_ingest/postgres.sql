WITH salary_list AS (
    SELECT '{1000, 2000, 5000}'::INT[] salary
)
INSERT INTO employee
(id, name_target, salary)
SELECT n, 'Employee ' || n as name_target, salary[1 + mod(n, array_length(salary, 1))]
FROM salary_list, generate_series(1, 150000) as n;
