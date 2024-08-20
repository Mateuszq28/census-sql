import random

# Define the input and output file names
input_file = 'add_employment.sql'
output_file = 'output_file.sql'

# Set the range for random salary values
min_salary = 4300.0
max_salary = 25000.0

# Open the input file and read its contents
with open(input_file, 'r') as file:
    lines = file.readlines()

# Open the output file for writing
with open(output_file, 'w') as file:
    for line in lines:
        if "INSERT INTO employment" in line:
            # Add the salary column to the INSERT INTO statement
            line = line.replace("contract_type", "contract_type, salary")
            file.write(line)
        elif "VALUES" in line:
            # Write the VALUES line unchanged
            file.write(line)
        elif ");" in line:
            # Generate a random salary
            salary = round(random.uniform(min_salary, max_salary), 2)
            # Insert the random salary before the closing parenthesis
            line = line.replace(");", f", {salary});")
            file.write(line)
        elif ")," in line:
            # Generate a random salary
            salary = round(random.uniform(min_salary, max_salary), 2)
            # Insert the random salary before the closing parenthesis
            line = line.replace("),", f", {salary}),")
            file.write(line)
        else:
            # Write any other lines unchanged
            file.write(line)

print(f"Modified SQL query saved to {output_file}")
