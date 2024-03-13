#CASE STUDY 2
DROP table users;
#users Table:
Create table users(
user_id	int,
created_at	VARCHAR(100),
company_id int,
language VARCHAR(50),
activated_at VARCHAR(100),
state VARCHAR(50)
);
SELECT * FROM users;
SHOW VARIABLES LIKE 'secure_file_priv';
#users
#Loading files:
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
into table users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT * FROM users;

SET SQL_SAFE_UPDATES = 0;
#To change data columns from STRING type to DATE type:
ALTER TABLE users add column temp_created_at datetime;
UPDATE users SET temp_created_at= str_to_date(created_at, '%d-%m-%Y %H:%i');
ALTER TABLE users DROP COLUMN created_at;
ALTER TABLE users CHANGE COLUMN temp_created_at created_at DATETIME;

ALTER TABLE users add column temp_activated_at datetime;
UPDATE users SET temp_activated_at= str_to_date(activated_at, '%d-%m-%Y %H:%i');
ALTER TABLE users DROP COLUMN activated_at;
ALTER TABLE users CHANGE COLUMN temp_activated_at activated_at DATETIME;

SELECT * FROM users;

#events
Create table events(
user_id	int,
occurred_at	VARCHAR(100),
event_type VARCHAR(100),
event_name VARCHAR(50),
location VARCHAR(50),
device VARCHAR(50),
user_type int
);

SELECT * FROM events;
SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
into table events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE events add column temp_occurred_at datetime;
UPDATE events SET temp_occurred_at= str_to_date(occurred_at, '%d-%m-%Y %H:%i');
ALTER TABLE events DROP COLUMN occurred_at;
ALTER TABLE events CHANGE COLUMN temp_occurred_at occurred_at DATETIME;

SELECT * FROM events;

#email_events:

Create table email_events(
user_id	int,
occurred_at	VARCHAR(100),
action VARCHAR(100),
user_type int
);
SELECT * FROM email_events;

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
into table email_events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT * FROM email_events;

SET SQL_SAFE_UPDATES = 0;
ALTER TABLE email_events add column temp_occurred_at datetime;
UPDATE email_events SET temp_occurred_at= str_to_date(occurred_at, '%d-%m-%Y %H:%i');
ALTER TABLE email_events DROP COLUMN occurred_at;
ALTER TABLE email_events CHANGE COLUMN temp_occurred_at occurred_at DATETIME;

#Weekly User Engagement:
#Objective: Measure the activeness of users on a weekly basis.
#Your Task: Write an SQL query to calculate the weekly user engagement.
SELECT EXTRACT(WEEK FROM occurred_at) AS "Week Numbers", COUNT(DISTINCT user_id) as "Weekly Active users"
FROM events
WHERE event_type= "engagement"
GROUP BY 1;

#User Growth Analysis:
#Objective: Analyze the growth of users over time for a product.
#Your Task: Write an SQL query to calculate the user growth for the product.
SELECT 
    Months, 
    user_count, 
    ((user_count / LAG(user_count, 1) OVER (ORDER BY Months) - 1) * 100) AS Growth 
FROM 
    (
        SELECT 
            EXTRACT(MONTH FROM users.created_at) AS Months, 
            COUNT(*) AS user_count 
        FROM 
            USERS 
        WHERE 
            users.activated_at IS NOT NULL 
        GROUP BY 
            Months 
        ORDER BY 
            Months
    ) AS A;
    
