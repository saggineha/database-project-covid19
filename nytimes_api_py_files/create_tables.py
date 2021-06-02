# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.

import mysql.connector
from sql_queries import create_table_queries, drop_table_queries


def create_database():
    conn = mysql.connector.connect(user ='root', password= 'YOUR_PASSWORD', host = '127.0.0.1',port='3306', database='mysql')
    conn.autocommit = True
    cur = conn.cursor()
    cur.execute("DROP DATABASE IF EXISTS covid_social_db")
    cur.execute("CREATE DATABASE covid_social_db CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci")

    conn.close()
    conn = mysql.connector.connect(user ='root', password= 'YOUR_PASSWORD', host = '127.0.0.1',port='3306', database='covid_social_db')
    cur = conn.cursor()

    return cur, conn

def create_tables(cur, conn):
    for query in create_table_queries:
        cur.execute(query)
        conn.commit()
def drop_tables(cur, conn):
    for query in drop_table_queries:
        cur.execute(query)
        conn.commit()
def main():
    cur, conn = create_database()
    drop_tables(cur, conn)
    create_tables(cur, conn)
    conn.close()

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
