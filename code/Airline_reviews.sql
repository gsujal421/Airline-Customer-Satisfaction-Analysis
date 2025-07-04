create database airline;
create table airline_reviews 
(
ID	int not null primary key,
Gender	varchar (20),
Age	int,
`Age Group`  varchar (20),	
`Customer Type`	text,
`Type of Travel` text,
Class	text,
`Flight Distance` int,
`Departure Delay`	int,
`Arrival Delay` int,
`Total Delay` int,
`Delay Category`	text,
`Departure and Arrival Time Convenience` int,
`Ease of Online Booking` int,
`Check-in Service`	int,
`Online Boarding`	int,
`Gate Location` int,
`On-board Service`	int,
`Seat Comfort`int,
`Leg Room Service`	int,
Cleanliness	int,
`Food and Drink` int,
`In-flight Service`	int,
`In-flight Wifi Service` int,
`In-flight Entertainment` int,
`Baggage Handling` int,
Satisfaction text


);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airline_passenger_satisfaction.csv'
INTO TABLE airline_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- Which travel class (Business, Eco, Eco Plus) has the highest satisfaction rate?
SELECT 
    class,
    COUNT(CASE
        WHEN TRIM(LOWER(satisfaction)) = 'satisfied' THEN 1
    END) AS satisfied_count,
    COUNT(*) AS total_passenger,
    ROUND(100.0 * COUNT(CASE
                WHEN TRIM(LOWER(satisfaction)) = 'satisfied' THEN 1
            END) / COUNT(*),
            2) AS satisfaction_percentage
FROM
    airline_reviews
GROUP BY class
ORDER BY satisfaction_percentage DESC;


-- What is the overall passenger satisfaction rate?

SELECT 
    COUNT(CASE
        WHEN satisfaction = 'satisfied' THEN 1
    END) AS satisfied,
    COUNT(*) AS passenger,
    ROUND((COUNT(CASE
                WHEN satisfaction = 'satisfied' THEN 1
            END) * 100 / COUNT(*)),
            2) AS satisfied_rate
FROM
    airline_reviews;



-- Which service features contribute most to satisfaction
SELECT 
    ROUND(AVG(`Ease of Online Booking`), 2) AS `Ease of Online Booking`,
    ROUND(AVG(`Check-in Service`), 2) AS `Check-in Service`,
    ROUND(AVG(`Online Boarding`), 2) AS `Online Boarding`,
    ROUND(AVG(`Gate Location`), 2) AS `Gate Location`,
    ROUND(AVG(`On-board Service`), 2) AS `On-board Service`,
    ROUND(AVG(`Seat Comfort`), 2) AS `Seat Comfort`,
    ROUND(AVG(`Leg Room Service`), 2) AS `Leg Room Service`,
    ROUND(AVG(Cleanliness), 2) AS Cleanliness,
    ROUND(AVG(`Food and Drink`), 2) AS `Food and Drink`,
    ROUND(AVG(`In-flight Service`), 2) AS `In-flight Service`,
    ROUND(AVG(`In-flight Wifi Service`), 2) AS `In-flight Wifi Service`,
    ROUND(AVG(`In-flight Entertainment`), 2) AS `In-flight Entertainment`,
    ROUND(AVG(`Baggage Handling`), 2) AS `Baggage Handling`
FROM
    airline_reviews
WHERE
    Satisfaction = 'satisfied';



-- Does satisfaction differ for first-time vs returning customers?

SELECT 
    `customer type`, satisfaction, COUNT(*) AS passengers
FROM
    airline_reviews
GROUP BY `Customer Type` , Satisfaction
HAVING Satisfaction = 'satisfied';


-- Dissatisfaction Rates Across Age Groups

SELECT 
    `age group`,
    COUNT(*) AS passengers,
    COUNT(CASE
        WHEN Satisfaction = 'Neutral or Dissatisfied' THEN 1
    END) AS total,
    ROUND((100 * COUNT(CASE
                WHEN Satisfaction = 'Neutral or Dissatisfied' THEN 1
            END) / COUNT(*)),
            2) AS dissatisfaction_rate
