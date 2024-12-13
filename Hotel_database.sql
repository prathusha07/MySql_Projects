create database hotel;
use hotel;

/* Table creation */
CREATE TABLE zomato (
  RestID int PRIMARY KEY,
  RestaurantName varchar(255) NOT NULL,
  CountryCode int,
  City varchar(255) NOT NULL,
  Address varchar(255) NOT NULL,
  Locality varchar(255),
  LocalityVerbose varchar(255),
  Cuisines varchar(255),
  Currency varchar(255) NOT NULL,
  Has_Table_booking varchar(3) NOT NULL,
  Has_Online_delivery varchar(3) NOT NULL,
  Is_delivering_now varchar(3) NOT NULL,
  Switch_to_order_menu varchar(3) NOT NULL,
  Price_range int,
  Votes int,
  Average_Cost_for_two int,
  Rating decimal(2,1)
);

describe zomato;

show tables;

/* Adding additional columns */
alter table zomato
add column S_no int unique auto_increment first;

alter table zomato
add column Datekey_Opening date;

alter table zomato
add column country_name varchar(30) after CountryCode;

/* inserting values */
INSERT INTO zomato (RestID, RestaurantName, CountryCode, country_name, City, Address, Locality, LocalityVerbose, Cuisines, Currency, Has_Table_booking, Has_Online_delivery, Is_delivering_now, Switch_to_order_menu, Price_range, Votes, Average_Cost_for_two, Rating,Datekey_Opening)
VALUES
  (6317637, 'Le Petit Souffle', 162,'Philippines', 'Makati City', 'Third Floor| Century City Mall| Kalayaan Avenue| Poblacion| Makati City', 'Poblacion', 'Makati City,Century City Mall| Poblacion| Makati City,Century City Mall| Poblacion| Makati City', 'French| Japanese| Desserts', 'Botswana Pula(P)', 'Yes', 'No', 'No', 'No', 3, 314, 1100, 4.8,"2016-08-12"),
  (6304287, 'Izakaya Kikufuji', 162,'Philippines', 'Makati City', 'Little Tokyo| 2277 Chino Roces Avenue| Legaspi Village| Makati City', 'Legaspi Village', 'Makati City,Little Tokyo| Legaspi Village| Makati City,Little Tokyo| Legaspi Village| Makati City', 'Japanese', 'Botswana Pula(P)', 'Yes', 'No', 'No', 'No', 3, 591, 1200, 4.5,"2017-09-18");

/* Query 1: select all columns from zomato */
select * from zomato;

/* Query 2: rolling/moving count of Restaurants in UAE cities */
/* Option 1: Window Function with rows clause */
SELECT COUNTRY_NAME, City, Locality, COUNT(Locality) AS TOTAL_REST,
SUM(COUNT(Locality)) OVER (PARTITION BY City ROWS 2 PRECEDING) AS ROLLING_COUNT
FROM zomato
WHERE COUNTRY_NAME = 'UAE'
GROUP BY COUNTRY_NAME, City, Locality;

/* Option 2: Simple rank-based count */
SELECT COUNTRY_NAME, City, Locality, COUNT(Locality) AS TOTAL_REST,
       DENSE_RANK() OVER (PARTITION BY City ORDER BY Locality DESC) AS RANK_COUNT
FROM Zomato
WHERE COUNTRY_NAME = 'UAE'
GROUP BY COUNTRY_NAME, City, Locality;

/* Query 4: view creation (Total_count)*/
create view Total_count as
select city, count(city) as count_city, country_name, sum(count(city)) over() as total_rest
from zomato
group by country_name, city;

/* percentage of restaurants for each country using CTE */
WITH CT1 AS (
  SELECT COUNTRY_NAME, COUNT(RestID) as REST_COUNT
  FROM Zomato
  GROUP BY COUNTRY_NAME
)
SELECT distinct A.COUNTRY_NAME, A.REST_COUNT,B.total_rest,
       ROUND(A.REST_COUNT / B.TOTAL_REST * 100, 2) AS PERCENTAGE
FROM CT1 A
JOIN TOTAL_COUNT B 
ON A.COUNTRY_NAME = B.COUNTRY_NAME;

/* percentage of restaurants for each city using CTE */
WITH CT1 AS (
  SELECT country_name, COUNT(RestID) as REST_COUNT
  FROM Zomato
  group by country_name
)
SELECT B.COUNTRY_NAME, B.city, B.count_city, A.rest_count,
       round((B.count_city / A.REST_COUNT) * 100,2) AS PERCENTAGE
FROM CT1 as A
JOIN TOTAL_COUNT as B 
ON A.COUNTRY_NAME = B.COUNTRY_NAME;
