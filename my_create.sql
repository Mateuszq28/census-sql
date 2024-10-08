CREATE DATABASE census;


CREATE TABLE people (
    -- PK
    person_id int NOT NULL UNIQUE,

    pesel varchar(11) NOT NULL UNIQUE,
    first_name varchar(255),
    last_name varchar(255),
    birth_date date CHECK
    ( birth_date >= '1900-01-01' ),
    -- sex SET('m', 'k'),
    sex varchar(1) CHECK ( sex = 'm' OR sex = 'k' ),

    -- FKs
    mother_id int,
    father_id int,
    -- woman can't have a wife
    wife_id int CHECK
    ( wife_id IS NULL OR sex = 'm'),
    -- man can't have a husband
    husband_id int CHECK
    ( husband_id IS NULL OR sex = 'k'),

    country varchar(255) CHECK
    ( country = 'POLAND' ),

    -- PK
    PRIMARY KEY (person_id),

    -- FKs
    CONSTRAINT FK_mother_person
    FOREIGN KEY (mother_id)
    REFERENCES people(person_id),

    CONSTRAINT FK_father_person
    FOREIGN KEY (father_id)
    REFERENCES people(person_id),

    CONSTRAINT FK_wife_person
    FOREIGN KEY (wife_id)
    REFERENCES people(person_id),

    CONSTRAINT FK_husband_person
    FOREIGN KEY (husband_id)
    REFERENCES people(person_id)
);


CREATE TABLE work_companies (
    -- PK
    work_company_id int NOT NULL UNIQUE,
    company_name varchar(255),
    chairman_id int,

    -- PK
    PRIMARY KEY (work_company_id),

    -- FK
    CONSTRAINT FK_chairman_company
    FOREIGN KEY (chairman_id)
    REFERENCES people(person_id)
);


CREATE TABLE employment (
    -- PK
    job_id int NOT NULL UNIQUE,

    worker_id int,
    work_company_id int,
    -- contract_type  SET('zlecenie', 'praca'),
    contract_type varchar(255) CHECK
    ( contract_type = 'mandate' OR
      contract_type = 'employment' ),
    salary float,

    -- PK
    PRIMARY KEY (job_id),

    -- FK
    CONSTRAINT FK_worker_job
    FOREIGN KEY (worker_id)
    REFERENCES people(person_id),

    CONSTRAINT FK_company_job
    FOREIGN KEY (work_company_id)
    REFERENCES work_company(work_company_id)
);


-- INDEXING TABLES

CREATE INDEX idx_first_name ON people (first_name);
CREATE INDEX idx_last_name ON people (last_name);
CREATE INDEX idx_pesel ON people (pesel);

CREATE INDEX idx_oneGenerationFamily_manAsRoot
ON people (person_id, wife_id);
CREATE INDEX idx_oneGenerationFamily_womanAsRoot
ON people (person_id, husband_id);

CREATE INDEX
idx_oneGenerationFamily_withParents_manAsRoot
ON people (person_id, wife_id, father_id);
CREATE INDEX
idx_oneGenerationFamily_withParents_womanAsRoot
ON people (person_id, husband_id, mother_id);