SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y'
#------------------------------
SELECT name 
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;
#------------------------------
SELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000;
#-------------------------------

SELECT DISTINCT author_id AS id
FROM Views 

WHERE author_id = viewer_id
ORDER BY id ASC;

#-------------------------------
SELECT tweet_id
FROM Tweets
WHERE CHAR_LENGTH(content)>15;
#-------------------------------

SELECT name, unique_id
FROM Employees  e
LEFT JOIN EmployeeUNI  UNI
ON  e.id = UNI.id;
#----------------------------
SELECT Product.product_name,Sales.year, Sales.price
FROM Sales
LEFT JOIN Product
ON Sales.product_id = Product.product_id;

#-----------------------------
SELECT v.customer_id, COUNT(v.visit_id) AS count_no_trans
FROM Visits v
LEFT JOIN Transactions t
ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;
#---------------------------
SELECT w1.id
FROM Weather w1
JOIN Weather w2
ON DATE_SUB(w1.recordDate, INTERVAL 1 DAY) = w2.recordDate
WHERE w1.temperature > w2.temperature;
#self join
#---------------------------------
SELECT a.machine_id, ROUND(AVG(b.timestamp - a.timestamp),3) AS processing_time
FROM activity a JOIN activity b 
ON a.machine_id = b.machine_id AND a.process_id = b.process_id
WHERE a.activity_type = 'start' AND b.activity_type = 'end'
GROUP by machine_id;
#---------------------------------
SELECT name, bonus
FROM employee e LEFT JOIN Bonus b ON e.empId = b.empId
WHERE bonus < 1000 OR bonus IS NULL;
#---------------------------------
SELECT 
stu.student_id, stu.student_name, sub.subject_name, COUNT(exam.subject_name) AS attended_exams
FROM STUDENTS AS stu
CROSS JOIN SUBJECTS AS sub
LEFT JOIN EXAMINATIONS AS exam
ON exam.student_id = stu.student_id AND sub.subject_name = exam.subject_name
GROUP BY
stu.student_id, stu.student_name, sub.subject_name
ORDER BY
stu.student_id, sub.subject_name;
#-------------------------------
# Write your MySQL query statement below
SELECT E1.name
FROM Employee E1
JOIN Employee E2
ON E1.id = E2.managerId
GROUP BY E1.name
HAVING  COUNT(E2.managerId) >= 5;
#-------------------------------
# Write your MySQL query statement below
SELECT name FROM Employee WHERE id IN

(SELECT managerId 
FROM Employee GROUP BY managerID
HAVING COUNT(managerId) >= 5)

#-------------------------------
SELECT 
    s.user_id, 
    CASE
        WHEN COUNT(c.action) > 0 THEN 
            SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) / COUNT(c.action)
        ELSE 0
    END AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY s.user_id;
#------------------------------------------
SELECT id, movie, description, rating
FROM Cinema
WHERE id % 2 = 1 AND description != 'boring'
ORDER BY rating DESC;
#-------------------------------------------


SELECT p.product_id, ROUND(sum(units*price)/sum(units),2) AS average_price
FROM Prices p Left JOIN UnitsSold us ON p.product_id = us.product_id
AND purchase_date BETWEEN start_date AND end_date
GROUP BY p.product_id;
#-------------------------connection test
SELECT project_id, ROUND(SUM(experience_years)/COUNT(p.employee_id),2) AS average_years
FROM Project p LEFT JOIN Employee e ON p.employee_id = e.employee_id
GROUP by project_id;
#---------------------------
SELECT contest_id, ROUND(COUNT(user_id)*100/ (SELECT COUNT(user_id) FROM Users), 2) AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id ASC ;
#--------------------------------
SELECT query_name, ROUND(AVG(rating/position),2) AS quality, ROUND(AVG(IF(rating<3,1,0))* 100,2)
  AS poor_query_percentage
FROM Queries
WHERE query_name IS NOT NULL
GROUP BY query_name;
#------------------
SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month, country, COUNT(id) AS trans_count, 
SUM(IF(state = 'approved',1,0)) AS approved_count, SUM(amount) AS trans_total_amount, SUM(IF(state = 'approved', amount, 0)) AS approved_total_amount 
FROM Transactions
GROUP BY month,country;
###########------------------
#second version
SELECT 
    LEFT(trans_date, 7) AS month,
    country, 
    COUNT(id) AS trans_count,
    SUM(state = 'approved') AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM((state = 'approved') * amount) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    month, country;
#----------------------------
#Using CTE
    WITH first_order as 