FROM
    airline_reviews
GROUP BY `Age Group`
ORDER BY dissatisfaction_rate DESC;

-- How does Total Delay affect passenger satisfaction?

SELECT 
    `delay category`, COUNT(*) AS passenger
FROM
    airline_reviews
WHERE
    Satisfaction = 'satisfied'
GROUP BY `delay category`
ORDER BY passenger DESC;


-- Which Delay Category (On Time, Short, Moderate, Long) has the lowest satisfaction rate?

SELECT 
    `delay category`,
    COUNT(*) AS passenger,
    COUNT(CASE
        WHEN Satisfaction = 'satisfied' THEN 1
    END) AS total,
    ROUND((COUNT(CASE
                WHEN Satisfaction = 'satisfied' THEN 1
            END) * 100 / COUNT(*)),
            2) AS satisfaction_rate
FROM
    airline_reviews
GROUP BY `delay category`
ORDER BY Satisfaction_rate ASC;


-- What % of flights are On Time vs Delayed?

SELECT 
    COUNT(CASE
        WHEN `delay category` = 'on time' THEN 1
    END) AS on_time,
    COUNT(CASE
        WHEN
            `delay category` = 'short delay'
                OR `delay category` = 'moderate delay'
                OR `delay category` = 'long delay'
        THEN
            1
    END) AS delay,
    COUNT(*) AS passenger,
    ROUND((100 * COUNT(CASE
                WHEN `delay category` = 'on time' THEN 1
            END) / COUNT(*)),
            2) AS on_time_rate,
    ROUND((100 * COUNT(CASE
                WHEN
                    `delay category` = 'short delay'
                        OR `delay category` = 'moderate delay'
                        OR `delay category` = 'long delay'
                THEN
                    1
            END) / COUNT(*)),
            2) AS Delay_rate
FROM
    airline_REVIEWS	;


-- Do Business travelers tolerate delays better than Personal travelers?

SELECT 
    `type of travel`, `delay category`, COUNT(*) AS passengers
FROM
    airline_reviews
WHERE
    `type of travel` IN ('Business' , 'Personal')
        AND Satisfaction = 'satisfied'
GROUP BY `type of travel` , `delay category`
ORDER BY passengers DESC;


-- How does satisfaction vary across Age Group × Class × Travel Type?

SELECT 
    `age group`,
    class,
    `type of travel`,
    COUNT(CASE
        WHEN Satisfaction = 'satisfied' THEN 1
    END) AS satisfied,
    COUNT(CASE
        WHEN Satisfaction = 'Neutral or Dissatisfied' THEN 1
    END) AS dissatisfied
FROM
    airline_reviews
GROUP BY `age group` , class , `type of travel`;


-- Which combination of Customer Type and Class yields highest loyalty (satisfaction)?

SELECT 
    `customer type`,
    class,
    COUNT(CASE
        WHEN satisfaction = 'satisfied' THEN 1
    END) AS satisfied,
    COUNT(*) AS passenger,
    ROUND((COUNT(CASE
                WHEN satisfaction = 'satisfied' THEN 1
            END) * 100 / COUNT(*)),
            2) AS rate
FROM
    airline_reviews
GROUP BY `customer type` , class
ORDER BY rate DESC;

-- What % of flights are delayed more than 30 minutes?

SELECT 
    COUNT(CASE
        WHEN
            `delay category` = 'Moderate delay'
                OR `delay category` = 'long delay'
        THEN
            1
    END) AS delay,
    COUNT(*) AS passenger,
    ROUND((100 * COUNT(CASE
                WHEN
                    `delay category` = 'Moderate delay'
                        OR `delay category` = 'long delay'
                THEN
                    1
            END) / COUNT(*)),
            2) AS delay_percentage
FROM
    airline_reviews;