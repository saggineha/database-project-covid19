import os
import glob
import pandas as pd
import numpy as np
from sql_queries import *
import mysql.connector

def process_ny_api_file(cur, filepath):
    df = pd.read_csv(filepath)
    df = df.replace({np.nan: None})
    for index, row in df.iterrows():
        cur.execute(nyapi_table_insert, [index] + row.tolist())
    '''
        try:
            cur.execute(nyapi_table_insert, [index]+row.tolist())
        except:
            print('FAILED insert table at:')
            print(index)
            print(row)
    '''

def process_data(cur,conn,filepath,func):
    all_files = []
    for root, dirs, files in os.walk(filepath):
        files = glob.glob(os.path.join(root, '*.csv'))
        for f in files:
            all_files.append(os.path.abspath(f))
    num_files = len(all_files)
    print('{} files found in {}'.format(num_files, filepath))
    for i, datafile in enumerate(all_files, 1):
        func(cur, datafile)
        conn.commit()
        print('{}/{} files processed.'.format(i, num_files))

def main():
    conn = mysql.connector.connect(user='root', password='YOUR_PASSWORD', host='127.0.0.1', port='3306',
                                        database='covid_social_db')
    cur = conn.cursor()
    nyapi_files = process_data(cur,conn,filepath='/Users/mingshuoyu/ny_times',func=process_ny_api_file)
    conn.close()

if __name__ == "__main__":
    main()