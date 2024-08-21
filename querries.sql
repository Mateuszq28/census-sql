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
    p1.person_id, p1.first_name, p1.last_name
ORDER BY 
    female_grandchildren_count DESC
LIMIT 1;


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

-- ======
-- TASK B
-- ======

-- Present the average number of employees employed under a mandate contract and the average number of employees employed under an employment contract in all companies and the average salary for these contracts.



-- Chat GPT answer

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

-- output:
-- employment|10.0|14360.5565833333
-- mandate|9.0|14763.3918518519


-- My edit of Chat GPT answer

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
SELECT * FROM gpt_1;


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


-- ======
-- TASK c
-- ======

-- Find a family (at most 2 generations) that earns the least. Provide the name and surname of any person in that family.


CREATE FUNCTION GetPrice (Vendor CHAR(20), Pid INT)         
    RETURNS  DECIMAL(10,3) 
    LANGUAGE SQL  
    MODIFIES SQL
    BEGIN 
    DECLARE price DECIMAL(10,3); 

    IF Vendor = 'Vendor 1' 
        THEN SET price = (SELECT ProdPrice FROM V1Table WHERE Id = Pid); 
    ELSE IF Vendor = 'Vendor 2' 
        THEN SET price = (SELECT Price 
                        FROM V2Table 
                        WHERE Pid = GetPrice.Pid); 
    END IF; 

    RETURN price; 
END 



------------------------v1
select * from
{
dla każdej osoby:
    znajdź wszystkie osoby, które w polu mother_id lub father_ir mają twoje id
    dla każdej z tych znalezioncyb osób:
        dodaj do głównej listy żonę, męża, matkę, ojca if not in list
    
    dodaj do tej listy swoją żonę lub męża  if not in list


    zarobki = lista.map(p => SuMsalary(p.id))

    sum(zarobki)
}
ORDER by sumSalaries ASC
Limit 1

------------------------v2
-- select * from
-- {
-- dla każdej osoby:


--     znajdź wszystkie osoby, które w polu mother_id lub father_ir mają twoje id
--     dla każdej z tych znalezioncyb osób:
--         dodaj do głównej listy żonę, męża, matkę, ojca if not in list
    
--     dodaj do tej listy swoją żonę lub męża  if not in list


    -- zarobki = lista.map(p => SuMsalary(p.id))

    -- sum(zarobki)
}
-- ORDER by sumSalaries ASC
-- Limit 1


-- ============================================


CREATE VIEW person_with_pointers AS
SELECT
p.person_id,
p.first_name,
p.last_name
FROM people p
LEFT JOIN people m
ON p.mother_id = m.person_id
LEFT JOIN people f
ON p.father_id = f.person_id
LEFT JOIN people w
ON p.wife_id = w.person_id
LEFT JOIN people h
ON p.husband_id = h.person_id;
SELECT * FROM person_with_pointers;


CREATE VIEW person_with_merriage_pointers AS
SELECT
p.person_id,
p.first_name,
p.last_name
FROM people p
LEFT JOIN people w
ON p.wife_id = w.person_id
LEFT JOIN people h
ON p.husband_id = h.person_id;
SELECT * FROM person_with_merriage_pointers;


DROP VIEW person_with_parent_pointers;
CREATE VIEW person_with_parent_pointers AS
SELECT
p.person_id,
p.first_name,
p.last_name
FROM people p
LEFT JOIN people m
ON p.mother_id = m.person_id
LEFT JOIN people f
ON p.father_id = f.person_id;
SELECT * FROM person_with_parent_pointers;


-- ===================================================


CREATE FUNCTION FIND_PERSON_FAMILY_MEMBERS_LIST (pid int)
RETURNS TABLE (
    person_id int,
    first_name varchar(255),
    last_name varchar(255)
)
LANGUAGE SQL
READS SQL DATA
BEGIN
    RETURN
    (

        -- self

        SELECT
        p.person_id,
        p.first_name,
        p.last_name
        FROM people p
        WHERE p.person_id = pid

        -- wife/husband + children
        UNION

        SELECT
        pwp.person_id,
        pwp.first_name,
        pwp.last_name
        FROM person_with_pointers pwp
        WHERE pwp.m.person_id = pid
        OR pwp.f.person_id = pid
        OR pwp.w.person_id = pid
        OR pwp.h.person_id = pid

        -- UNION

        --- here parents of our childrens
        --- here merriage of our childrens
        --- here parents merriage of our childrens

    );