#Objective: Analyze the retention of users on a weekly basis after signing up for a product.
#Your Task: Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.
SELECT FIRST AS "WEEK NUMBERS",
SUM(CASE WHEN WEEK_NUMBER = 0 THEN 1 ELSE 0 END) AS "WEEK 0",
SUM(CASE WHEN WEEK_NUMBER = 1 THEN 1 ELSE 0 END) AS "WEEK 1",
SUM(CASE WHEN WEEK_NUMBER = 2 THEN 1 ELSE 0 END) AS "WEEK 2",
SUM(CASE WHEN WEEK_NUMBER = 3 THEN 1 ELSE 0 END) AS "WEEK 3",
SUM(CASE WHEN WEEK_NUMBER = 4 THEN 1 ELSE 0 END) AS "WEEK 4",
SUM(CASE WHEN WEEK_NUMBER = 5 THEN 1 ELSE 0 END) AS "WEEK 5",
SUM(CASE WHEN WEEK_NUMBER = 6 THEN 1 ELSE 0 END) AS "WEEK 6",
SUM(CASE WHEN WEEK_NUMBER = 7 THEN 1 ELSE 0 END) AS "WEEK 7",
SUM(CASE WHEN WEEK_NUMBER = 8 THEN 1 ELSE 0 END) AS "WEEK 8",
SUM(CASE WHEN WEEK_NUMBER = 9 THEN 1 ELSE 0 END) AS "WEEK 9",
SUM(CASE WHEN WEEK_NUMBER = 10 THEN 1 ELSE 0 END) AS "WEEK 10",
SUM(CASE WHEN WEEK_NUMBER = 11 THEN 1 ELSE 0 END) AS "WEEK 11",
SUM(CASE WHEN WEEK_NUMBER = 12 THEN 1 ELSE 0 END) AS "WEEK 12",
SUM(CASE WHEN WEEK_NUMBER = 13 THEN 1 ELSE 0 END) AS "WEEK 13",
SUM(CASE WHEN WEEK_NUMBER = 14 THEN 1 ELSE 0 END) AS "WEEK 14",
SUM(CASE WHEN WEEK_NUMBER = 15 THEN 1 ELSE 0 END) AS "WEEK 15",
SUM(CASE WHEN WEEK_NUMBER = 16 THEN 1 ELSE 0 END) AS "WEEK 16",
SUM(CASE WHEN WEEK_NUMBER = 17 THEN 1 ELSE 0 END) AS "WEEK 17",
SUM(CASE WHEN WEEK_NUMBER = 18 THEN 1 ELSE 0 END) AS "WEEK 18"
FROM
(SELECT A.user_id, A.login_week, B.FIRST, A.login_week - FIRST AS WEEK_NUMBER
FROM
(SELECT user_id, EXTRACT(WEEK FROM OCCURRED_AT) AS LOGIN_WEEK FROM events
GROUP BY 1,2)A,
(SELECT user_id, MIN(EXTRACT( WEEK FROM occurred_at)) AS FIRST FROM events
GROUP BY 1)B
WHERE A.user_id = B.user_id
)SUB
GROUP BY FIRST
ORDER BY FIRST;

#Objective: Measure the activeness of users on a weekly basis per device.
#Your Task: Write an SQL query to calculate the weekly engagement per device.
SELECT 
    EXTRACT(YEAR FROM occurred_at) AS Year,
    EXTRACT(WEEK FROM occurred_at) AS Week,
    device,
    COUNT(*) AS WeeklyEngagement
FROM 
    events
GROUP BY 
    Year, Week, device
ORDER BY 
    Year, Week, device;

#Objective: Analyze how users are engaging with the email service.
#Your Task: Write an SQL query to calculate the email engagement metrics.
SELECT 
    WEEK,
    ROUND((weekly_digest / total * 100), 2) AS "Weekly Digest Rate",
    ROUND((email_opens / total * 100), 2) AS "Email Open Rate",
    ROUND((email_clickthrough / total * 100), 2) AS "Email Clickthrough Rate",
    ROUND((reengagement_emails / total * 100), 2) AS "Reengagement Email Rate"
FROM
    (SELECT 
        EXTRACT(WEEK FROM occurred_at) AS WEEK,
        COUNT(CASE WHEN action = 'sent_weekly_digest' THEN user_id ELSE NULL END) AS weekly_digest,
        COUNT(CASE WHEN action = 'email_open' THEN user_id ELSE NULL END) AS email_opens,
        COUNT(CASE WHEN action = 'email_clickthrough' THEN user_id ELSE NULL END) AS email_clickthrough,
        COUNT(CASE WHEN action = 'sent_reengagement_email' THEN user_id ELSE NULL END) AS reengagement_emails,
        COUNT(user_id) AS total
    FROM 
        email_events
    GROUP BY 
        1
    ORDER BY 
        1) AS subquery;
