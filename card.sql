-- first created customer table  
CREATE TABLE customer (
Customer_ID VARCHAR(25) PRIMARY KEY,
Customer_Name TEXT NOT NULL,
Gender VARCHAR(25),
Age	INT,
Marital_Status VARCHAR(25),
Occupation	VARCHAR(100),
Annual_Income INT,	
Customer_Segment VARCHAR(50),	
State VARCHAR(50),
City	VARCHAR(50),
Account_Type VARCHAR(50),
Customer_Since DATE)
ALTER TABLE customer
alter column annual_income type decimal(10,2)

-- created card table 
CREATE TABLE card(
Card_ID	VARCHAR(50) PRIMARY KEY,
Customer_ID VARCHAR(25)	NOT NULL REFERENCES customer(Customer_ID),
Card_Type VARCHAR(25),
Card_Network VARCHAR(25),
Credit_Limit INT,	
Card_Status	VARCHAR(25),
Contactless	VARCHAR(25),
Card_Mode	VARCHAR(25),
Issue_Date	DATE,
Expiry_Date DATE)

alter table card 
alter column credit_limit type decimal(10,2)

-- create third table merchant
CREATE TABLE merchant(
    Merchant_ID VARCHAR(50) NOT NULL PRIMARY KEY,
    Merchant_Name VARCHAR(50) NOT NULL,
    Merchant_Category VARCHAR(50),
    State  VARCHAR(50),
    City VARCHAR(50),
    Merchant_Risk_Level VARCHAR(50),
    Merchant_Rating DECIMAL(3,1),
    Merchant_Status VARCHAR(50),
    Merchant_Since DATE);
	
-- CREATED FOURTH TABLE TRANSACTION 
CREATE TABLE transaction (
    Transaction_ID        VARCHAR(50) NOT NULL PRIMARY KEY,
    Customer_ID            VARCHAR(50) NOT NULL REFERENCES customer(Customer_ID),
    Card_ID                 VARCHAR(50) NOT NULL REFERENCES card(Card_ID),
    Merchant_ID             VARCHAR(50) NOT NULL REFERENCES merchant(Merchant_ID),
    Transaction_Date        DATE NOT NULL,
    Transaction_Time        TIME NOT NULL,
    Transaction_Amount      DECIMAL(12,2) NOT NULL,
    Payment_Method          VARCHAR(30),
    Transaction_Channel     VARCHAR(30),
    Device_Type             VARCHAR(30),
    Transaction_Status      VARCHAR(20),
    Is_International        INT,
    Fraud_Flag              INT,
    Fraud_Reason            VARCHAR(100),
    Merchant_Risk_Level     VARCHAR(20),
    Merchant_Category       VARCHAR(50),
    Customer_State           VARCHAR(50),
    Customer_City            VARCHAR(50),
    Merchant_State           VARCHAR(50),
    Merchant_City            VARCHAR(50)
);

--Imported the raw CSV dataset into PostgreSQL
COPY customer
FROM 'C:\Mac\Home\Documents\sql\credit_card\archive\Cusmtomer_data.csv'
DELIMITER ','
CSV HEADER

COPY card
FROM 'C:\Mac\Home\Documents\sql\credit_card\archive\Cards_Data.csv'
DELIMITER ','
CSV HEADER

COPY merchant
FROM 'C:\Mac\Home\Documents\sql\credit_card\archive\merchant_table.csv'
DELIMITER ','
CSV HEADER

COPY transaction 
FROM  'C:\Mac\Home\Documents\sql\credit_card\archive\Transaction_Data_250k.csv'
DELIMITER ','
CSV HEADER

-- checking null value 
SELECT * 
FROM customer 
WHERE customer_id IS NULL 
OR  customer_name IS NULL
OR  gender IS NULL 
OR   age IS NULL
OR   marital_status IS NULL
OR  occupation IS NULL 
OR  annual_income IS NULL 
OR   customer_segment IS NULL 
OR  state IS NULL
OR  city IS NULL 
OR account_type IS NULL
OR customer_since IS NULL

