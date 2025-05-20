

----question 3.
SELECT
    pp.id AS plan_id,
    pp.owner_id,
    CASE
        WHEN pp.is_regular_savings = 1 THEN 'Savings'
        WHEN pp.is_fixed_investment = 1 THEN 'Investment'
     
        ELSE 'Other Plan Type' -- Default if neither matches
    END AS type,
    COALESCE(MAX(sa.transaction_date), pp.created_on) AS last_transaction_date, 
   
    DATEDIFF(CURRENT_DATE(), COALESCE(MAX(sa.transaction_date), pp.created_on)) AS inactivity_days
FROM
    plans_plan AS pp
LEFT JOIN
    savings_savingsaccount AS sa ON pp.id = sa.plan_id
WHERE
    pp.is_archived = 0
    AND pp.is_deleted = 0
GROUP BY
    pp.id, pp.owner_id, pp.is_regular_savings, pp.is_fixed_investment, pp.created_on -- Group by all non-aggregated columns
HAVING
    inactivity_days > 365
ORDER BY
    inactivity_days DESC;