-- 1) Процедура для ищменения цели проекта (target)
-- в таблице Project и автоматического занесения
-- предыдущей версии в таблицу History_of_project

CREATE OR REPLACE PROCEDURE update_project_target (
    project_id INT,
    new_target VARCHAR(50)
)
LANGUAGE SQL
AS $$
INSERT INTO History_of_project (project_id, current_target, version, opening_time, closing_time)
VALUES (project_id, (SELECT target FROM project WHERE project_id = project_id), 'vi.0', NOW(), NULL);
-- Подзапрос для получения предыдущей (уже выполненой) цели проекта

UPDATE project
SET target = new_target
WHERE project_id = project_id;
$$;

-- 2) Процедура для добавления в базу данных информации
-- о новом сотруднике

CREATE OR REPLACE PROCEDURE add_employee (
    staff_id INT,
  	name VARCHAR(50),
    email VARCHAR(30),
    salary INT,
    city_id INT,
    department_id INT,
    team_id INT,
    jobtitle_id INT
)
LANGUAGE SQL
AS $$
INSERT INTO employee
VALUES (staff_id, name, email, salary, city_id, department_id, team_id);

INSERT INTO dummy_table_1
VALUES (staff_id, jobtitle_id);
$$