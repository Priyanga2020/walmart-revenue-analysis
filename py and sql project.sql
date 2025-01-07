select * from walmart limit 10

select count(*) from walmart

select payment_method, count(*) as payment_count from walmart group by payment_method

SELECT COUNT(DISTINCT "Branch") 
FROM walmart;

SELECT MIN(quantity) FROM walmart;

-- Business Problems
--Q.1 Find different payment method and number of transactions, number of qty sold

select payment_method,
count(*) as no_of_payment,
sum(quantity) as no_of_qty_sold
from walmart 
group by payment_method


-- Project Question #2
-- Identify the highest-rated category in each branch, displaying the branch, category
-- AVG RATING

select "Branch", category, avg(rating) as Avg_rating,
Rank() over(partition by "Branch" order by avg(rating) desc) as rank
from walmart
group by "Branch", category

-- NOW WE WANNA SHOW ONLY THE HIGHEST RANK FROM CATEGORY

SELECT "Branch",
       category,
       avg_rating
FROM (
    SELECT "Branch",
           category,
           AVG(rating) AS avg_rating,
           RANK() OVER (PARTITION BY "Branch" ORDER BY AVG(rating) DESC) AS rank
    FROM walmart
    GROUP BY "Branch", category
) AS ranked_categories
WHERE rank = 1;


-- Q.3 Identify the busiest day for each branch based on the number of transactions

SELECT *
FROM (
    SELECT 
        "Branch",
        TO_CHAR(TO_DATE("date", 'DD/MM/YY'), 'FMDay') AS day_name,
        COUNT(*) AS no_of_transaction,
        RANK() OVER (PARTITION BY "Branch" ORDER BY COUNT(*) DESC) AS rank
    FROM walmart
    GROUP BY "Branch", TO_CHAR(TO_DATE("date", 'DD/MM/YY'), 'FMDay')
) AS ranked_transactions
WHERE rank = 1;

-- Q. 4 
-- Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.

select payment_method, sum(quantity) as total_qty
from walmart 
group by payment_method


-- Q.5
-- Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_ratin

select
category, "City",
avg(rating),min(rating),max(rating)
from walmart
group by category, "City"


-- Q.6
-- Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.



select
category,
sum("Total") as Total_revenue,
sum("Total" * profit_margin) as Total_profit
from walmart
group by category
ORDER BY total_profit DESC;


-- Q.7
-- Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

WITH cte AS (
    SELECT 
        "Branch",
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER (PARTITION BY "Branch" ORDER BY COUNT(*) DESC) AS rank
    FROM walmart
    GROUP BY "Branch", payment_method
)
SELECT *
FROM cte
WHERE rank = 1;


-- Q.8
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

"SELECT 
    TO_TIMESTAMP(time, 'HH24:MI:SS')::time AS converted_time
FROM walmart;"

SELECT 
    CASE 
        WHEN TO_TIMESTAMP(time, 'HH24:MI:SS')::time BETWEEN '06:00:00' AND '11:59:59' THEN 'MORNING'
        WHEN TO_TIMESTAMP(time, 'HH24:MI:SS')::time BETWEEN '12:00:00' AND '17:59:59' THEN 'AFTERNOON'
        WHEN TO_TIMESTAMP(time, 'HH24:MI:SS')::time BETWEEN '18:00:00' AND '23:59:59' THEN 'EVENING'
        ELSE 'NIGHT'
    END AS shift,
    COUNT(*) AS number_of_invoices
FROM walmart
GROUP BY shift
ORDER BY number_of_invoices DESC;

-- #9 Identify 5 branch with highest decrese ratio in 
-- revevenue compare to last year(current year 2023 and last year 2022)

-- rdr == last_rev-cr_rev/ls_rev*100

-- Extract Year from the Date
SELECT *,
EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) AS formated_date
FROM walmart;

-- Calculate Revenue for 2022
WITH revenue_2022 AS (
    SELECT 
        "Branch",
        SUM("Total") AS revenue
    FROM walmart
    WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022
    GROUP BY "Branch"
),

-- Calculate Revenue for 2023
revenue_2023 AS (
    SELECT 
        "Branch",
        SUM("Total") AS revenue
    FROM walmart
    WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
    GROUP BY "Branch"
)

-- Calculate Revenue Decrease Ratio and Identify Top 5 Branches
SELECT 
    ls."Branch",
    ls.revenue AS last_year_revenue,
    cs.revenue AS cr_year_revenue,
    ROUND(
        (ls.revenue - cs.revenue)::numeric /
        ls.revenue::numeric * 100, 
        2
    ) AS rev_dec_ratio
FROM revenue_2022 AS ls
JOIN revenue_2023 AS cs
ON ls."Branch" = cs."Branch"
WHERE 
    ls.revenue > cs.revenue
ORDER BY rev_dec_ratio DESC
LIMIT 5;




