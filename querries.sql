-- ======
-- TASK A
-- ======

-- Find the name and surname of the person with the most female grandchildren.

-- Men - sex = 'm'
-- Woman - sex = 'k'

-- =================================================================================================================
-- Add test records

UPDATE people
SET first_name = 'Granny', last_name = 'The most of granddoughters'
WHERE person_id = 155;

UPDATE people
SET first_name = 'Granny', last_name = 'The most of grandsons'
WHERE person_id = 256;

INSERT INTO people
( person_id, pesel, first_name, last_name, birth_date, sex, mother_id, father_id, wife_id, husband_id, country )
VALUES
  -- granny with a lot of granddoughters
  (301, 75012280041, 'Mother', 'The most of granddoughters', '1998-01-22', 'k', 155, NULL, NULL, NULL, 'POLAND'),
  (302, 99312280042, 'Granddoughter', 'The most of granddoughters', '1998-01-22', 'k', 301, NULL, NULL, NULL, 'POLAND'),
  (303, 99312280043, 'Granddoughter', 'The most of granddoughters', '1998-01-22', 'k', 301, NULL, NULL, NULL, 'POLAND'),
  (304, 99312280044, 'Granddoughter', 'The most of granddoughters', '1998-01-22', 'k', 301, NULL, NULL, NULL, 'POLAND'),
  (305, 99312280045, 'Granddoughter', 'The most of granddoughters', '1998-01-22', 'k', 301, NULL, NULL, NULL, 'POLAND'),
  (306, 99312280046, 'Granddoughter', 'The most of granddoughters', '1998-01-22', 'k', 301, NULL, NULL, NULL, 'POLAND'),
  (307, 99312280047, 'Granddoughter', 'The most of granddoughters', '1998-01-22', 'k', 301, NULL, NULL, NULL, 'POLAND'),
  (308, 99312280048, 'Granddoughter', 'The most of granddoughters', '1998-01-22', 'k', 301, NULL, NULL, NULL, 'POLAND'),
  (309, 99312280049, 'Granddoughter', 'The most of granddoughters', '1998-01-22', 'k', 301, NULL, NULL, NULL, 'POLAND'),
  (310, 99312280050, 'Granddoughter', 'The most of granddoughters', '1998-01-22', 'k', 301, NULL, NULL, NULL, 'POLAND'),
  (311, 99312280051, 'Granddoughter', 'The most of granddoughters', '1998-01-22', 'k', 301, NULL, NULL, NULL, 'POLAND'),
  -- second granny (with boys)
  (312, 95012280041, 'Mother', 'The most of granddoughters', '1998-01-22', 'k', 256, NULL, NULL, NULL, 'POLAND'),
  (313, 85012280042, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (314, 85012280043, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (315, 85012280044, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (316, 85012280045, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (317, 85012280046, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (318, 85012280047, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (319, 85012280048, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (320, 85012280049, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (321, 85012280050, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (322, 85012280051, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (323, 85012280052, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (324, 85012280053, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (325, 85012280054, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (326, 85012280055, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND'),
  (327, 85012280056, 'Grandson', 'The most of granddoughters', '1998-01-22', 'm', 312, NULL, NULL, NULL, 'POLAND');

-- =================================================================================================================



-- Solved by one command using chat-gpt help

SELECT
    p1.first_name, 
    p1.last_name,
    COUNT(p3.person_id) AS female_grandchildren_count
FROM 
    people p1
JOIN 
    people p2 ON (p2.mother_id = p1.person_id OR p2.father_id = p1.person_id)
JOIN 
    people p3 ON (p3.mother_id = p2.person_id OR p3.father_id = p2.person_id)
WHERE 
    p3.sex = 'k'
GROUP BY 
    p1.person_id, p1.first_name, p1.last_name
ORDER BY 
    female_grandchildren_count DESC
LIMIT 1;

-- output:
-- first_name  last_name                   female_grandchildren_count
-- ----------  --------------------------  --------------------------
-- Granny      The most of granddoughters  10


-- my method with a use of views
-- Views

DROP VIEW persons_female_grandchildren_count;
CREATE VIEW persons_female_grandchildren_count AS
    SELECT
        p1.person_id,
        p1.first_name, 
        p1.last_name,
        COUNT(p3.person_id) AS female_grandchildren_count
    FROM 
        people p1
    JOIN 
        people p2 ON (p2.mother_id = p1.person_id OR p2.father_id = p1.person_id)
    JOIN 
        people p3 ON (p3.mother_id = p2.person_id OR p3.father_id = p2.person_id)
    WHERE 
        p3.sex = 'k'
    GROUP BY 
        p1.person_id, p1.first_name, p1.last_name
;
SELECT * FROM persons_female_grandchildren_count;


CREATE VIEW all_persons_have_max_granddoughter_count AS
SELECT * FROM persons_female_grandchildren_count
WHERE 
    female_grandchildren_count =
        (SELECT MAX(female_grandchildren_count) FROM persons_female_grandchildren_count)
;
SELECT * FROM all_persons_have_max_granddoughter_count;


CREATE VIEW one_person_have_max_granddoughter_count AS
SELECT * FROM all_persons_have_max_granddoughter_count
ORDER BY person_id ASC
LIMIT 1;
SELECT * FROM one_person_have_max_granddoughter_count;


CREATE VIEW TASK_A AS
SELECT * FROM one_person_have_max_granddoughter_count;
SELECT * FROM TASK_A;

-- output:
-- sqlite> SELECT * FROM TASK_A;
-- person_id  first_name  last_name                   female_grandchildren_count
-- ---------  ----------  --------------------------  --------------------------
-- 155        Granny      The most of granddoughters  10
-- sqlite>


-- ======
-- TASK B
-- ======

-- Present the average number of employees employed under a mandate contract and the average number of employees employed under an employment contract in all companies and the average salary for these contracts.



-- Chat GPT answer

DROP VIEW gpt_1;
CREATE VIEW gpt_1 AS
WITH contract_counts AS (
    SELECT
        work_company_id,
        contract_type,
        COUNT(worker_id) AS employee_count,
        AVG(salary) AS average_salary
    FROM
        employment
    GROUP BY
        work_company_id,
        contract_type
)

SELECT
    contract_type,
    AVG(employee_count) AS avg_employee_count,
    AVG(average_salary) AS avg_salary
FROM
    contract_counts
GROUP BY
    contract_type;
SELECT * FROM gpt_1;

-- output (wrong):
-- sqlite> SELECT * FROM gpt_1;
-- contract_type  avg_employee_count  avg_salary
-- -------------  ------------------  ----------------
-- employment     10.0                14360.5565833333
-- mandate        9.0                 14763.3918518519
-- sqlite>


-- My edit of Chat GPT answer

DROP VIEW gpt_2;
CREATE VIEW gpt_2 AS
WITH contract_counts AS (
    SELECT
        work_company_id,
        contract_type,
        COUNT(worker_id) AS employee_count,
        AVG(salary) AS average_salary
    FROM
        employment
    GROUP BY
        work_company_id,
        contract_type
)

SELECT
    work_company_id,
    contract_type,
    AVG(employee_count) AS avg_employee_count,
    AVG(average_salary) AS avg_salary
FROM
    contract_counts
GROUP BY
    work_company_id,
    contract_type;
SELECT * FROM gpt_2;

-- output (wrong, but interesting):
-- sqlite> SELECT * FROM gpt_2;
-- work_company_id  contract_type  avg_employee_count  avg_salary
-- ---------------  -------------  ------------------  ----------------
-- 1                employment     10.0                10467.879
-- 2                mandate        9.0                 15747.3622222222
-- 3                employment     10.0                11836.202
-- 3                mandate        9.0                 14710.3266666667
-- 4                employment     10.0                15872.558
-- 4                mandate        9.0                 18280.0877777778
-- 5                employment     10.0                15871.64
-- 5                mandate        9.0                 14347.32
-- ...


-- Result of my ask chat-GPT to correct querry
-- + MY EDIT

DROP VIEW gpt_3;
CREATE VIEW gpt_3 AS
WITH contract_counts AS (
    SELECT
        employment.work_company_id,
        company_name,
        contract_type,
        COUNT(worker_id) AS employee_count,
        AVG(salary) AS average_salary
    FROM
        employment
    LEFT JOIN work_companies
    ON work_companies.work_company_id = employment.work_company_id
    GROUP BY
        employment.work_company_id,
        contract_type
)

SELECT
    cc1.work_company_id,
    cc1.company_name,
    COALESCE(cc1.employee_count, 0) AS mandate_employee_count,
    COALESCE(cc1.average_salary, 0) AS mandate_avg_salary,
    COALESCE(cc2.employee_count, 0) AS employment_employee_count,
    COALESCE(cc2.average_salary, 0) AS employment_avg_salary
FROM
    (SELECT * FROM contract_counts WHERE contract_type = 'mandate') cc1
FULL OUTER JOIN
    (SELECT * FROM contract_counts WHERE contract_type = 'employment') cc2
ON
    cc1.work_company_id = cc2.work_company_id;
SELECT * FROM gpt_3;


-- output:
-- sqlite> SELECT * FROM gpt_3;
-- work_company_id  company_name          mandate_employee_count  mandate_avg_salary  employment_employee_count  employment_avg_salary
-- ---------------  --------------------  ----------------------  ------------------  -------------------------  ---------------------
-- 2                Green Energy Corp     9                       15747.3622222222    0                          0
-- 3                Innovatech            9                       14710.3266666667    10                         11836.202
-- 4                Blue Horizon          9                       18280.0877777778    10                         15872.558
-- 5                Quantum Industries    9                       14347.32            10                         15871.64
-- 6                Future Vision         9                       15932.1711111111    10                         12926.978
-- ...


-- MY method to solve it by VIEWS
-------------------------

-- count mandates, group by company
-- employment_company_id__employment_contract_type=mandate_count
DROP VIEW e_c_id__e_m_count;
CREATE VIEW e_c_id__e_m_count AS
SELECT
e.work_company_id AS work_company_id,
e.contract_type AS contract_type,
COUNT(*) AS mandate_count
FROM employment e WHERE e.contract_type = 'mandate'
GROUP BY e.work_company_id;
SELECT * FROM e_c_id__e_m_count;

-- count employment, group by company
-- employment_company_id__employment_contract_type=employment_count
DROP VIEW e_c_id__e_e_count;
CREATE VIEW e_c_id__e_e_count AS
SELECT
e.work_company_id AS work_company_id,
e.contract_type AS contract_type,
COUNT(*) AS employment_count
FROM employment e WHERE e.contract_type = 'employment'
GROUP BY e.work_company_id;
SELECT * FROM e_c_id__e_e_count;

-- ++++++++++++++++++++++++++++++++++++++

-- average mandates salary, group by company
-- employment_company_id__employment_contract_type=mandate_salary
DROP VIEW e_c_id__e_avg_m_s;
CREATE VIEW e_c_id__e_avg_m_s AS
SELECT
e.work_company_id AS work_company_id,
e.contract_type AS contract_type,
AVG(e.salary) AS mandate_avg_salary
FROM employment e WHERE e.contract_type = 'mandate'
GROUP BY e.work_company_id;
SELECT * FROM e_c_id__e_avg_m_s;

-- average employment salary, group by company
-- employment_company_id__employment_contract_type=employment_salary
DROP VIEW e_c_id__e_avg_e_s;
CREATE VIEW e_c_id__e_avg_e_s AS
SELECT
e.work_company_id AS work_company_id,
e.contract_type AS contract_type,
AVG(e.salary) AS employment_avg_salary
FROM employment e WHERE e.contract_type = 'employment'
GROUP BY e.work_company_id;
SELECT * FROM e_c_id__e_avg_e_s;

-- ++++++++++++++++++++++++++++++++++++++

DROP VIEW company_id_mandate_count_avg;
CREATE VIEW company_id_mandate_count_avg AS
SELECT
e_c_id__e_m_count.work_company_id,
e_c_id__e_m_count.contract_type,
mandate_count,
mandate_avg_salary
FROM e_c_id__e_m_count, e_c_id__e_avg_m_s
GROUP BY e_c_id__e_m_count.work_company_id;
SELECT * FROM company_id_mandate_count_avg;

DROP VIEW company_id_employment_count_avg;
CREATE VIEW company_id_employment_count_avg AS
SELECT
e_c_id__e_e_count.work_company_id,
e_c_id__e_e_count.contract_type,
employment_count,
employment_avg_salary
FROM e_c_id__e_e_count, e_c_id__e_avg_e_s
GROUP BY e_c_id__e_e_count.work_company_id;
SELECT * FROM company_id_employment_count_avg;



-- ++++++++++++++++++++++++++++++++++++++

-- TO TEST JOIN
SELECT * FROM employment WHERE contract_type = 'mandate' AND work_company_id = 1;
DELETE FROM employment WHERE contract_type = 'mandate' AND work_company_id = 1;
SELECT * FROM employment WHERE contract_type = 'mandate' AND work_company_id = 1;

-- TO TEST JOIN
SELECT * FROM employment WHERE contract_type = 'employment' AND work_company_id = 2;
DELETE FROM employment WHERE contract_type = 'employment' AND work_company_id = 2;
SELECT * FROM employment WHERE contract_type = 'employment' AND work_company_id = 2;


-- ++++++++++++++++++++++++++++++++++++++


DROP VIEW no_name;
CREATE VIEW no_name AS
SELECT
* FROM company_id_mandate_count_avg
FULL OUTER JOIN company_id_employment_count_avg ON
company_id_mandate_count_avg.work_company_id =
company_id_employment_count_avg.work_company_id;
SELECT * FROM no_name;


-- FINAL VIEW

DROP VIEW TASK_B;
CREATE VIEW TASK_B AS
SELECT
no_name.work_company_id,
work_companies.company_name,
no_name.contract_type,
no_name.employment_count,
no_name.employment_avg_salary
FROM no_name
LEFT JOIN work_companies
ON work_companies.work_company_id = no_name.work_company_id
GROUP BY no_name.work_company_id;
SELECT * FROM TASK_B;


-- output:
-- sqlite> SELECT * FROM TASK_B;
-- work_company_id  company_name          contract_type  employment_count  employment_avg_salary
-- ---------------  --------------------  -------------  ----------------  ---------------------
--                                                       10                10467.879
-- 2                Green Energy Corp     mandate
-- 3                Innovatech            mandate        10                10467.879
-- 4                Blue Horizon          mandate        10                10467.879
-- 5                Quantum Industries    mandate        10                10467.879
-- 6                Future Vision         mandate        10                10467.879
-- ...



-- ======
-- TASK c
-- ======

-- Find a family (at most 2 generations) that earns the least. Provide the name and surname of any person in that family.



------------------------------------------- GOOD

DROP VIEW persons_family_members;
CREATE VIEW
persons_family_members AS

SELECT
p.person_id AS person_id,
p.first_name AS person_first_name,
p.last_name AS person_last_name,
fm.person_id AS family_member_id,
fm.first_name AS family_member_first_name,
fm.last_name AS family_member_last_name

FROM
people p

CROSS JOIN
people fm
WHERE
fm.person_id IN (
p.person_id,
p.husband_id,
p.mother_id
)
OR
fm.mother_id = p.person_id
OR
fm.father_id = p.person_id

ORDER BY
p.person_id;
SELECT * FROM persons_family_members;

------------------------------------------- GOOD
------------------------------------------- GOOD

DROP VIEW persons_family_members_salaries;
CREATE VIEW
persons_family_members_salaries AS
SELECT
pfm.person_id AS person_id,
pfm.person_first_name AS person_first_name,
pfm.person_last_name AS person_last_name,
pfm.family_member_id AS family_member_id,
pfm.family_member_first_name AS family_member_first_name,
pfm.family_member_last_name AS family_member_last_name,
e.salary AS family_member_salary

FROM
persons_family_members pfm

CROSS JOIN
employment e
ON e.worker_id = pfm.family_member_id;
SELECT * FROM persons_family_members_salaries;

------------------------------------------- GOOD
------------------------------------------- GOOD

DROP VIEW persons_family_members_salaries_count;
CREATE VIEW
persons_family_members_salaries_count AS
SELECT
pfms.person_id,
pfms.family_member_id,
COUNT(pfms.family_member_salary) AS family_member_salary_count
FROM persons_family_members_salaries pfms
GROUP BY
pfms.person_id, pfms.family_member_id
ORDER BY family_member_salary_count;
SELECT * FROM persons_family_members_salaries_count;

------------------------------------------- GOOD
------------------------------------------- GOOD

DROP VIEW persons_family_income;
CREATE VIEW
persons_family_income AS
SELECT
pfms.person_id,
pfms.person_first_name,
pfms.person_last_name,
SUM(pfms.family_member_salary) AS family_income
FROM persons_family_members_salaries pfms
GROUP BY
pfms.person_id,
pfms.person_first_name,
pfms.person_last_name
-- ORDER BY person_id;
ORDER BY family_income ASC;
SELECT * FROM persons_family_income;

------------------------------------------- GOOD
------------------------------------------- GOOD

DROP VIEW TASK_C;
CREATE VIEW TASK_C AS
SELECT * FROM persons_family_income
LIMIT 1;
SELECT * FROM TASK_C;

------------------------------------------- GOOD

-- output
-- sqlite> SELECT * FROM TASK_C;
-- person_id  person_first_name  person_last_name  family_income
-- ---------  -----------------  ----------------  -------------
-- 140        Tomasz             Sadowski          4309.71
-- sqlite>