-- Todos os pedidos são contados; somente entregues com as duas datas entram na taxa.
-- LEFT JOIN preserva pedidos sem localidade no grupo Sem UF.
-- NULLIF deixa a taxa indefinida quando não houver pedido elegível no grupo.
SELECT
  COALESCE(l.estado, 'Sem UF') AS estado,
  COUNT(*) AS pedidos_total,
  SUM(CASE WHEN f.pedido_entregue_com_datas = 1 THEN 1 ELSE 0 END) AS pedidos_elegiveis,
  SUM(CASE WHEN f.entrega_atrasada = 1 THEN 1 ELSE 0 END) AS pedidos_atrasados,
  ROUND(100.0 * SUM(CASE WHEN f.entrega_atrasada = 1 THEN 1 ELSE 0 END)
    / NULLIF(SUM(CASE WHEN f.pedido_entregue_com_datas = 1 THEN 1 ELSE 0 END), 0), 2) AS taxa_atraso_pct
FROM {fato} f
LEFT JOIN {localidade} l ON f.chave_localidade = l.chave_localidade
GROUP BY COALESCE(l.estado, 'Sem UF')
ORDER BY taxa_atraso_pct DESC, pedidos_elegiveis DESC, estado
