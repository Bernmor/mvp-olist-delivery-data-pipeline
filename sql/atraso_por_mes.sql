-- O mês é o da compra, independentemente do mês da entrega real.
-- cobertura_pct mede quantos pedidos do mês já têm resultado de pontualidade.
-- Um denominador elegível igual a zero gera taxa nula, não uma taxa de 0%.
SELECT
  COALESCE(d.ano_mes, 'Sem data') AS ano_mes,
  COUNT(*) AS pedidos_total,
  SUM(CASE WHEN f.pedido_entregue_com_datas = 1 THEN 1 ELSE 0 END) AS pedidos_elegiveis,
  SUM(CASE WHEN f.entrega_atrasada = 1 THEN 1 ELSE 0 END) AS pedidos_atrasados,
  ROUND(100.0 * SUM(CASE WHEN f.pedido_entregue_com_datas = 1 THEN 1 ELSE 0 END)
    / COUNT(*), 2) AS cobertura_pct,
  ROUND(100.0 * SUM(CASE WHEN f.entrega_atrasada = 1 THEN 1 ELSE 0 END)
    / NULLIF(SUM(CASE WHEN f.pedido_entregue_com_datas = 1 THEN 1 ELSE 0 END), 0), 2) AS taxa_atraso_pct
FROM {fato} f
LEFT JOIN {datas} d ON f.data_compra = d.data_compra
GROUP BY COALESCE(d.ano_mes, 'Sem data')
ORDER BY ano_mes
