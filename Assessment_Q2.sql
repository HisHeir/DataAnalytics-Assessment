
#Using CTEs-common table expressions:
#I created the monthly transaction per user temporary table which was further used to create the 
#average transaction per user which in turn generated the frequency category field
WITH monthly_txn_per_user AS (
    SELECT 
        s.owner_id,
        extract(month from s.transaction_date) AS txn_month, -- this returns the transaction months in numbers, JANUARY as 1 to DECEMBER as 12
        COUNT(*) AS monthly_txn_count
    FROM savings s
    WHERE s.transaction_status = 'success' or s.transaction_status = 'successful'  -- Optional: only count successful transactions
    GROUP BY s.owner_id, txn_month
),

avg_txn_per_user AS (
    SELECT 
        owner_id,
        AVG(monthly_txn_count) AS avg_txn_per_month
    FROM monthly_txn_per_user
    GROUP BY owner_id
),

categorized_users AS (
    SELECT 
        CASE -- the case expression function performs conditional logic to return frequency category based on the 3 conditions provided
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM avg_txn_per_user
)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month -- round to 2 decimal numbers.
FROM categorized_users
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');