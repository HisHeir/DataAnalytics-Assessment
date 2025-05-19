WITH user_transactions AS (
-- CTE begins
    SELECT 
        u.id AS customer_id,
        u.name, -- used the null value name column
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months, -- this returns the number of months each user has spent from date joined till current date
        COUNT(s.id) AS total_transactions,
        SUM(s.confirmed_amount) AS total_value
    FROM users u
    JOIN savings s ON u.id = s.owner_id
    WHERE s.confirmed_amount > 0
    GROUP BY u.id, u.name, u.date_joined
),
-- CTE ends
computed_clv AS (
-- another CTE begins again which uses the previous CTE
    SELECT
        customer_id,
        name,
        tenure_months,
        total_transactions,
        -- Handle division by zero for tenure
        CASE 
            WHEN tenure_months = 0 THEN 0
            -- convertion from kobo to naira wasn't done in the column below
            ELSE ROUND((total_transactions / tenure_months) * 12 * (total_value * 0.001 / total_transactions), 2) -- assuming the profit_per_transaction is 0.1% of the transaction value, and also rounding up to 2 decimal numbers.
        END AS estimated_clv
    FROM user_transactions
)
-- the CTE ends here
SELECT *
FROM computed_clv
ORDER BY estimated_clv DESC; -- the outer query
