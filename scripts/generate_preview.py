"""Gera prévia SVG a partir das consultas SQL reais do banco de exemplo."""
import sys
from pathlib import Path
from preview_utils import preview
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from demo import database

def main():
    con=database()
    try:
        queries=[q for q in (ROOT/'sql/03_queries.sql').read_text().split(';') if q.strip()]
        volume=con.execute(queries[0]).fetchall()
        pending=con.execute(queries[1]).fetchall()
        trips=con.execute(queries[2]).fetchall()
        fmt=lambda n:format(n,',').replace(',','.')
        preview('Análise logística SQL','SQLite · modelo relacional · JOIN / LEFT JOIN · restrições e triggers',
                [('Volume solicitado',f"{fmt(sum(r[1] for r in volume))} kg"),('Pedidos pendentes',len(pending)),('Ocupação da viagem 1',f"{trips[0][4]}%".replace('.',','))],
                [('Volume por data',[(d,f'{fmt(kg)} kg') for d,kg in volume]),
                 ('Ocupação por viagem',[(f'Viagem {r[0]} · {r[1]}',f'{fmt(r[3])} / {fmt(r[2])} kg') for r in trips])],ROOT/'docs/assets/preview.svg')
    finally:con.close()
if __name__=='__main__':main()
