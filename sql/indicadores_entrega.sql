-- A unidade é o pedido. A hora não altera o diagnóstico de pontualidade.
SELECT
  p.*,
  CASE
    WHEN p.order_status = 'delivered'
      AND p.order_delivered_customer_date IS NOT NULL
      AND p.order_estimated_delivery_date IS NOT NULL THEN 1
    ELSE 0
  END AS pedido_entregue_com_datas,
  CASE
    WHEN p.order_status = 'delivered'
      AND p.order_delivered_customer_date IS NOT NULL
      AND p.order_estimated_delivery_date IS NOT NULL
    THEN CASE
      WHEN date(p.order_delivered_customer_date) > date(p.order_estimated_delivery_date) THEN 1
      ELSE 0
    END
    ELSE NULL
  END AS entrega_atrasada
FROM {pedidos} p
