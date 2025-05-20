
--QUESTION 1

SELECT
    u.id AS owner_id,
    u.first_name,last_name,
    SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count,
    SUM(CASE WHEN p.is_fixed_investment = 1 THEN 1 ELSE 0 END) AS investment_count,
    SUM(sa.amount) AS total_deposits
FROM
    users_customuser AS u
JOIN
    savings_savingsaccount AS sa ON u.id = sa.owner_id
JOIN
    plans_plan AS p ON sa.plan_id = p.id
WHERE
    p.plan_type_id IN (1, 2)
GROUP BY
    u.id, u.name
HAVING
    savings_count > 0 AND investment_count > 0
ORDER BY
    total_deposits DESC;