nyapi_table_drop = "DROP TABLE IF EXISTS nyapi"
nyapi_table_create = ("""
    CREATE TABLE IF NOT EXISTS nyapi
    (nyapi_id int NOT NULL,
    ny_date DATETIME NOT NULL,
    abstract text,
    keywords text,
    doc_type text,
    material_type text,
    news_desk text,
    PRIMARY KEY(nyapi_id, ny_date)
    );
""")
nyapi_table_insert = ('''
    INSERT INTO nyapi (nyapi_id,ny_date,abstract,keywords,doc_type,material_type,news_desk)
    VALUES (%s,%s, %s, %s,%s,%s,%s)
''')
create_table_queries = [nyapi_table_create]
drop_table_queries = [nyapi_table_drop]