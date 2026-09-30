import sys,unittest,sqlite3
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from demo import database
class SQLTests(unittest.TestCase):
 def setUp(self):self.db=database()
 def tearDown(self):self.db.close()
 def test_volume(self):self.assertEqual(self.db.execute("SELECT SUM(kg) FROM pedido WHERE status!='cancelado'").fetchone()[0],31000)
 def test_foreign_key(self):
  with self.assertRaises(sqlite3.IntegrityError):self.db.execute("INSERT INTO pedido VALUES(6,999,1,'2026-09-30',100,'pendente')")
 def test_capacity(self):
  with self.assertRaisesRegex(sqlite3.IntegrityError,'capacidade'):self.db.execute('INSERT INTO entrega VALUES(3,1,3)')
 def test_duplicate(self):
  with self.assertRaises(sqlite3.IntegrityError):self.db.execute('INSERT INTO entrega VALUES(3,2,1)')
 def test_date(self):
  with self.assertRaisesRegex(sqlite3.IntegrityError,'datas'):self.db.execute('INSERT INTO entrega VALUES(3,2,4)')
 def test_positive_weight(self):
  with self.assertRaises(sqlite3.IntegrityError):self.db.execute("INSERT INTO pedido VALUES(6,1,1,'2026-09-30',-1,'pendente')")
if __name__=='__main__':unittest.main()
