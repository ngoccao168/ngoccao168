select * from vn_raw
--tao cohort số lượng customer bang pivot
WITH temp AS (
				SELECT		first_buying_month, 
							isnull([0],0) as [0],
							isnull([1],0) as [1],
							isnull([2],0) as [2],
							isnull([3],0) as [3],
							isnull([4],0) as [4],
							isnull([5],0) as [5],
							isnull([6],0) as [6],
							isnull([7],0) as [7],
							isnull([8],0) as [8],
							isnull([9],0) as [9],
							isnull([10],0) as [10],
							isnull([11],0) as [11],
							isnull([12],0) as [12],
							isnull([13],0) as [13],
							isnull([14],0) as [14],
							isnull([15],0) as [15],
							isnull([16],0) as [16],
							isnull([17],0) as [17]
				FROM (	
					SELECT first_buying_month,count (DISTINCT Customer_ID) AS total_customer, month_no
					FROM vn_raw
					GROUP BY first_buying_month, month_no) AS temp
PIVOT (sum (total_customer) for month_no in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17])) as pivot_table)

-- tạo nhanh table cohort_pivot_customer chứa cohort customer
SELECT *
INTO cohort_pivot_customer
FROM temp
-- xem kết quả
select * from cohort_pivot_customer

----------------------------------------------------------------------------------------------------------------------
-- Tính retention của Customer
WITH temp AS (	SELECT	first_buying_month,
						CAST ([0] AS DECIMAL (8,2))/[0] AS [0],
						CAST ([1] AS DECIMAL (8,2))/[0] AS [1],
						CAST ([2] AS DECIMAL (8,2))/[0] AS [2],
						CAST ([3] AS DECIMAL (8,2))/[0] AS [3],
						CAST ([4] AS DECIMAL (8,2))/[0] AS [4],
						CAST ([5] AS DECIMAL (8,2))/[0] AS [5],
						CAST ([6] AS DECIMAL (8,2))/[0] AS [6],
						CAST ([7] AS DECIMAL (8,2))/[0] AS [7],
						CAST ([8] AS DECIMAL (8,2))/[0] AS [8],
						CAST ([9] AS DECIMAL (8,2))/[0] AS [9],
						CAST ([10] AS DECIMAL (8,2))/[0] AS [10],
						CAST ([11] AS DECIMAL (8,2))/[0] AS [11],
						CAST ([12] AS DECIMAL (8,2))/[0] AS [12],
						CAST ([13] AS DECIMAL (8,2))/[0] AS [13],
						CAST ([14] AS DECIMAL (8,2))/[0] AS [14],
						CAST ([15] AS DECIMAL (8,2))/[0] AS [15],
						CAST ([16] AS DECIMAL (8,2))/[0] AS [16],
						CAST ([17] AS DECIMAL (8,2))/[0] AS [17]
				FROM cohort_pivot_customer)
-- Tạo nhanh table customer_retention chứa customer retention
SELECT *
INTO customer_retention
FROM temp;
-- Xem ket qua
SELECT * FROM customer_retention;

----------------------------------------------------------------------------------------------------------------------
--tao cohort revenue bang pivot
WITH temp AS	(SELECT first_buying_month,	isnull([0],0) as [0],
							isnull([1],0) as [1],
							isnull([2],0) as [2],
							isnull([3],0) as [3],
							isnull([4],0) as [4],
							isnull([5],0) as [5],
							isnull([6],0) as [6],
							isnull([7],0) as [7],
							isnull([8],0) as [8],
							isnull([9],0) as [9],
							isnull([10],0) as [10],
							isnull([11],0) as [11],
							isnull([12],0) as [12],
							isnull([13],0) as [13],
							isnull([14],0) as [14],
							isnull([15],0) as [15],
							isnull([16],0) as [16],
							isnull([17],0) as [17]
		FROM (
				select first_buying_month, sum (Total) as revenue, month_no
				from vn_raw
				group by first_buying_month, month_no) as temp
		PIVOT ( sum(revenue) for month_no in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17])) as cohort_pivot_revenue)

