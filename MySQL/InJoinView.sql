# IN 方式
SELECT
	o.order_id,
	o.order_sn,
	o.order_status,
	o.shipping_status,
	o.pay_status,
	o.add_time,
	o.order_status,
  og.goods_number,
  og.goods_name,
	og.goods_id,
 g.goods_thumb  ,
	g.goods_img,
	(
		o.goods_amount + o.shipping_fee + o.insure_fee + o.pay_fee + o.pack_fee + o.card_fee + o.tax - o.discount
	) AS total_fee
FROM
	`dfrobotcomcnv3`.`ecs_order_info` as o
LEFT JOIN `dfrobotcomcnv3`.`ecs_order_goods` AS og ON o.order_id = og.order_id
LEFT JOIN `dfrobotcomcnv3`.`ecs_goods` AS g ON g.goods_id = og.goods_id
WHERE
	o.user_id = '805433'

and o.order_id  in (SELECT
	order_id
FROM
	view_order_info1
WHERE
	user_id = '805433'
AND (
	goods_name LIKE "%2017%"
	OR order_sn LIKE "%2017%"
	OR goods_id LIKE "%2017%"
)
GROUP BY order_id)

#GROUP BY o.order_sn
ORDER BY
	o.add_time DESC




#IN 方式的优化
select * from 
(SELECT
	o.order_id,
	o.order_sn,
	o.order_status,
	o.shipping_status,
	o.pay_status,
	o.add_time,
  og.goods_number,
  og.goods_name,
	og.goods_id,
  g.goods_thumb  ,
	g.goods_img,
	(
		o.goods_amount + o.shipping_fee + o.insure_fee + o.pay_fee + o.pack_fee + o.card_fee + o.tax - o.discount
	) AS total_fee
FROM
	`dfrobotcomcnv3`.`ecs_order_info` as o
LEFT JOIN `dfrobotcomcnv3`.`ecs_order_goods` AS og ON o.order_id = og.order_id
LEFT JOIN `dfrobotcomcnv3`.`ecs_goods` AS g ON g.goods_id = og.goods_id
WHERE
	o.user_id = '805433'
ORDER BY
	o.add_time DESC) a
join 
(SELECT
	order_id
FROM
	view_order_info1
WHERE
	user_id = '805433'
AND (
	goods_name LIKE "%2017%"
	OR order_sn LIKE "%2017%"
	OR goods_id LIKE "%2017%"
)
GROUP BY order_id) b
where a.order_id = b.order_id














#视图
CREATE VIEW ecs_view_order_info AS (
	SELECT
		g.*, i.user_id,i.order_sn,i.order_status,i.shipping_status,i.pay_status,i.add_time,pay_id

	FROM
		ecs_order_info i
	JOIN ecs_order_goods g ON i.order_id = g.order_id 
)



