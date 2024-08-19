CREATE DATABASE census;

CREATE TABLE people (
    -- PK
    person_id int NOT NULL UNIQUE,

    pesel varchar(255) NOT NULL UNIQUE,
    first_name varchar(255),
    last_name varchar(255),
    birth_date date CHECK
    ( birth_date >= '1900-01-01' ),
    sex SET('m', 'k'),

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
    earnings float,

    -- PK
    PRIMARY KEY (person_id),

    -- FKs
    CONSTRAINT FK_mother_person
    FOREIGN KEY (mother_id)
    REFERENCES people(mother_id),

    CONSTRAINT FK_father_person
    FOREIGN KEY (father_id)
    REFERENCES people(father_id),

    CONSTRAINT FK_wife_person
    FOREIGN KEY (wife_id)
    REFERENCES people(wife_id),

    CONSTRAINT FK_husband_person
    FOREIGN KEY (husband_id)
    REFERENCES people(husband_id)
);





