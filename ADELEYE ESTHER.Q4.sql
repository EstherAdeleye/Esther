--Question 4

SELECT
    u.id AS customer_id,
    u.first_name,
    u.last_name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,
    COUNT(sa.id) AS total_transactions,
    ROUND(
        (0.001 * SUM(sa.confirmed_amount)) * 12 /
        NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()), 0), -- Preventing division by zero if tenure_months is 0
        2
    ) AS estimated_clv
FROM
    users_customuser AS u
JOIN
    savings_savingsaccount AS sa ON u.id = sa.owner_id
WHERE
    u.is_account_deleted = 0 --working on only active customers
    AND u.is_account_disabled = 0
GROUP BY
    u.id, u.first_name, u.last_name, u.date_joined -- Grouping by first_name and last_name now
HAVING
    tenure_months > 0 -- Only considering customers with at least one month of tenure to avoid division by zero
    AND COUNT(sa.id) > 0 -- Only considering customers with transactions
ORDER BY
    estimated_clv DESC;