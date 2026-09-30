"""Executa carga e consultas em SQLite em memória."""
from pathlib import Path
import sqlite3
BASE=Path(__file__).resolve().parent

def database():
    con=sqlite3.connect(':memory:')
    for name in ('01_schema.sql','02_seed.sql'):
        con.executescript((BASE/'sql'/name).read_text(encoding='utf-8'))
    return con

def main():
    with database() as con:
        for sql in (BASE/'sql/03_queries.sql').read_text(encoding='utf-8').split(';'):
            if not sql.strip():continue
            cursor=con.execute(sql)
            print(sql.split('SELECT')[0].strip())
            print(' | '.join(c[0] for c in cursor.description))
            for row in cursor:print(' | '.join(map(str,row)))
            print()
if __name__=='__main__':main()