-- checking null value IN CARDS TABLE  
SELECT * 
FROM card 
WHERE card_id IS NULL 
   OR customer_id  IS NULL 
   OR card_type IS NULL 
   OR card_network IS NULL 
   OR credit_limit IS NULL 
   OR card_status  IS NULL 
   OR contactless IS NULL
   OR card_mode IS NULL 
   OR issue_date IS NULL 
   OR expiry_date IS NULL 

-- merchant null value
SELECT * 
FROM merchant 
WHERE merchant_id IS NULL 
   OR merchant_name IS NULL
   OR merchant_category IS NULL
   OR state IS NULL
   OR city IS NULL
   OR merchant_risk_level IS NULL
   OR merchant_rating IS NULL
   OR merchant_status IS NULL
   OR merchant_since IS NULL

--null value in transaction 
SELECT *
FROM transaction 
WHERE transaction_id IS NULL 
   OR customer_id IS NULL 
   OR card_id IS NULL 
   OR merchant_id IS NULL 
   OR transaction_date  IS NULL 
   OR transaction_time  IS NULL 
   OR transaction_amount IS NULL 
   OR payment_method IS NULL 
   OR transaction_channel IS NULL 
   OR device_type IS NULL
   OR transaction_status IS NULL 
   OR is_international IS NULL 
   OR fraud_flag IS NULL 
   OR fraud_reason  IS NULL 
   OR merchant_risk_level IS NULL 
   OR merchant_category IS NULL 
   OR customer_state  IS NULL 
   OR customer_city IS NULL 
   OR merchant_state IS NULL
   OR merchant_city IS NULL 

-- check duplicate value in customers table 
SELECT customer_id
FROM
 (
  SELECT * ,
   ROW_NUMBER() OVER 
     (PARTITION BY customer_id
     ORDER BY customer_id  ) AS rnk
     FROM  customer 
) AS t 
WHERE  rnk > 1

-- check duplicate in card 
SELECT *
FROM card 
WHERE card_id IN (
            SELECT card_id
            FROM card 
            GROUP BY card_id 
            HAVING COUNT(*) > 1)

-- check duplicate in merchant
SELECT * 
FROM merchant 
WHERE merchant_id in (
      SELECT merchant_id 
	  FROM merchant 
	  GROUP BY merchant_id 
	  HAVING COUNT(*)> 1)

--CHECK DUPLICATE IN TRANSACTION
SELECT * 
FROM transaction 
WHERE transaction_id in (
      SELECT transaction_id 
	  FROM transaction
	  GROUP BY transaction_id 
	  HAVING COUNT(*)> 1)

-- COUNT OF ROWS 

SELECT COUNT(*)as num_of_customer
FROM customer

SELECT COUNT(*) as num_of_rows
FROM card

SELECT COUNT(*) AS num_of_merchant
FROM merchant

SELECT COUNT(*) AS num_of_transaction 
FROM transaction

--checking unique value each column in customer table
SELECT DISTINCT gender FROM customer
SELECT DISTINCT city FROM customer
SELECT DISTINCT customer_segment FROM customer
SELECT DISTINCT marital_status FROM customer
SELECT DISTINCT  occupation FROM customer
SELECT DISTINCT state FROM customer
SELECT DISTINCT account_type  FROM customer

update customer 
set customer_segment = 'Divorced'
where  customer_segment = 'Divorsed'

-- checking unique  value in card table 
SELECT DISTINCT card_type FROM card

SELECT DISTINCT card_status FROM card

SELECT DISTINCT card_network FROM card

SELECT DISTINCT contactless FROM card

SELECT DISTINCT card_mode FROM card

-

--checking unique value each column in mechant 
SELECT DISTINCT merchant_category FROM merchant

SELECT DISTINCT merchant_risk_level FROM merchant

SELECT DISTINCT merchant_rating FROM merchant

