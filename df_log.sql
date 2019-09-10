select count(1) '登录人数',sum(click) '点击总次数' ,sum(click)/count(1)  '访问深度' ,a.customer_group_id from 
(
SELECT DISTINCT
	dl.customer_id ,
	c.email,
	c.customer_group_id,
			count(1) AS click
FROM
	df_log dl
LEFT join customer c on dl.customer_id=c.customer_id
WHERE dl.date_added>='2019-09-05'
GROUP BY
	dl.customer_id,
	c.email,
	c.customer_group_id
		ORDER BY
	click DESC
)a 
group by a.customer_group_id


SELECT count(1) '登录人数' , sum(click) '点击总次数' , sum(click) / count(1) '访问深度' , a.customer_group_id FROM( SELECT DISTINCT dl.customer_id , c.email , c.customer_group_id , count(1) AS click FROM df_log dl LEFT JOIN customer c ON dl.customer_id = c.customer_id WHERE dl.date_added >= '2019-09-08' and dl.ip   not in ('49.51.40.62','180.168.36.202','210.22.153.182')  GROUP BY dl.customer_id , c.email , c.customer_group_id ORDER BY click DESC) a GROUP BY a.customer_group_id;

#网站流量转化与漏斗模型

浏览产品页 
SELECT count(1) '登录人数' , sum(click) '点击总次数' , sum(click) / count(1) '访问深度' , a.customer_group_id FROM( SELECT DISTINCT dl.customer_id , c.email , c.customer_group_id , count(1) AS click FROM df_log dl LEFT JOIN customer c ON dl.customer_id = c.customer_id WHERE dl.date_added >= DATE_SUB(curdate(),INTERVAL 1 DAY) and dl.ip not in ('49.51.40.62','180.168.36.202','210.22.153.182') and http_referer like '%product-%' GROUP BY dl.customer_id , c.email , c.customer_group_id ORDER BY click DESC) a GROUP BY a.customer_group_id


购物车
SELECT count(1) '登录人数' , sum(click) '点击总次数' , sum(click) / count(1) '访问深度' , a.customer_group_id FROM( SELECT DISTINCT dl.customer_id , c.email , c.customer_group_id , count(1) AS click FROM df_log dl LEFT JOIN customer c ON dl.customer_id = c.customer_id WHERE dl.date_added >= DATE_SUB(curdate(),INTERVAL 1 DAY) and dl.ip not in ('49.51.40.62','180.168.36.202','210.22.153.182') and http_referer like '%checkout/cart%' GROUP BY dl.customer_id , c.email , c.customer_group_id ORDER BY click DESC) a GROUP BY a.customer_group_id


生成订单

SELECT count(1) '登录人数' , sum(click) '点击总次数' , sum(click) / count(1) '访问深度' , a.customer_group_id FROM( SELECT DISTINCT dl.customer_id , c.email , c.customer_group_id , count(1) AS click FROM df_log dl LEFT JOIN customer c ON dl.customer_id = c.customer_id WHERE dl.date_added >= DATE_SUB(curdate(),INTERVAL 1 DAY) and dl.ip not in ('49.51.40.62','180.168.36.202','210.22.153.182') and http_request like '%checkout/checkout%' GROUP BY dl.customer_id , c.email , c.customer_group_id ORDER BY click DESC) a GROUP BY a.customer_group_id


支付订单
SELECT count(1) '登录人数' , sum(click) '点击总次数' , sum(click) / count(1) '访问深度' , a.customer_group_id FROM( SELECT DISTINCT dl.customer_id , c.email , c.customer_group_id , count(1) AS click FROM df_log dl LEFT JOIN customer c ON dl.customer_id = c.customer_id WHERE dl.date_added >= DATE_SUB(curdate(),INTERVAL 1 DAY) and dl.ip not in ('49.51.40.62','180.168.36.202','210.22.153.182') and http_request like '%checkout/confirm%' GROUP BY dl.customer_id , c.email , c.customer_group_id ORDER BY click DESC) a GROUP BY a.customer_group_id


