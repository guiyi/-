#报表数据包括：
#客户名，客户邮箱，customer group（default or distributor），国家，下单时间（Payment Received的时间），所购产品SKU/品名/数量，订单金额（Sub-Total的值），货运方式，最新order status，
#回头客（return customer or new customer，衡量回头客的标准为是否有历史订单，最好用邮箱或者uid匹配），
#下单频次（该客户在后台的总shipped订单数），
#沉睡时长（本次订单与上一笔订单之间相隔的月份数/天数）。以上数据变更概率低。
#运营要求：后台有入口，可以筛选时间和客户类别，输出excel。或者定期（<1个月）输出报表提交外贸。

#SELECT * from `order`  GROUP BY  customer_id

#SELECT min(order_id) from `order` where date_added>='2018-02-01' and date_added<='2018-03-01'
select * from 
(
SELECT
	o.order_id,
	o.firstname,
	o.email,
	o.customer_group_id,
	o.shipping_country,
	o.date_added,
	ot.model,
	ot.`name`,
	ot.quantity,
	ot.total,
  o.shipping_method,
	o.order_status_id
FROM
	`order` AS o
LEFT JOIN order_product AS ot ON o.order_id = ot.order_id
WHERE o.date_added>='2018-01-01' and o.date_added<='2018-02-01'
and ot.order_id>=105006 and ot.total>0
) as a
JOIN

(
SELECT
o1.email,
	if(o1.email=o2.email,'customer','new customer') as customer
FROM
	(
		(
			SELECT DISTINCT
				(email)
			FROM
				`order`
			WHERE
				date_added >= '2018-01-01'
			AND date_added <= '2018-02-01'
and order_id>=105006
		) as o1
		LEFT JOIN (
			SELECT DISTINCT
				(email)
			FROM
				`order`
			WHERE
				date_added < '2018-01-01'

		) as o2
ON o1.email=o2.email
	)
) as b
ON a.email=b.email
JOIN(
SELECT
	email,
	count(DISTINCT order_id) AS orders
FROM
	`order`
WHERE
	email IN (
		SELECT DISTINCT
			(email)
		FROM
			`order`
		WHERE
			date_added >= '2018-01-01'
		AND date_added <= '2018-01-02'
	)  
GROUP BY
	email
) as  c
ON a.email=c.email
