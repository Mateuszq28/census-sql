-- ======
-- TASK A
-- ======

-- Find the name and surname of the person with the most female grandchildren.

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
    p1.person_id
ORDER BY 
    female_grandchildren_count DESC
LIMIT 1;


-- Views

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
        p1.person_id
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

-- ======
-- TASK B
-- ======

-- Present the average number of employees employed under a mandate contract and the average number of employees employed under an employment contract in all companies and the average salary for these contracts.



-- Chat GPT answer

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

-- output:
-- employment|10.0|14360.5565833333
-- mandate|9.0|14763.3918518519


-- My edit of Chat GPT answer

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


-- Result of my ask chat-GPT to correct querry

WITH contract_counts AS (
    SELECT
        employment.work_company_id,
        company_name,
        contract_type,
        COUNT(worker_id) AS employee_count,
        AVG(salary) AS average_salary
    FROM
        employment, work_companies
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
LEFT JOIN
    (SELECT * FROM contract_counts WHERE contract_type = 'employment') cc2
ON
    cc1.work_company_id = cc2.work_company_id;




-- MY VIEWS
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

-- FINAL VIEW

DROP VIEW TASK_B;
CREATE VIEW TASK_B AS
SELECT
* FROM company_id_mandate_count_avg
FULL OUTER JOIN company_id_employment_count_avg ON
company_id_mandate_count_avg.work_company_id =
company_id_employment_count_avg.work_company_id;
SELECT * FROM TASK_B;


-- ======
-- TASK c
-- ======