SELECT * FROM job_data;

#Objective: Calculate the number of jobs reviewed per hour for each day in November 2020.
#Your Task: Write an SQL query to calculate the number of jobs reviewed per hour for each day in November 2020.
SELECT COUNT(DISTINCT job_id) / (DATEDIFF('2020-11-30', '2020-11-25') * 24) AS Jobs_reviewed_per_hour
FROM job_data
WHERE ds BETWEEN '2020-11-25' AND '2020-11-30';

#Objective: Calculate the 7-day rolling average of throughput (number of events per second).
#Write an SQL query to calculate the 7-day rolling average of throughput.
SELECT ds, COUNT(DISTINCT job_id) AS jobs_reviewed, 
AVG(COUNT(DISTINCT job_id)) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS throughput
FROM job_data
WHERE ds BETWEEN '2020-11-25' AND '2020-11-30'
GROUP BY ds
ORDER BY ds;

#Objective: Calculate the percentage share of each language in the last 30 days.
#Your Task: Write an SQL query to calculate the percentage share of each language over the last 30 days
SELECT 
    language,
    COUNT(*) AS total_events,
    (COUNT(*) / (SELECT COUNT(*) FROM job_data WHERE ds BETWEEN '2020-11-25' AND '2020-11-30')) * 100 AS percentage_share
FROM 
    job_data
WHERE
    ds BETWEEN '2020-11-25' AND '2020-11-30'
GROUP BY 
    language
ORDER BY 
    percentage_share DESC;

#Identify duplicate rows in the data.
#Your Task: Write an SQL query to display duplicate rows from the job_data table.    
WITH CTE AS (
    SELECT *, row_number() OVER (PARTITION BY job_id) AS row_numb 
    FROM job_data
)
SELECT * 
FROM CTE 
WHERE row_numb > 1;

