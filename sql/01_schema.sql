PRAGMA foreign_keys = ON;
CREATE TABLE produtor (id INTEGER PRIMARY KEY, nome TEXT NOT NULL UNIQUE);
CREATE TABLE produto (id INTEGER PRIMARY KEY, nome TEXT NOT NULL UNIQUE);
CREATE TABLE veiculo (id INTEGER PRIMARY KEY, nome TEXT NOT NULL UNIQUE, capacidade_kg INTEGER NOT NULL CHECK(capacidade_kg>0));
CREATE TABLE pedido (id INTEGER PRIMARY KEY, produtor_id INTEGER NOT NULL REFERENCES produtor(id), produto_id INTEGER NOT NULL REFERENCES produto(id), data TEXT NOT NULL, kg INTEGER NOT NULL CHECK(kg>0), status TEXT NOT NULL CHECK(status IN ('pendente','entregue','cancelado')));
CREATE TABLE viagem (id INTEGER PRIMARY KEY, veiculo_id INTEGER NOT NULL REFERENCES veiculo(id), data TEXT NOT NULL);
CREATE TABLE entrega (id INTEGER PRIMARY KEY, viagem_id INTEGER NOT NULL REFERENCES viagem(id), pedido_id INTEGER NOT NULL UNIQUE REFERENCES pedido(id));
CREATE INDEX idx_pedido_data_status ON pedido(data,status);
CREATE INDEX idx_entrega_viagem ON entrega(viagem_id);
CREATE TRIGGER valida_entrega BEFORE INSERT ON entrega BEGIN
 SELECT CASE WHEN (SELECT status FROM pedido WHERE id=NEW.pedido_id)='cancelado' THEN RAISE(ABORT,'pedido cancelado') END;
 SELECT CASE WHEN (SELECT data FROM pedido WHERE id=NEW.pedido_id)!=(SELECT data FROM viagem WHERE id=NEW.viagem_id) THEN RAISE(ABORT,'datas divergentes') END;
 SELECT CASE WHEN (SELECT COALESCE(SUM(p.kg),0) FROM entrega e JOIN pedido p ON p.id=e.pedido_id WHERE e.viagem_id=NEW.viagem_id)+(SELECT kg FROM pedido WHERE id=NEW.pedido_id)>(SELECT v.capacidade_kg FROM viagem t JOIN veiculo v ON v.id=t.veiculo_id WHERE t.id=NEW.viagem_id) THEN RAISE(ABORT,'capacidade excedida') END;
END;
