select 
#* 
t2.firstname,t2.lastname,t1.all_reward_points ,t3.*,t2.all_shipping_fee
from 
(
#Reward Points
select customer_id,sum(points) all_reward_points from customer_reward group by customer_id 
)t1
join  
(
#运费
SELECT	
	o.customer_id,
	o.firstname ,
	o.lastname ,
	o.email ,
	#ot.title ,
	sum(ot. VALUE) all_shipping_fee
FROM
	`order` o
LEFT JOIN order_total ot ON o.order_id = ot.order_id
WHERE
	order_status_id IN(3 , 5 , 14 , 16 , 17 , 18)
AND customer_group_id = 8
AND o.shipping_method = ot.title
GROUP BY o.customer_id,
	o.firstname ,
	o.lastname ,
	o.email 
	#,ot.title 
ORDER BY all_shipping_fee desc 
)t2
on t1.customer_id=t2.customer_id and t1.customer_id!=0
JOIN
(
#RFM
select a.customer_id,a.email,diffTime as 'R-最近一次下单离今天的时间',purchases as 'F-下单次数',unit_price as 'M-笔单价' from 
(
SELECT
	customer_id,
	email ,
	min(datediff(CURDATE() , date_added)) AS diffTime
FROM
	(
		SELECT DISTINCT
			customer_id,
			email,
			date_added 
			
		FROM
			`order`
		WHERE
			 order_status_id IN(3 , 5 , 14 , 16 , 17 , 18)



	) aa
GROUP BY aa.customer_id,aa.email
ORDER BY diffTime

)a

JOIN
#F 下单次数
#笔单价 = 累计消费金额 / 下单次数
(
SELECT customer_id,email,purchases, amount/purchases as unit_price FROM
(
SELECT
	customer_id,
	email ,
	count(1) as purchases,
	sum(total) as amount
	
	
FROM
	`order`
WHERE
	 order_status_id IN(3 , 5 , 14 , 16 , 17 , 18)
GROUP BY
customer_id,
	email
ORDER BY purchases desc
)aa
)b on a.email=b.email
)t3

on t1.customer_id=t3.customer_id
order by t1.all_reward_points desc ,t2.all_shipping_fee desc