-- tạo nhanh table cohort_pivot_revenue chứa cohort revenue
SELECT *
INTO cohort_pivot_revenue
FROM temp

select * from cohort_pivot_revenue

----------------------------------------------------------------------------------------------------------------------
--tao cohort order bang pivot
WITH temp AS	(SELECT first_buying_month,	isnull([0],0) as [0],
							isnull([1],0) as [1],
							isnull([2],0) as [2],
							isnull([3],0) as [3],
							isnull([4],0) as [4],
							isnull([5],0) as [5],
							isnull([6],0) as [6],
							isnull([7],0) as [7],
							isnull([8],0) as [8],
							isnull([9],0) as [9],
							isnull([10],0) as [10],
							isnull([11],0) as [11],
							isnull([12],0) as [12],
							isnull([13],0) as [13],
							isnull([14],0) as [14],
							isnull([15],0) as [15],
							isnull([16],0) as [16],
							isnull([17],0) as [17]
		FROM (
				SELECT first_buying_month, COUNT (DISTINCT Order_name) AS order_count, month_no
				FROM vn_raw
				GROUP BY first_buying_month, month_no) AS temp
		PIVOT ( SUM (order_count) FOR month_no in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17])) as cohort_pivot_order)
-- tạo nhanh table chứa cohort pivot order
SELECT * 
INTO cohort_pivot_order
FROM temp
-- xem kết quả
SELECT * FROM cohort_pivot_order

----------------------------------------------------------------------------------------------------------------------
-- tính AOV
WITH temp AS (	SELECT	r.first_buying_month,
						r.[0]/o.[0] as [0],
						CASE WHEN o.[1] =0 THEN NULL ELSE r.[1]/o.[1] END AS [1],
						CASE WHEN o.[2] = 0 THEN NULL ELSE r.[2]/o.[2] END AS [2],
						CASE WHEN o.[3] =0 THEN NULL ELSE r.[3]/o.[3] END AS [3],
						CASE WHEN o.[4] = 0 THEN NULL ELSE r.[4]/o.[4] END AS [4],
						CASE WHEN o.[5] =0 THEN NULL ELSE r.[5]/o.[5] END AS [5],
						CASE WHEN o.[6] = 0 THEN NULL ELSE r.[6]/o.[6] END AS [6],
						CASE WHEN o.[7] =0 THEN NULL ELSE r.[7]/o.[7] END AS [7],
						CASE WHEN o.[8] = 0 THEN NULL ELSE r.[8]/o.[8] END AS [8],
						CASE WHEN o.[9] =0 THEN NULL ELSE r.[9]/o.[9] END AS [9],
						CASE WHEN o.[10] = 0 THEN NULL ELSE r.[10]/o.[10] END AS [10],
						CASE WHEN o.[11] =0 THEN NULL ELSE r.[11]/o.[11] END AS [11],
						CASE WHEN o.[12] = 0 THEN NULL ELSE r.[12]/o.[12] END AS [12],
						CASE WHEN o.[13] =0 THEN NULL ELSE r.[13]/o.[13] END AS [13],
						CASE WHEN o.[14] = 0 THEN NULL ELSE r.[14]/o.[14] END AS [14],
						CASE WHEN o.[15] =0 THEN NULL ELSE r.[15]/o.[15] END AS [15],
						CASE WHEN o.[16] = 0 THEN NULL ELSE r.[16]/o.[16] END AS [16],
						CASE WHEN o.[17] = 0 THEN NULL ELSE r.[17]/o.[17] END AS [17]
				FROM cohort_pivot_revenue AS r
				LEFT JOIN cohort_pivot_order AS o
				ON r.first_buying_month = o.first_buying_month)
-- tạo nhanh table chứa AOV cohort
SELECT *
INTO cohort_aov
FROM temp
-- xem kết quả
SELECT * FROM cohort_aov