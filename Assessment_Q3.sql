# Using CTEs to create temporary tables which were further used by the major(outer) query
WITH latest_transaction AS (
    SELECT 
        s.plan_id,
        s.owner_id,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings s
    WHERE s.confirmed_amount > 0
    GROUP BY s.plan_id, s.owner_id
), -- this temporarily creates a table that the next CTE uses

inactive_plans AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        lt.last_transaction_date,
        DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days -- this column returns the number of days between the last_transaction_date and the current date
    FROM plans p
    LEFT JOIN latest_transaction lt ON p.id = lt.plan_id
    WHERE 
        (p.is_regular_savings = 1 OR p.is_a_fund = 1)
        AND (lt.last_transaction_date IS NULL OR lt.last_transaction_date >= CURDATE() - INTERVAL 365 DAY) -- this filters out the transaction date that falls within the past 365 days to the current date or NULL with a saving or an investment plan
)

SELECT *
FROM inactive_plans
ORDER BY inactivity_days DESC; -- the major query