SELECT DISTINCT merchant_status FROM merchant

SELECT DISTINCT state  FROM merchant

SELECT DISTINCT city FROM merchant

--checking unique value each column in mechant

SELECT DISTINCT device_type FROM transaction;

SELECT DISTINCT transaction_status FROM transaction;

SELECT DISTINCT transaction_channel FROM transaction;

SELECT DISTINCT payment_method FROM transaction;

SELECT DISTINCT merchant_category FROM transaction;

SELECT DISTINCT fraud_reason FROM transaction;

SELECT DISTINCT customer_state FROM transaction;

SELECT DISTINCT merchant_state FROM transaction;

SELECT DISTINCT merchant_risk_level FROM transaction;

SELECT DISTINCT fraud_flag FROM transaction;

SELECT DISTINCT is_international FROM transaction;

 -- ANALYSIS 
-- Customer count by segment
SELECT customer_segment, 
 COUNT(*) AS num_customers
FROM customer 
GROUP BY customer_segment 
ORDER BY num_customers DESC;

-- Gender split
SELECT gender, 
COUNT(*) AS num_customers
FROM customer 
GROUP BY gender;

-- Account type distribution
SELECT account_type,
COUNT(*) AS num_customers
FROM customer 
GROUP BY account_type 
ORDER BY num_customers DESC;

-- Top 10 states by customer count
SELECT state, 
 COUNT(*) AS num_customers
FROM customer 
GROUP BY state 
ORDER BY num_customers DESC 
LIMIT 10;

-- Card status breakdown (Active/Expired/Blocked/Lost)
SELECT card_status, 
  COUNT(*) AS num_cards
FROM card
GROUP BY card_status 
ORDER BY num_cards DESC;

-- Card network distribution
SELECT card_network, 
  COUNT(*) AS num_cards
FROM card 
GROUP BY card_network 
ORDER BY num_cards DESC;

-- Virtual vs Physical card split
SELECT card_mode,
  COUNT(*) AS num_cards
FROM card 
GROUP BY card_mode;


-- Average credit limit by card type
SELECT card_type, 
   ROUND(AVG(credit_limit),2) AS avg_limit
FROM card  
GROUP BY card_type 
ORDER BY avg_limit DESC;


-- Average age and average income overall
SELECT ROUND(AVG(age),1) AS avg_age, 
      ROUND(AVG(annual_income),2) AS avg_income
FROM customer;

-- Merchant category distribution
SELECT merchant_category, 
 COUNT(*) AS num_merchants
FROM merchant 
GROUP BY merchant_category 
ORDER BY num_merchants DESC;

-- Merchant risk level split
SELECT merchant_risk_level, 
 COUNT(*) AS num_merchants
FROM merchant 
GROUP BY merchant_risk_level;

-- Average merchant rating
SELECT 
ROUND(AVG(merchant_rating),2) AS avg_rating
FROM merchant;

--Which payment method is used most frequently?
SELECT  payment_method ,
       COUNT(transaction_id) as num_of_usage
FROM transaction 
GROUP BY payment_method 
ORDER BY num_of_usage  DESC;

--Which transaction channel has the most transactions?
SELECT transaction_channel,
       count(transaction_id) as num_of_usage 
FROM transaction
GROUP BY transaction_channel
ORDER BY num_of_usage DESC 

--Which device type is used most frequently?
SELECT device_type,
    COUNT(transaction_id) as num_of_usage
FROM transaction 
GROUP BY device_type 
ORDER BY num_of_usage DESC 

--What is the total transaction amount?
SELECT 
    ROUND(SUM(transaction_amount) / 1000000000, 2) || 'B' AS total_transaction
FROM transaction;

--Which transaction status occurs most often?
SELECT transaction_status,
       count(*) AS num_of_occurs
FROM transaction 
GROUP BY  transaction_status
ORDER BY  num_of_occurs DESC 

--How many transactions are marked as fraud?
SELECT fraud_flag,
       count(*) AS num_of_occurs 