完成支付
SELECT count(1) '登录人数' , sum(click) '点击总次数' , sum(click) / count(1) '访问深度' , a.customer_group_id FROM( SELECT DISTINCT dl.customer_id , c.email , c.customer_group_id , count(1) AS click FROM df_log dl LEFT JOIN customer c ON dl.customer_id = c.customer_id WHERE dl.date_added >= DATE_SUB(curdate(),INTERVAL 1 DAY) and dl.ip not in ('49.51.40.62','180.168.36.202','210.22.153.182') and http_request like '%checkout/success%' GROUP BY dl.customer_id , c.email , c.customer_group_id ORDER BY click DESC) a GROUP BY a.customer_group_id


#每日ip排行前十
select ip ,DATE_SUB(curdate(),INTERVAL 1 DAY) today,count(1) counts from df_log where date_added>=DATE_SUB(curdate(),INTERVAL 1 DAY) group by ip,today  order by counts desc limit 10

select ip ,count(1) counts from df_log where date_added>='2019-09-08' group by ip  order by counts desc limit 10


#具体IP 访问的URL
SELECT customer_id,ip,http_request,http_referer,count(1) counts  from df_log where ip in
(
select ip from 
(
select ip ,count(1) counts from df_log where date_added>=DATE_SUB(curdate(),INTERVAL 1 DAY)  and ip not in ('49.51.40.62','180.168.36.202','210.22.153.182') group by ip order by counts desc limit 10
 ) a
) and date_added>=DATE_SUB(curdate(),INTERVAL 1 DAY) 

GROUP by customer_id,ip,http_request,http_referer
order by counts desc
limit 10


#搜索 top 10

SELECT DISTINCT
	REPLACE(http_referer , '%20' , ' ') ,
	REPLACE(
		SUBSTRING_INDEX(
			SUBSTRING(http_referer , 32 , 50) ,
			'.' ,
			1
		) ,
		'%20' ,
		' '
	) AS search ,
	count(1) AS click
FROM
	df_log
WHERE
	http_referer LIKE '%search-%'
AND date_added >=DATE_SUB(curdate(),INTERVAL 1 DAY) 
GROUP BY
	http_referer ,
	search
ORDER BY
	click DESC
LIMIT 10

#分类 category  top 20

SELECT
REPLACE(cd. NAME , 'amp;' , ' ') ,
	a.*
FROM
	(
		SELECT DISTINCT
			http_referer ,
			SUBSTRING_INDEX(
				SUBSTRING(http_referer , 34 , 3) ,
				'.' ,
				1
			) AS category_id ,
			count(1) AS click
		FROM
			df_log
		WHERE
			http_referer LIKE '%category-%'
		AND date_added >= DATE_SUB(curdate(),INTERVAL 1 DAY) 
		GROUP BY
			http_referer
		ORDER BY
			click DESC
		LIMIT 20
	) a
LEFT JOIN category_description cd ON a.category_id = cd.category_id


# 产品
SELECT
	pd. NAME ,
	p.model ,
	a.*
FROM
	(
		SELECT DISTINCT
			http_referer ,
			SUBSTRING_INDEX(
				SUBSTRING(http_referer , 33 , 4) ,
				'.' ,
				1
			) AS product_id ,
			count(1) AS click
		FROM
			df_log
		WHERE
			http_referer LIKE '%product-%'
		AND date_added >= DATE_SUB(curdate(),INTERVAL 1 DAY) 
		GROUP BY
			http_referer
		ORDER BY
			click DESC
		LIMIT 20
	) a
LEFT JOIN product_description pd ON a.product_id = pd.product_id
LEFT JOIN product p ON p.product_id = a.product_id

#BLOG top 10

SELECT
	bad.title ,
	a.*
FROM
	(
		SELECT DISTINCT
			REPLACE(http_referer , '%20' , ' ') ,
			REPLACE(
				SUBSTRING_INDEX(
					SUBSTRING(http_referer , 30 , 50) ,
					'.' ,
					1
				) ,
				'%20' ,
				' '
			) AS article_id ,
			count(1) AS click
		FROM
			df_log
		WHERE
			http_referer LIKE '%blog-%'
		AND date_added >= DATE_SUB(curdate(),INTERVAL 1 DAY) 
		GROUP BY
			http_referer ,
			article_id
		ORDER BY
			click DESC
		LIMIT 10
	) a
LEFT JOIN blog_article_description bad ON a.article_id = bad.article_id
