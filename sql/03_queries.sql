-- Q1: Qual volume solicitado por data, excluindo cancelamentos?
SELECT data, SUM(kg) AS volume_kg FROM pedido WHERE status!='cancelado' GROUP BY data ORDER BY data;
-- Q2: Quais produtores têm pedidos pendentes?
SELECT pr.nome, p.data, pd.nome AS produto, p.kg FROM pedido p JOIN produtor pr ON pr.id=p.produtor_id JOIN produto pd ON pd.id=p.produto_id WHERE p.status='pendente' ORDER BY p.data,p.id;
-- Q3: Quanto da capacidade de cada viagem está ocupado (inclusive viagens vazias)?
SELECT t.id AS viagem, v.nome, v.capacidade_kg, COALESCE(SUM(p.kg),0) AS carga_kg, ROUND(100.0*COALESCE(SUM(p.kg),0)/v.capacidade_kg,2) AS ocupacao_pct FROM viagem t JOIN veiculo v ON v.id=t.veiculo_id LEFT JOIN entrega e ON e.viagem_id=t.id LEFT JOIN pedido p ON p.id=e.pedido_id GROUP BY t.id,v.nome,v.capacidade_kg ORDER BY t.id;
-- Q4: Qual peso entregue a cada produtor?
SELECT pr.nome, COALESCE(SUM(CASE WHEN p.status='entregue' THEN p.kg ELSE 0 END),0) AS entregue_kg FROM produtor pr LEFT JOIN pedido p ON p.produtor_id=pr.id GROUP BY pr.id,pr.nome ORDER BY pr.id;