FROM transaction 
GROUP BY  Fraud_flag

--What percentage of transactions are fraudulent?
SELECT fraud_flag,
       count(*) filter(where fraud_flag = 1 ) * 100 /count(*) AS num_of_occurs 
FROM transaction 
GROUP BY  Fraud_flag


--Which payment method has the highest average transaction amount?
select payment_method,
        round(avg
		        (transaction_amount),2) as avg_transaction_amount
from transaction 
group by payment_method 
order by avg_transaction_amount desc

select * from customer
select * from transaction 

--Does Customer_Segment (Gold/Standard/Platinum) correlate with spend, fraud exposure, or channel preference?
select * from card 
select * from customer 
select * from transaction

--Income vs Credit_Limit vs actual spend — are any Card_Type tiers under/over-limited relative to income?
	SELECT
    cr.card_type,
    ROUND(AVG(c.annual_income), 2)                          AS avg_income,
    ROUND(AVG(cr.credit_limit), 2)                           AS avg_credit_limit,
    ROUND(AVG(cr.credit_limit) * 100.0 / AVG(c.annual_income), 2) AS limit_pct_of_income,
    ROUND(AVG(spend.total_spend), 2)                         AS avg_total_spend,
    ROUND(AVG(spend.total_spend) * 100.0 / AVG(cr.credit_limit), 2) AS utilization_pct
FROM card AS cr
JOIN customer AS c 
    ON c.customer_id = cr.customer_id
LEFT JOIN (
    SELECT card_id, SUM(transaction_amount) AS total_spend
    FROM transaction
    GROUP BY card_id
) AS spend 
    ON spend.card_id = cr.card_id
GROUP BY cr.card_type
ORDER BY utilization_pct DESC;

--Age-band spending behavior — generational differences in Transaction_Channel (Mobile App vs ATM) and Merchant_Category.
SELECT
   CASE WHEN c.age < 20 then 'TEENAGE'
        WHEN C.age > 21 and c.age < 30 THEN 'YOUNG'
		WHEN C.age > 31 and c.age < 50 THEN 'ADLUT'
		ELSE 'OLDER'
		END AS age_category,
		t.transaction_channel,
		t.merchant_category,
		sum(t.transaction_amount) as total_amount,
		ROUND(AVG(t.transaction_amount), 2) AS avg_amount
from customer as c
left join transaction as t 
on c.customer_id = t.customer_id 
where t.transaction_channel IN ('Mobile App', 'ATM')
group by age_category, t.transaction_channel,t.merchant_category
order by age_category, total_amount desc


--Merchant rating vs transaction volume — 
--do highly-rated merchants actually get more business, or is rating disconnected from volume?

SELECT 
    CASE 
        WHEN m.merchant_rating < 3.5 THEN '3.5 (Low)'
        WHEN m.merchant_rating < 4.0 THEN '3.5-4.0 (Avg)'
        WHEN m.merchant_rating < 4.5 THEN '4.0-4.5 (Good)'
        ELSE '4.5-5.0 (High)'
    END AS rating_tier,
    COUNT(DISTINCT m.merchant_id) AS num_merchants,
    COUNT(transaction_id) AS total_transaction_volume,
    ROUND(COUNT(transaction_id) * 1.0 / COUNT(DISTINCT m.merchant_id), 1) AS avg_volume_per_merchant
FROM transaction AS t
INNER JOIN merchant AS m 
    ON t.merchant_id = m.merchant_id
GROUP BY rating_tier
ORDER BY rating_tier

--Segment customers by Customer_Segment (Gold/Standard/Platinum) 
--and Annual_Income — compute average transaction value and total spend per segment. 
--Is segment tier aligned with actual spending behavior?
SELECT C.customer_segment,
	count (DISTINCT C.customer_id) AS num_customer,
    ROUND(AVG(T.transaction_amount),2) AS avg_trans_amt,
	ROUND(AVG(C.annual_income),2) AS avg_anul_income,
	Round(sum(T.transaction_amount),0) AS trans_amount,
	Round(sum(T.transaction_amount) / COUNT(DISTINCT C.customer_id),2) AS avg_cust_amount
