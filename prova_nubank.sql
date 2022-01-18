
--3

SELECT B.name
,C.name
,sum(A.quantity*C.price) revenue 
FROM sales A
INNER JOIN motorcycle_model C
ON A.model_id = C.id
INNER JOIN country B
ON A.country_id = b.id
WHERE EXTRACT (YEAR FROM A.sales_date) = 2018
GROUP BY B.name,C.name
ORDER BY 1,2;

--4

SELECT A.visited_on
, ROUND (avg(A.time_spent) OVER(ORDER BY A.visited_on
     ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ),4)
     as moving_average 
FROM traffic A
INNER JOIN users B
ON A.user_id = b.id
WHERE B.user_type = 'user';