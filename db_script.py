import sqlite3

with open("add_people.sql", 'r', encoding="utf-8") as f:
    querry = f.read()

try:
    conn = sqlite3.connect("census.db")
    cursor = conn.cursor()
    cursor.execute(querry)
except sqlite3.OperationalError as e:
    # print(f"Error message: {e}")
    # print(f"Error message: {sqlite3_errmsg(conn)}")
    print(f"Error message: {sqlite3_extended_errcode((conn))}")
finally:
    conn.close()
