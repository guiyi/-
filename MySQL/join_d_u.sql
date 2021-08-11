#同时删除购物车
DELETE c ,
 dc
FROM
	cart AS c
INNER JOIN df_cart AS dc ON c.cart_id = dc.cart_id
WHERE
	(
		c.api_id > '0'
		OR c.customer_id = '0'
	)
AND c.date_added < DATE_SUB(NOW() , INTERVAL 1 HOUR)


#同时更新购物车
UPDATE cart
INNER JOIN df_cart ON cart.cart_id = df_cart.cart_id
SET cart.session_id = '111' ,
 df_cart.session_id = '111'
WHERE
	cart.api_id = '0'
AND cart.customer_id = '69734'