(
    SELECT customer_id, min(order_date) as min_date
    FROM Delivery
    GROUP BY customer_id
)
SELECT ROUND(SUM(CASE WHEN min_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100/ COUNT(DISTINCT fo.customer_id),2)
AS immediate_percentage
FROM first_order fo LEFT JOIN Delivery d ON fo.customer_id = d.customer_id
AND fo.min_date = d.order_date;
#---------------
#Write your MySQL query statement below
#find the player who played and plyaed the next day
#count the number of them 
#devided by count of whole plyaers

SELECT ROUND (
    (SELECT COUNT(DISTINCT a1.player_id)
    FROM Activity a1 JOIN Activity a2
    ON a1.player_id = a2.player_id  AND DATE_ADD(a1.event_date, INTERVAL 1 DAY) = a2.event_date) / COUNT(DISTINCT player_id)
    ,2) AS fraction
FROM Activity;


# ---------
SELECT DISTINCT teacher_id, COUNT(DISTINCT subject_id) AS cnt
FROM teacher
group by teacher_id;
#-------------

SELECT MAX(num) as num
FROM(
SELECT num, COUNT(num) as countnum 
FROM MyNumbers as MN
GROUP BY num 
HAVING countnum =1) as countednums;
#------------------------------------------------------

# Write your MySQL query statement below
SELECT employee_id, department_id
FROM 
    (SELECT *, COUNT(employee_id) OVER(PARTITION BY employee_id) AS EmployeeCount
    FROM Employee) EmployeePartition
WHERE primary_flag = 'Y' OR EmployeeCount = 1;

#------------------------------------------
# Write your MySQL query statement below
SELECT *,
CASE
WHEN (x + y > z) AND (x + z > y) AND (y + z > x) THEN 'Yes'
ELSE 'No'
END triangle
FROM Triangle;
--------------------------------------------
# 3 self joins
SELECT DISTINCT a.Num as ConsecutiveNums
FROM Logs a
JOIN Logs b ON a.Id = b.Id +1 AND a.Num  = b.Num
JOIN Logs c ON a.Id = c.Id +2 AND a.Num  = c.Num;
#OR
WITH ConsecutiveNo AS (
    SELECT
        Id,
        Num,
        LAG(Num, 1) OVER (ORDER BY Id) AS PrevNum,
        LEAD(Num, 1) OVER (ORDER BY Id) AS NextNum,
        LAG(Num, 2) OVER (ORDER BY Id) AS Prev2Num
    FROM Logs
)
SELECT
    Num AS ConsecutiveNums
FROM ConsecutiveNo
WHERE
    Num = PrevNum AND
    Num = Prev2Num;
    #-------------------------------------------


SELECT DISTINCT Products.product_id, COALESCE (lataset_price.new_price,10) AS Price
# IFNull can be used instead of COALESCE
FROM Products LEFT JOIN 
    (
    #get the lataset price change with product id
    SELECT product_id, new_price 
    FROM Products
    WHERE (product_id, change_date) IN 
        (   SELECT product_id, MAX(change_date) AS change_date
            FROM Products
            WHERE change_date <= '2019-08-16'
            GROUP BY product_id 
        )

    ) AS lataset_price

ON products.product_id = lataset_price.product_id
#-------------------------------------------

SELECT person_name

FROM (
SELECT person_name,turn,  SUM(weight) OVER (ORDER BY turn ) AS TotalWeight
FROM Queue) windowfunc

WHERE TotalWeight <= 1000
ORDER BY turn DESC
LIMIT 1;
#-------------------------------------------
SELECT CONCAT(Name, '(', LEFT(Occupation,1), ')')
FROM OCCUPATIONS
ORDER BY NAME;

SELECT CONCAT('There are a total of ', COUNT(occupation), ' ', lower(occupation),'s.')
FROM Occupations
GROUP BY occupation
ORDER BY COUNT(occupation), occupation;
#-------------------------------------------
SELECT employee_id
FROM employees
WHERE salary <30000 AND manager_id  NOT IN (SELECT employee_id from employees)
ORDER BY employee_id;
#-------------------------------------------

SELECT user_id, CONCAT(UPPER(LEFT(name,1)), LOWER(SUBSTRING(name,2))) AS name
FROM Users
ORDER BY user_id;
#--------------------------------
DELETE p2
FROM Person p1
JOIN Person p2 ON p1.email = p2.email AND p1.id < p2.id;
#----------------------
--Write your MySQL query statement below
SELECT 
  sell_date, 
  COUNT(DISTINCT product) AS num_sold, 
  GROUP_CONCAT(DISTINCT product ORDER BY product ASC) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date ASC;
#---------------------------------
SELECT product_name, SUM(unit) AS unit
FROM products p JOIN orders o
ON p.product_id = o.product_id
WHERE YEAR(o.order_date)='2020' AND MONTH(o.order_date)='02'
GROUP BY p.product_id
HAVING SUM(unit) >= 100;
------------------------------------
SELECT user_id, name, mail
FROM Users
WHERE mail REGEXP '^[A-Za-z][A-Za-z0-9._-]*@leetcode\\.com$';
-----------------------------------------------------------------
--1907. Count Salary Categories version#1
WITH category_list AS (
    SELECT 'Low Salary' AS salary_category
    UNION ALL
    SELECT 'Average Salary'
    UNION ALL
    SELECT 'High Salary'
),
category_setter AS (
    SELECT account_id,
        CASE
            WHEN income < 20000 THEN 'Low Salary'
            WHEN income BETWEEN 20000 AND 50000 THEN 'Average Salary'
            WHEN income > 50000 THEN 'High Salary'
        END AS salary_category
    FROM Accounts
)

SELECT 
    cl.salary_category AS category,
    COUNT(cs.account_id) AS accounts_count
FROM category_list cl
LEFT JOIN category_setter cs 
    ON cl.salary_category = cs.salary_category
GROUP BY cl.salary_category
ORDER BY 
    CASE cl.salary_category
        WHEN 'Low Salary' THEN 1
        WHEN 'Average Salary' THEN 2
        WHEN 'High Salary' THEN 3
    END;
--version#2 

SELECT 'Low Salary' AS category, SUME(CASE WHEN income < 20000 THEN 1 ELSE 0 END) AS accounts_count
FROM Accounts 

UNION 
SELECT 'Average Salary' AS category, SUME(CASE WHEN income BETWEEN 20000 AND 50000 THEN 1 ELSE 0 END) AS accounts_count
FROM Accounts 
UNION 
SELECT 'High Salary' AS category, SUME(CASE WHEN income > 50000 THEN 1 ELSE 0 END) AS accounts_count
FROM Accounts 
---------------------------------------------------------------------------------
# Write your MySQL query statement below
with highest_second_salary AS
(
    SELECT salary, dense_rank() over (ORDER BY salary DESC) rank_highest
    FROM Employee
)

SELECT  MAX(Salary) as SecondHighestSalary
FROM highest_second_salary 
WHERE rank_highest = 2
    