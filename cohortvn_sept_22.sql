select * from vn_raw

SELECT first_buying_month, COUNT (DISTINCT Customer_ID) 
FROM vn_raw
WHERE month_no = 0
GROUP BY first_buying_month