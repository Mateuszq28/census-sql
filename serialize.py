'''
person_id,
pesel,
first_name,
last_name,
birth_date,
sex,
mother_id,
father_id,
wife_id,
husband_id,
country,
earnings

["person_id",
"pesel",
"first_name",
"last_name",
"birth_date",
"sex",
"mother_id",
"father_id",
"wife_id",
"husband_id",
"country",
"earnings"]

[os.system("touch "+e+".txt") for e in k]

INSERT INTO people
( person_id, pesel, first_name, last_name, birth_date
  sex, mother_id, father_id, wife_id, husband_id,
  country, earnings )
VALUES
  (1, 98072800000, 'Mateusz', 'Miler-Niezgoda',
  '1998-07-28', 'm', 5, 6, 2, NULL, 'POLAND', 0.12),
  (2, 98012200000, 'Milena', 'Miler-Niezgoda',
  '1998-01-22', 'k', 3, 4, NULL, 1, 'POLAND', 5384.1),
  (3, 66110800000, 'Anna', 'Niezgoda',
  '1966-11-08', 'k', J, NULL, NULL, 4, 'POLAND', 4300.0),
  (4, 64040800000, 'Sławomir', 'Niezgoda',
  '1964-04-08', 'm', NULL, NULL, 3, NULL, 'POLAND', 4300.0)...
  J - uzupełnić
'''

tables = ["people", "employment", "work_company"]

people_columns = ["person_id", "pesel", "first_name", "last_name", "birth_date", "sex", "mother_id", "father_id", "wife_id", "husband_id", "country", "earnings"]

employment_columns = ["job_id", "worker_id", "work_company_id", "contract_type"]

work_company_columns = ["work_company_id", "company_name", "chairman_id"]


# Generate ids
def write_range(start, stop, filename):
    with open(filename, 'w') as f:
        text = [str(e) for e in list(range(start, stop+1))]
        text = "\n".join(text)
        # print(text)
        f.write(text)

ids = [people_columns[0], employment_columns[0], work_company_columns[0]]
dir_id = [d + "/" + i + ".txt" for d, i in zip(tables, ids)]
print(dir_id)
[write_range(1,300,t) for t in dir_id]


# concatenate all

INSERT INTO people
( person_id, pesel, first_name, last_name, birth_date
  sex, mother_id, father_id, wife_id, husband_id,
  country, earnings )
VALUES
  (1, 98072800000, 'Mateusz', 'Miler-Niezgoda',
  '1998-07-28', 'm', 5, 6, 2, NULL, 'POLAND', 0.12),