FROM customer AS C 
LEFT JOIN transaction AS T
   ON C.customer_id  = T.customer_id
GROUP BY C.customer_segment

--Which Occupation and State combinations show the highest average card spend?
SELECT c.state,
      c.occupation , 
	   ROUND(
	    AVG(t.transaction_amount),2) as avg_spend,
		COUNT(DISTINCT c.customer_id) AS num_of_cust
FROM customer as c
LEFT JOIN transaction  t 
on c.customer_id = t.customer_id 
GROUP BY  c.state ,c.occupation 
HAVING COUNT(DISTINCT c.customer_id) > 15 
order by  avg_spend DESC
LIMIT 20 

--Analyze Card_Type × Card_Network combinations — which network/card pairing 
--has the highest utilization (spend vs Credit_Limit)?

SELECT 
    card_type,
    card_network,
    COUNT(DISTINCT card_id) AS num_of_cards,
    ROUND(AVG(credit_limit), 2) AS avg_credit_limit,
    ROUND(AVG(total_spend), 2) AS avg_total_spend,
    ROUND(SUM(total_spend) / SUM(credit_limit) * 100, 2) || '%' AS utilization
FROM (
    SELECT 
        cr.card_id,
        cr.card_type,
        cr.card_network,
        cr.credit_limit,
        COALESCE(SUM(t.transaction_amount), 0) AS total_spend
    FROM card AS cr
    LEFT JOIN transaction AS t
        ON cr.card_id = t.card_id
    GROUP BY cr.card_id, cr.card_type, cr.card_network, cr.credit_limit
) AS per_card
GROUP BY card_type, card_network
ORDER BY utilization DESC;


--Compute credit utilization ratio per customer (sum of spend / credit limit).
--Flag customers >80% utilization as high risk.

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT card_id) AS num_of_cards,
    ROUND(SUM(total_spend) / SUM(credit_limit) * 100, 2) AS utilization_pct,
    CASE 
        WHEN SUM(total_spend) / SUM(credit_limit) * 100 > 80 THEN 'High Risk'
        ELSE 'Normal'
    END AS risk_flag
FROM (
    SELECT 
        c.customer_id,
        c.customer_name,
        cr.card_id,
        cr.credit_limit,
        COALESCE(SUM(t.transaction_amount), 0) AS total_spend
    FROM card AS cr
    LEFT JOIN transaction AS t 
        ON cr.card_id = t.card_id
    LEFT JOIN customer AS c 
        ON cr.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name, cr.card_id, cr.credit_limit
) AS per_card
GROUP BY customer_id, customer_name
HAVING SUM(total_spend) / SUM(credit_limit) * 100 > 80
ORDER BY utilization_pct DESC;



-- What is the overall fraud rate (Fraud_Flag)? 
--Break it down by Transaction_Channel, Device_Type, Payment_Method, and Is_International.
SELECT 
    transaction_channel,
    device_type,
    payment_method,
    is_international,
    ROUND(
        num_of_fraud * 100.0 / NULLIF(total_transactions, 0),
        2
    ) AS fraud_rate
FROM (
    SELECT 
        transaction_channel,
        device_type,
        payment_method,
        is_international,
        COUNT(*) FILTER (WHERE fraud_flag = 1) AS num_of_fraud,
        COUNT(*) AS total_transactions
    FROM transaction
    GROUP BY 
        transaction_channel,
        device_type,
        payment_method,
        is_international
) AS fraud_data
ORDER BY fraud_rate DESC;

-- Build a fraud profile: do fraudulent transactions cluster around specific Merchant_Risk_Level, 
--Merchant_Category, time of day (Transaction_Time), or transaction amount ranges?

