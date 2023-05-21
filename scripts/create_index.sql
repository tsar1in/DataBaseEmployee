CREATE INDEX name_employee_index
ON employee (name);

CREATE INDEX salary_employee_index
ON employee (salary);

CREATE INDEX staff_hours_index
ON working_hours (staff_id);

CREATE INDEX project_history_index
ON history_of_project (project_id);

CREATE INDEX project_closing_time_index
ON history_of_project (closing_time);