--1. Total transaction volume
SELECT COUNT(*) AS total_transactions
FROM fact_transactions;

--2. Total transaction amount by month
SELECT
    d.year,
    d.month,
    SUM(f.transaction_amount) AS total_amount
FROM fact_transactions f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

--3. Transaction amount by type
SELECT
    t.transaction_type,
    SUM(f.transaction_amount) AS total_amount,
    COUNT(*) AS total_transactions
FROM fact_transactions f
JOIN dim_transaction_type t
    ON f.transaction_type_key = t.transaction_type_key
GROUP BY t.transaction_type
ORDER BY total_amount DESC;

--4. Fraud rate
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN fraud_flag = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM fact_transactions;

--5. Top customers by transaction amount
SELECT
    c.customer_id,
    SUM(f.transaction_amount) AS total_spend
FROM fact_transactions f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_id
ORDER BY total_spend DESC
LIMIT 10;