END;


CREATE VIEW family_member_list AS
SELECT
FIND_PERSON_FAMILY_MEMBERS_LIST *
FROM people;


CREATE VIEW family_member AS
fml.person_id,
fml.first_name,
fml.last_name,
fml.SUM_MEMBER_SALARY(person_id) AS member_income
FROM family_member_list fml;


CREATE VIEW person_family_income AS
SELECT fm.person_id,
       fm.first_name,
       fm.last_name,
       SUM(fm.member_income) AS family_income
FROM family_member fm
GROUP BY fm.person_id, fm.idx_first_name, fm.last_name;


CREATE VIEW poorest_family AS
SELECT * FROM person_family_income pfi
ORDER BY pfi.family_income ASC
Limit 1;



==============================================










CREATE FUNCTION person_family_income (Vendor CHAR(20), Pid INT)         
    RETURNS  DECIMAL(10,3) 
    LANGUAGE SQL  
    MODIFIES SQL
    BEGIN 
    DECLARE price DECIMAL(10,3); 

    IF Vendor = 'Vendor 1' 
        THEN SET price = (SELECT ProdPrice FROM V1Table WHERE Id = Pid); 
    ELSE IF Vendor = 'Vendor 2' 
        THEN SET price = (SELECT Price 
                        FROM V2Table 
                        WHERE Pid = GetPrice.Pid); 
    END IF; 

    RETURN price; 
END 





























WITH family_salaries AS (
    SELECT
        p.person_id,
        p.first_name,
        p.last_name,
        SUM(e.salary) AS salary,
        SUM(e1.salary) AS mother_salary,
        SUM(e2.salary) AS father_salary,
        SUM(e3.salary) AS wife_salary,
        SUM(e4.salary) AS husband_salary
    FROM
        people p
    LEFT JOIN
        employment e ON p.person_id = e.worker_id
    LEFT JOIN
        people m ON p.mother_id = m.person_id
    LEFT JOIN
        employment e1 ON m.person_id = e1.worker_id
    LEFT JOIN
        people f ON p.father_id = f.person_id
    LEFT JOIN
        employment e2 ON f.person_id = e2.worker_id
    LEFT JOIN
        people w ON p.wife_id = w.person_id
    LEFT JOIN
        employment e3 ON w.person_id = e3.worker_id
    LEFT JOIN
        people h ON p.husband_id = h.person_id
    LEFT JOIN
        employment e4 ON h.person_id = e4.worker_id
)
SELECT
    person_id,
    first_name,
    last_name,
    (salary + mother_salary + father_salary + wife_salary + husband_salary) AS total_family_salary
FROM
    family_salaries
ORDER BY
    total_family_salary
LIMIT 1;











WITH family_salaries AS (
    SELECT
        p.person_id,
        p.first_name,
        p.last_name,
        SUM(e.salary) AS salary,
        SUM(e1.salary) AS mother_salary,
        SUM(e2.salary) AS father_salary,
        SUM(e3.salary) AS wife_salary,
        SUM(e4.salary) AS husband_salary
    FROM
        people p
    LEFT JOIN
        employment e ON p.person_id = e.worker_id
    LEFT JOIN
        people m ON p.mother_id = m.person_id
    LEFT JOIN
        employment e1 ON m.person_id = e1.worker_id
    LEFT JOIN
        people f ON p.father_id = f.person_id
    LEFT JOIN
        employment e2 ON f.person_id = e2.worker_id
    LEFT JOIN
        people w ON p.wife_id = w.person_id
    LEFT JOIN
        employment e3 ON w.person_id = e3.worker_id
    LEFT JOIN
        people h ON p.husband_id = h.person_id
    LEFT JOIN
        employment e4 ON h.person_id = e4.worker_id
)
SELECT
    person_id,
    first_name,
    last_name,
    (salary + mother_salary + father_salary + wife_salary + husband_salary) AS total_family_salary
FROM
    family_salaries
ORDER BY
    total_family_salary
LIMIT 1;
