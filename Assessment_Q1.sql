SELECT 
    u.id AS owner_id,
    u.name, -- this may or may not be neccesary, I decided to include it alongside with the next column
    CONCAT(first_name, ' ', last_name) AS Concated_name, -- I joined the first and last name together since the name column itself is NULL
    COUNT(DISTINCT CASE
            WHEN p.is_regular_savings = 1 THEN s.id -- following the hint in the document
        END) AS savings_count,
    COUNT(DISTINCT CASE
            WHEN p.is_a_fund = 1 THEN s.id -- following the hint in the document
        END) AS investment_count,
    SUM(s.confirmed_amount) / 100.0 AS total_deposits -- divide by 100 to convert from kobo to Naira
FROM
    users u
        JOIN
    savings s ON u.id = s.owner_id
        JOIN
    plans p ON s.plan_id = p.id
WHERE
    s.confirmed_amount > 0 -- there are 2 observations of negative amount, hence the use of this where command
GROUP BY u.id , u.name
HAVING savings_count >= 1
    AND investment_count >= 1 
ORDER BY total_deposits DESC;