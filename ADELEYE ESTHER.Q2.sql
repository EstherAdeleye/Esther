--QUESTION 2


WITH MonthlyTransactions AS (
    -- I Counted transactions per customer per month
    SELECT
        sa.owner_id,
        DATE_FORMAT(sa.transaction_date, '%Y-%m') AS transaction_month,
        COUNT(sa.id) AS transactions_count
    FROM
        savings_savingsaccount AS sa
    GROUP BY
        sa.owner_id,
        transaction_month
),
CustomerMonthlyAverages AS (
    -- Then I Calculated the average number of transactions per customer
    -- handling cases where a user might have transactions in multiple months.
    -- This CTE calculates the total transactions and the count of months with transactions for each user.
    SELECT
        mt.owner_id,
        SUM(mt.transactions_count) AS total_transactions,
        COUNT(mt.transaction_month) AS months_active,
        SUM(mt.transactions_count) / COUNT(mt.transaction_month) AS avg_transactions_per_month
    FROM
        MonthlyTransactions AS mt
    GROUP BY
        mt.owner_id
),
CategorizedCustomers AS (
    -- Then Categorize customers based on their average transactions per month
    SELECT
        cma.owner_id,
        cma.avg_transactions_per_month,
        CASE
            WHEN cma.avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN cma.avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            WHEN cma.avg_transactions_per_month <= 2 THEN 'Low Frequency'
            ELSE 'Unknown' 
        END AS frequency_category
    FROM
        CustomerMonthlyAverages AS cma
)
-- Finally Aggregate results to get the final output.
SELECT
    cc.frequency_category,
    COUNT(DISTINCT cc.owner_id) AS customer_count,
    ROUND(AVG(cc.avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM
    CategorizedCustomers AS cc
GROUP BY
    cc.frequency_category
ORDER BY
    CASE cc.frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
        ELSE 4
    END;