-- Part A: SQL using PostgreSQL/MS SQL Server (50 points)
---1.	Provide the key summary statistics of the data contained in the table by retrieving the number of distinct aircrafts,
----	total number of flights as well as a few statistics about flights departure delays (e.g., min, max & avg departure delays). 
SELECT
    COUNT(DISTINCT tail_number) AS distinct_aircrafts,  -- Number of distinct aircrafts
    COUNT(*) AS total_flights,                      -- Total number of flights
    MIN(departure_delay) AS min_departure_delay,          -- Minimum departure delay
    MAX(departure_delay) AS max_departure_delay,          -- Maximum departure delay
    AVG(departure_delay) AS avg_departure_delay           -- Average departure delay
FROM
    flights
WHERE
    year = 2015 AND month = 1;  -- Filter for January 2015

----2.	Create a view called FlightSummaryViewto display the date (e.g., 2015-01-01), iata_code, origin_airport, concatenated city, state, and country renamed as Address,
----	and the total number of flights departing from each airport for the first week of 2015.
----	Use the JOIN ON syntax and order by the iata_codein descending order (Make sure to add space between the address if required). 
CREATE VIEW FlightSummaryView AS
SELECT
	CONCAT(f.year, '-', f.month, '-', f.day) AS date,  -- Date of the flight
    --f.flight_date AS date,  -- Date of the flight
    a.iata_code,            -- IATA code of the airport
    f.origin_airport,       -- Origin airport code
    CONCAT(a.city, ', ', a.state, ', ', a.country) AS Address,  -- Concatenated address
    COUNT(*) AS total_flights  -- Total number of flights departing from the airport
FROM
    flights f
JOIN
    airports a ON f.origin_airport = a.iata_code  -- Join flights with airports on origin_airport
WHERE
    f.year = 2015 AND f.month = 1 AND f.day BETWEEN 1 AND 7  -- Filter for the first week of 2015
GROUP BY
    f.year, f.month, f.day, a.iata_code, f.origin_airport, a.city, a.state, a.country  -- Group by relevant columns
ORDER BY
    a.iata_code DESC;  -- Order by iata_code in descending order

SELECT * FROM FlightSummaryView

----3 Display the origin_airport, destination_airport, and rank for the top 3 routes departing from each airport
WITH RankedRoutes AS (
    SELECT
        origin_airport,
        destination_airport,
        COUNT(*) AS total_flights,  -- Total flights for each route
        ROW_NUMBER() OVER (  -- Rank routes for each origin airport
            PARTITION BY origin_airport
            ORDER BY COUNT(*) DESC
        ) AS route_rank
    FROM
        flights
    GROUP BY
        origin_airport, destination_airport  -- Group by origin and destination airports
)
SELECT
    origin_airport,
    destination_airport,
    route_rank
FROM
    RankedRoutes
WHERE
    route_rank <= 3  -- Filter for top 3 routes per origin airport
ORDER BY
    origin_airport, route_rank;  -- Order by origin airport and rank

----44.	Display the airport iata_code, airport name, airline iata_code, airline name, flight_number, tail_number, origin_airport, destination_airport, departure_time,
----	and arrival_timefor all flights that fly on weekends (Saturdays and Sundays) and landed between 4 and 5 am.
SELECT
    a.iata_code AS airport_iata_code,  -- Airport IATA code
    a.airport AS airport_name,            -- Airport name
    al.iata_code AS airline_iata_code, -- Airline IATA code
    al.airline AS airline_name,           -- Airline name
    f.flight_number,                   -- Flight number
    f.tail_number AS tail_number,          -- Tail number of the aircraft
    f.origin_airport,                  -- Origin airport code
    f.destination_airport,             -- Destination airport code
    f.departure_time AS departure_time,      -- Departure time
    f.arrival_time AS arrival_time         -- Arrival time
FROM
    flights f
JOIN
    airports a ON f.destination_airport = a.iata_code  -- Join with airports table
JOIN
    airlines al ON f.airline = al.iata_code  -- Join with airlines table
WHERE
    (f.day_of_week = 7 OR f.day_of_week = 1)  -- Weekend flights (Saturday = 7, Sunday = 1)
    AND f.arrival_time BETWEEN '0400' AND '0500';  -- Arrival time between 4 AM and 5 AM

----55.	All New York flights originate in one of 3 airports: ‘JFK’ (Kennedy), ‘LGA’ (La Guardia), and ‘EWR’ (Newark in New Jersey). Count how many flights originate at ‘JFK’.
----	Then show how many flights originate at ‘JFK’ as a percentage of all flights. (hint: use a WITH clause or a FROM subquery) 
SELECT
    jfk_flights,  -- Number of JFK flights
    ROUND((jfk_flights * 100.0 / total_flights), 2) AS jfk_percentage  -- Percentage of JFK flights
FROM
    (SELECT COUNT(*) AS jfk_flights FROM flights WHERE origin_airport = 'JFK') AS JFKFlights,
    (SELECT COUNT(*) AS total_flights FROM flights) AS TotalFlights;

----6.	Retrieve the flight information for all flights going into New York City, flying through any of its two airports (JFK and LGA) or into neighboring city’s airport New Jersey (Newark, EWR), where the elapsed time is greater than 500 mins.
----	Suppose we are told these flights are cancelled. Use this information directly in SQL to update their cancelled status from 0 to 1.
SELECT
    f.flight_number,  -- Assuming flight_id is the primary key
    f.origin_airport,
    f.destination_airport,
    f.elapsed_time,
    f.cancelled
FROM
    flights f
WHERE
    f.destination_airport IN ('JFK', 'LGA', 'EWR')  -- Flights going into JFK, LGA, or EWR
    AND f.elapsed_time > 500;  -- Elapsed time greater than 500 minutes

------Update Cancellation Status
UPDATE flights
SET cancelled = 1  -- Set cancelled status to 1
WHERE
    destination_airport IN ('JFK', 'LGA', 'EWR')  -- Flights going into JFK, LGA, or EWR
    AND elapsed_time > 500  -- Elapsed time greater than 500 minutes
    AND cancelled = 0;  -- Ensure only flights with cancelled = 0 are updated

----7.	Build a single temporary table called Departure_Delaysthat captures the categories of the departure_delaysof flights based on how many are ‘big,’ ‘medium,’ and ‘small’ delays.
----	Provide the iata_code, airline, departure delay category, and determine the total number of delays in each category. Order the result based on the total number of delays in descending order.
CREATE TEMPORARY TABLE Departure_Delays AS
SELECT
    a.iata_code,  -- Airline IATA code
    al.airline AS airline,  -- Airline name
    CASE
        WHEN f.departure_delay > 60 THEN 'big'
        WHEN f.departure_delay BETWEEN 30 AND 60 THEN 'medium'
        WHEN f.departure_delay BETWEEN 0 AND 29 THEN 'small'
        ELSE 'no delay'
    END AS delay_category,  -- Categorize departure delays
    COUNT(*) AS total_delays  -- Total number of delays in each category
FROM
    flights f
JOIN
    airlines al ON f.airline = al.iata_code  -- Join with airlines table
JOIN
    airports a ON f.origin_airport = a.iata_code  -- Join with airports table
WHERE
    f.departure_delay IS NOT NULL  -- Exclude flights with no delay information
GROUP BY
    a.iata_code, al.airline, delay_category  -- Group by airline and delay category
ORDER BY
    total_delays DESC;  -- Order by total delays in descending order

-------
SELECT *
FROM Departure_Delays;