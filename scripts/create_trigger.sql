-- 1) Автоматическое изменение зарплаты сотрудника
-- при ищменении его должности (например при повышении)

CREATE OR REPLACE FUNCTION update_employee_salary()
    RETURNS TRIGGER
AS $$
BEGIN
    UPDATE Employee
    SET salary = (
                  SELECT
                      salary_range
                  FROM
                      Jobtitle
                  WHERE jobtitle_id = new.jobtitle_id)
    WHERE
        staff_id = new.staff_id;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_salary_trigger
    AFTER UPDATE OF jobtitle_id ON dummy_table_1
    FOR EACH ROW
    EXECUTE FUNCTION update_employee_salary();

-- 2) Автоматическое добавление в таблицу History_of_project
-- данных о предыдузей версии проекта и изменение в этой таблице
-- closing_time уже сделанной версии

CREATE OR REPLACE FUNCTION add_to_project_history()
    RETURNS TRIGGER
AS $$
    BEGIN
    INSERT INTO History_of_project
    VALUES (NEW.project_id, NEW.target, 'vi.0', NOW(), NULL);
    RETURN NEW;

    UPDATE History_of_project
    SET closing_time = NOW()
    WHERE
        project_id = project_id
    AND
        opening_time = (SELECT
                            MAX(opening_time)
                        FROM
                            History_of_project
                        WHERE
                            project_id = project_id
                        );
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_to_project_history_trigger
    AFTER UPDATE OF target ON Project
    FOR EACH ROW
    EXECUTE FUNCTION add_to_project_history();


-- 3) При переводе сотрудника из одной команды в другую, то есть
-- изменении его team_id, данный триггер будет автоматически проверять
-- является лим данный сотрудник team_lead, если да, то попросит перед
-- изменением назначить нового

CREATE OR REPLACE FUNCTION check_team_lead() RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.team_id != (SELECT team_id FROM Team WHERE team_lead_id = NEW.staff_id) THEN
        RAISE EXCEPTION 'Employee is a team lead and cannot be moved to another team. Appoint a new team lead first, please';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_team_lead_trigger
    BEFORE UPDATE ON Employee
    FOR EACH ROW
    EXECUTE FUNCTION check_team_lead();

-- 4) При добавлении новых значений или обновлении таблицы Project
-- произойдет автоматическая проверка значения количества
-- выполненных задач (то что оно меньше общего количества задач)

CREATE OR REPLACE FUNCTION check_count_tasks() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.count_completed_task > NEW.count_task THEN
        RAISE EXCEPTION 'Sorry, the number of completed tasks cannot be greater than the total number of tasks';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_count_tasks_trigger
    BEFORE INSERT OR UPDATE ON Project
    FOR EACH ROW
    EXECUTE FUNCTION check_count_tasks();
