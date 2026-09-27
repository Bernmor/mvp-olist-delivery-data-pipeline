-- O frete já foi agregado por order_id na fato Gold; cada linha aqui é um pedido.
-- NTILE cria grupos de tamanho semelhante entre elegíveis com frete não negativo.
-- order_id desempata fretes iguais de forma determinística; limites podem coincidir.
-- Frete ausente e negativo permanece em grupos próprios, sem descarte silencioso.
WITH elegiveis AS (
  SELECT order_id, entrega_atrasada, frete_total
  FROM {fato}
  WHERE pedido_entregue_com_datas = 1
), quartis AS (
  SELECT
    order_id, entrega_atrasada, frete_total,
    CASE WHEN frete_total >= 0 THEN
      NTILE(4) OVER (
        PARTITION BY CASE WHEN frete_total >= 0 THEN 1 ELSE 0 END
        ORDER BY frete_total, order_id
      )
    END AS quartil
  FROM elegiveis
), faixas AS (
  SELECT
    entrega_atrasada, frete_total,
    CASE
      WHEN frete_total IS NULL THEN 'Frete ausente'
      WHEN frete_total < 0 THEN 'Frete negativo'
      WHEN quartil = 1 THEN 'Q1: menor frete'
      WHEN quartil = 2 THEN 'Q2'
      WHEN quartil = 3 THEN 'Q3'
      ELSE 'Q4: maior frete'
    END AS faixa_frete,
    CASE
      WHEN frete_total IS NULL THEN 5
      WHEN frete_total < 0 THEN 6
      ELSE quartil
    END AS ordem
  FROM quartis
)
SELECT
  faixa_frete,
  COUNT(*) AS pedidos_elegiveis,
  SUM(CASE WHEN entrega_atrasada = 1 THEN 1 ELSE 0 END) AS pedidos_atrasados,
  ROUND(100.0 * SUM(CASE WHEN entrega_atrasada = 1 THEN 1 ELSE 0 END)
    / COUNT(*), 2) AS taxa_atraso_pct,
  MIN(frete_total) AS frete_minimo,
  MAX(frete_total) AS frete_maximo
FROM faixas
GROUP BY faixa_frete, ordem
ORDER BY ordem