SELECT 
    m.merchant_risk_level,
    m.merchant_category,
    t.time_of_day,
    t.amount_range,
    COUNT(t.transaction_id) AS num_of_transaction,
    COUNT(*) FILTER (WHERE t.fraud_flag = 1) AS num_of_fraud,
    ROUND(
        COUNT(*) FILTER (WHERE t.fraud_flag = 1) * 100.0
        / NULLIF(COUNT(t.transaction_id), 0), 
    2) AS fraud_rate_pct,
    SUM(t.transaction_amount) FILTER (WHERE t.fraud_flag = 1) AS fraud_amount_total
FROM merchant AS m
LEFT JOIN (
    SELECT 
        transaction_id,
        merchant_id,
        fraud_flag,
        transaction_amount,
        CASE 
            WHEN EXTRACT(HOUR FROM transaction_time) BETWEEN 7 AND 11  THEN 'MORNING'
            WHEN EXTRACT(HOUR FROM transaction_time) BETWEEN 12 AND 16 THEN 'AFTERNOON'
            WHEN EXTRACT(HOUR FROM transaction_time) BETWEEN 17 AND 20 THEN 'EVENING'
            ELSE 'NIGHT'
        END AS time_of_day,
        CASE 
            WHEN transaction_amount < 10000 THEN 'Low'
            WHEN transaction_amount BETWEEN 10000 AND 50000 THEN 'Medium'
            ELSE 'High'
        END AS amount_range
    FROM transaction
) AS t
ON m.merchant_id = t.merchant_id
GROUP BY 
    m.merchant_risk_level, 
    m.merchant_category, 
    t.time_of_day, 
    t.amount_range
HAVING COUNT(t.transaction_id) >= 30  
ORDER BY fraud_rate_pct DESC NULLS LAST;

SELECT * FROM transaction 
select * from card 
select * from customer 
select *  from merchant 
	 
-- Compare Customer_State vs Merchant_ State — do cross-state/
--international transactions have disproportionately higher fraud rates?
SELECT 
    CASE WHEN merchant_state <> customer_state THEN 'Cross-State' ELSE 'Same-State' END AS state_match,
    CASE WHEN is_international = 1 THEN 'International' ELSE 'Domestic' END AS intl_flag,
	 ROUND(
        COUNT(*) FILTER (WHERE fraud_flag = 1)::numeric / COUNT(*) * 100, 2
    ) AS fraud_rate
from transaction 
group by 1,2
order by fraud_rate desc

-- Using Fraud_Reason, categorize fraud types and find which reason contributes 
--most to $ loss (not just count)
SELECT  
     fraud_reason,
	 round(sum(transaction_amount),0)fraud_amount,
	 count(*) as num_fraud,
	 round (
     sum(transaction_amount) / sum(sum(transaction_amount)) over() * 100,2 
	 ) as avg_part
FROM transaction 
where fraud_flag = 1
group by fraud_reason 
order by avg_part asc

--Which merchants (Merchant_Rating low + Merchant_Risk_Level high) 
--generate the most fraud volume? Should any be blacklisted?

SELECT
    m.merchant_id,
    m.merchant_name,
    m.merchant_risk_level,
    m.merchant_rating,
    COUNT(*) FILTER (WHERE t.fraud_flag = 1) AS fraud_txns,
    COUNT(*) AS total_txns,
    ROUND(COUNT(*) FILTER (WHERE t.fraud_flag = 1)::numeric / COUNT(*) * 100, 2) AS fraud_rate_pct,
    SUM(t.transaction_amount) FILTER (WHERE t.fraud_flag = 1) AS fraud_dollar_volume
FROM merchant m
JOIN transaction t 
ON t.merchant_id = m.merchant_id
WHERE m.merchant_risk_level = 'High'
  AND m.merchant_rating < 4.3   
GROUP BY m.merchant_id, m.merchant_name, m.merchant_risk_level, m.merchant_rating
ORDER BY fraud_dollar_volume DESC;






	  



