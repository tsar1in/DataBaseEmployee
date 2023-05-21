CREATE TABLE Department (
    department_id INT,
    name_department VARCHAR(50) NOT NULL,
    PRIMARY KEY (department_id)
);

CREATE TABLE Team (
    team_id INT,
    team_lead_id INT NOT NULL,
    name VARCHAR(30) NOT NULL,
    PRIMARY KEY (team_id)
);

CREATE TABLE City (
    city_id INT,
    name_city VARCHAR(20) NOT NULL,
    PRIMARY KEY (city_id)
);

CREATE TABLE Employee (
    staff_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(30),
    salary INT,
    city_id INT,
    department_id INT,
    team_id INT,
    CONSTRAINT email_check CHECK (email LIKE '%@%.%'),
    CONSTRAINT salary_check CHECK (salary >= 0),
    CONSTRAINT fk_dep_id FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
            ON DELETE SET NULL
            ON UPDATE CASCADE,
    CONSTRAINT fk_tm_id FOREIGN KEY (team_id)
        REFERENCES Team(team_id)
            ON DELETE SET NULL
            ON UPDATE CASCADE,
    CONSTRAINT fk_city_id FOREIGN KEY (city_id)
        REFERENCES City(city_id)
            ON DELETE SET NULL
            ON UPDATE CASCADE
);

CREATE TABLE Working_hours (
    staff_id INT,
    time_start TIMESTAMP NOT NULL ,
    time_finish TIMESTAMP NOT NULL,
    CONSTRAINT time_check CHECK (time_finish > time_start),
    CONSTRAINT fk_st_id FOREIGN KEY (staff_id)
        REFERENCES Employee(staff_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE Jobtitle (
    jobtitle_id SERIAL,
    name_jobtitle VARCHAR(30) NOT NULL,
    grade INT,
    salary_range INT,
    PRIMARY KEY (jobtitle_id),
    CONSTRAINT grade_check CHECK (grade >= 0),
    CONSTRAINT salary_range_check CHECK (salary_range >= 0)
);

CREATE TABLE dummy_table_1 (
    staff_id INT,
    jobtitle_id INT,
    CONSTRAINT fk_st_id FOREIGN KEY (staff_id)
        REFERENCES Employee(staff_id),
    CONSTRAINT fk_job_id FOREIGN KEY (jobtitle_id)
        REFERENCES Jobtitle(jobtitle_id)
);

CREATE TABLE Project (
    project_id INT,
    target VARCHAR(50),
    count_completed_task INT NOT NULL,
    count_task INT NOT NULL,
    PRIMARY KEY (project_id),
    CONSTRAINT count_com_check CHECK (count_completed_task >= 0),
    CONSTRAINT count_task_check CHECK (count_task > 0)
);

CREATE TABLE dummy_table_2 (
    team_id INT,
    project_id INT,
    CONSTRAINT fk_tm_id FOREIGN KEY (team_id)
        REFERENCES Team(team_id),
    CONSTRAINT fk_pr_id FOREIGN KEY (project_id)
        REFERENCES Project(project_id)
);

CREATE TABLE History_of_project (
    project_id INT,
    current_target VARCHAR(80),
    version VARCHAR(10),
    opening_time TIMESTAMP NOT NULL,
    closing_time TIMESTAMP,
    CONSTRAINT fk_pr_id FOREIGN KEY (project_id)
        REFERENCES Project(project_id)
);

CREATE TABLE Office (
    city_id INT NOT NULL,
    office_addres VARCHAR(50),
    CONSTRAINT fk_city_id FOREIGN KEY (city_id)
        REFERENCES City(city_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);