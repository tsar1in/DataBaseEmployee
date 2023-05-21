----1) Вывести сотрудников
CREATE OR REPLACE VIEW information_salary_employee AS
    SELECT
        name,
        CONCAT(REPEAT('*', LENGTH(email) - POSITION('@' IN email)), SUBSTRING(email, POSITION('@' IN email),LENGTH(email))) AS email,
        salary
    FROM
        employee
WITH CASCADED CHECK OPTION

----2) Время работы и личные данные сотрудников
CREATE OR REPLACE VIEW working_time_employee AS
    SELECT
        employee.name,
        CONCAT(REPEAT('*', LENGTH(email) - POSITION('@' IN email)), SUBSTRING(email, POSITION('@' IN email),LENGTH(email))) AS email,
        salary,
        EXTRACT(HOUR FROM SUM(time_finish - time_start)) AS working_time
    FROM
        working_hours
            INNER JOIN
        employee
        USING(staff_id)
    GROUP BY
        staff_id,
        employee.name
    ORDER BY
        working_time DESC

----3) Информация по городам (город, количество
----   работников, средняя зарплата)

CREATE OR REPLACE VIEW city_stats AS
    SELECT
        name_city,
        COUNT(name) AS count_employee,
        ROUND(AVG(salary), 2) as avg_salary
    FROM
        employee
    INNER JOIN
        city
    USING(city_id)
    GROUP BY
        name_city
    ORDER BY
        avg_salary DESC

----4) Вывести информацию о сотрудниках
CREATE OR REPLACE VIEW information_employee AS
    SELECT
        employee.name as name,
        CONCAT(REPEAT('*', LENGTH(email) - POSITION('@' IN email)), SUBSTRING(email, POSITION('@' IN email),LENGTH(email))) AS email,
        salary,
        team.name AS team,
        name_department AS department,
        name_jobtitle AS jobtitle
    FROM ((((employee
        INNER JOIn team USING(team_id))
        INNER JOIN department USING(department_id))
        INNER JOIN dummy_table_1 USING(staff_id)))
        INNER JOIN jobtitle USING (jobtitle_id)

----5) Информация по конкретному офису (город, адрес,
----   количество работников, средняя зарплата)

CREATE OR REPLACE VIEW information_office AS
    SELECT
        name_city,
        office_addres,
        COUNT(employee.name) AS count_employee,
        ROUND(AVG(salary), 2) AS avg_salary
    FROM (city
        INNER JOIN office USING(city_id))
        INNER JOIn employee USING(city_id)
    GROUP BY name_city, office_addres
    ORDER BY avg_salary DESC

----6) Вывести информацию по проектам команды
----   (название команды, текущая задача
----   предыдущие версии проекта, их задачи и
----   время закрытия этой версии

CREATE OR REPLACE VIEW project_version_inf AS
    SELECT
        team.name AS team_name,
        target AS current_target,
        current_target AS previous_target,
        version AS version_prev_target,
        closing_time
    FROM ((team
        INNER JOIN dummy_table_2 USING(team_id))
        INNER JOIN project USING(project_id))
        INNER JOIN history_of_project2 USING(project_id)
    ORDER BY
        version DESC