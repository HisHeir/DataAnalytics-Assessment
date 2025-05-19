# DataAnalytics-Assessment
## Per-Question Explanations

## Question 1: Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

### Explanation:
The task sought to identify users who have both savings and investment plans (defined by plan flags), and sort them by total deposits, to indicate high-value Customers with multiple products. I identified the column needed for the task in each of the tables provided,the user id, and name from user table, the plan either savings or invested flagged with 1 in plans table, and confirmed amount in the savings table. And since the amount was given in kobo, it was necessary to convert it to naira before use. A relationship was established amonng the tables ob the basis of their primary and foreign keys, and the query was grouped by user id and name and filter where saving count and investment plan was more than or equal to 1.

## Challenges:

1. Savings and investment plans are stored together in the plan table but flagged differently which required me to use the CASE expressions to count distinct savings and investment plans per user.
2. Somebackground query written showed that confirmed amount in savings has negative values which seemed a bit unrealistic, hence where clause was used to filter only the positive records.
3. The records and fields needed are scattered across the three tables, therefore inner join was required to establish connection among the tables on the basis of their similar columns.
4. Aggregation and sorting was needed, and it was resolved alongside with the group by syntax and filtered with having.
