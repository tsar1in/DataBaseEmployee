-- Вывести ФИО работника, должность, grade и его зарплату.
-- Результат отсортировать по зарплате по убыванию.

SELECT
    name,
    name_jobtitle,
    grade,
    salary
FROM (
        employee
    INNER JOIN
        dummy_table_1
    USING(staff_id))
INNER JOIN
    jobtitle
USING(jobtitle_id)
ORDER BY
    salary DESC;

-- Вывести данные по командам, а именно: название, среднюю запрлату
-- и количество сотрудников, ФИО руководителя.

SELECT
    l.name AS "Название команды",
    employee.name AS "ФИО руководителя",
    "Средняя зарплата",
    "Количество сотрудников"
FROM (
     SELECT
         team.name,
         ROUND(AVG(salary), 2) AS "Средняя зарплата",
         COUNT(staff_id) AS "Количество сотрудников",
         team_lead_id
     FROM
         employee
     INNER JOIN
         team
     USING(team_id)
     GROUP BY
         team.team_id
     ORDER BY
         AVG(salary) DESC) AS l
INNER JOIN
    employee
ON employee.staff_id = l.team_lead_id

-- Вывести ФИО работника, должность, grade и его зарплату
-- Отранжировать результат по зарплате

SELECT
    DENSE_RANK() OVER(ORDER BY salary DESC) AS top,
    name,
    name_jobtitle,
    grade,
    salary
FROM (
        employee
    INNER JOIN
        dummy_table_1
    USING(staff_id))
INNER JOIN
    jobtitle
USING(jobtitle_id)

-- Отранжировать команды по количеству сотрудников.
-- Вывести названия команды и количество сотрудников в ней.

SELECT
    RANK() OVER(ORDER BY COUNT(staff_id) DESC) as top,
    team.name,
    COUNT(staff_id) AS "Количество сотрудников"
FROM
    employee
INNER JOIN
    team
USING(team_id)
GROUP BY
    team.team_id

-- Вывести таблицу сравнения зарплаты конкретного сотрудника
-- в сравнении с средней зарплатой его команды.

SELECT
    employee.name,
    salary,
    team.name,
    ROUND(avg(salary) OVER (PARTITION BY team_id), 2)
FROM
    employee
INNER JOIN
    team
USING(team_id)
ORDER BY
    salary DESC;

-- Для каждого работника вывести его имя и время последнего прохода
-- на работу, а также последнее время его выхода с работы

SELECT
    employee.name,
    LAG(time_finish, 1, NULL) OVER (PARTITION BY staff_id) AS prev_finish
FROM
    working_hours
INNER JOIN
    employee
USING(staff_id)