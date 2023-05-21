-- CRUD (CREATE READ UPDATE DELETE)

-- CREATE (INSERT) - сделаны в файле inserts.sql

-- READ
SELECT * FROM employee;

SELECT * FROM team;

SELECT * FROM department;

SELECT * FROM jobtitle;

SELECT * FROM working_hours;

SELECT
    staff_id,
    name,
    name_jobtitle
FROM
    (employee INNER JOIN
    dummy_table_1 USING(staff_id))
INNER JOIN
    jobtitle
USING(jobtitle_id);

SELECT
    staff_id,
    employee.name,
    team.name
FROM
    employee
INNER JOIN
    team
USING(team_id);

SELECT
    staff_id,
    name,
    name_city
FROM
    employee
INNER JOIN
    city
USING(city_id)
WHERE
    name_city = 'Москва';

SELECT
    name_city,
    office_addres
FROM
    city
INNER JOIN
    office
USING(city_id);

SELECT
    team.name,
    COUNT(staff_id) AS count
FROM
    employee
INNER JOIN
    team
USING(team_id)
GROUP BY
    team.name;

-- UPDATE

UPDATE
    employee
SET
    team_id = 7
WHERE
    staff_id = 40;

UPDATE
    department
SET
    name_department = 'Информационные технологии (IT)'
WHERE
    department_id = 5;

UPDATE
    project
SET
    count_completed_task = 11
WHERE
    project_id = 1;

-- DELETE

DELETE FROM
    department
WHERE
    department_id = 9;
-- Удалится из таблицы department, а в остальных таблицах этот департамент заменится на null

DELETE FROM
    employee
WHERE
    staff_id = 1;
-- Не удалится, так как staff_id -- FK для dummy_table_1

DELETE FROM
    city
WHERE
    city = 'Москва'
-- В таблице Office значения для этого города удалятся каскадно