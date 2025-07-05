-- ================================================
--  Queries for finding Real time Insights
-- ================================================

-- ================================================
--  Correlation: Avg Delivery Time vs Avg Rating
-- ================================================
WITH delivery_rating AS (
  SELECT
    r.RestaurantID,
    r.RestaurantName,
    r.AvgRating,
    AVG(o.DeliveryTimeMins) AS avg_delivery_time
  FROM Orders o
  JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
  GROUP BY r.RestaurantID, r.RestaurantName, r.AvgRating
)
SELECT *
FROM delivery_rating
ORDER BY avg_delivery_time DESC;

-- ================================================
--  Cuisine Ranking by Avg Rating (Window Function)
-- ================================================
SELECT
  FoodType,
  ROUND(AVG(AvgRating)::NUMERIC, 2) AS avg_rating,
  RANK() OVER (ORDER BY AVG(AvgRating) DESC) AS cuisine_rank
FROM Restaurants
GROUP BY FoodType;

-- ================================================
--  Top Cuisine in Each Region (Partition + Rank)
-- ================================================
WITH cuisine_region AS (
  SELECT
    City,
    FoodType,
    AVG(AvgRating) AS avg_rating
  FROM Restaurants
  GROUP BY City, FoodType
)
SELECT
  City,
  FoodType,
  ROUND(avg_rating::NUMERIC, 2) AS avg_rating,
  RANK() OVER (PARTITION BY City ORDER BY avg_rating DESC) AS rank_in_city
FROM cuisine_region
ORDER BY City, rank_in_city;

-- ================================================
--  Delivery Time Bands (CASE WHEN)
-- ================================================
SELECT
  OrderID,
  DeliveryTimeMins,
  CASE
    WHEN DeliveryTimeMins < 20 THEN '0-20 mins'
    WHEN DeliveryTimeMins BETWEEN 20 AND 30 THEN '21-30 mins'
    WHEN DeliveryTimeMins BETWEEN 31 AND 45 THEN '31-45 mins'
    ELSE '45+ mins'
  END AS delivery_band
FROM Orders;

-- ================================================
--  Avg Delivery Time by Region
-- ================================================
SELECT
  r.City,
  ROUND(AVG(o.DeliveryTimeMins)::NUMERIC, 2) AS avg_delivery_time
FROM Orders o
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
GROUP BY r.City
ORDER BY avg_delivery_time;

-- ================================================
--  Orders Count & Delivery by Cuisine (ROLLUP)
-- ================================================
SELECT
  r.FoodType,
  COUNT(o.OrderID) AS total_orders,
  ROUND(AVG(o.DeliveryTimeMins)::NUMERIC, 2) AS avg_delivery
FROM Orders o
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
GROUP BY ROLLUP (r.FoodType);

-- ================================================
--  High vs Low Income Segments (Chi-Square style)
-- ================================================
SELECT
  IncomeLevel,
  COUNT(*) AS num_customers
FROM Customers
GROUP BY IncomeLevel;

-- ================================================
--  Repeat Customers (HAVING)
-- ================================================
SELECT
  OrderID,
  COUNT(*) AS num_orders
FROM Customers
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- ================================================
--  Top 5 Fastest Restaurants (LIMIT)
-- ================================================
SELECT
  RestaurantName,
  ROUND(AVG(o.DeliveryTimeMins)::NUMERIC, 2) AS avg_delivery
FROM Orders o
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
GROUP BY r.RestaurantName
ORDER BY avg_delivery ASC
LIMIT 5;

-- ================================================
--  Avg Rating by AgeGroup (CTE + Join)
-- ================================================
WITH rating_age AS (
  SELECT
    c.AgeGroup,
    r.AvgRating
  FROM Customers c
  JOIN Orders o ON c.OrderID = o.OrderID
  JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
)
SELECT
  AgeGroup,
  ROUND(AVG(AvgRating)::NUMERIC, 2) AS avg_rating
FROM rating_age
GROUP BY AgeGroup
ORDER BY avg_rating DESC;

-- ================================================
--  Order Frequency by AgeGroup
-- ================================================
SELECT
  AgeGroup,
  OrderFrequency,
  COUNT(*) AS count_customers
FROM Customers
GROUP BY AgeGroup, OrderFrequency
ORDER BY AgeGroup, count_customers DESC;

-- ================================================
--  Which City is Best for New Cuisine (Opportunity)
-- ================================================
WITH city_perf AS (
  SELECT
    r.City,
    AVG(r.AvgRating) AS avg_rating,
    COUNT(DISTINCT r.RestaurantID) AS num_restaurants
  FROM Restaurants r
  GROUP BY r.City
)
SELECT
  City,
  ROUND(avg_rating::NUMERIC, 2) AS avg_rating,
  num_restaurants
FROM city_perf
WHERE num_restaurants < 5 AND avg_rating > 4.0;

-- ================================================
--  Highest Satisfaction Combo (Cuisine + Region)
-- ================================================
SELECT
  r.City,
  r.FoodType,
  ROUND(AVG(r.AvgRating)::NUMERIC, 2) AS avg_rating
FROM Restaurants r
GROUP BY r.City, r.FoodType
ORDER BY avg_rating DESC;

-- ================================================
--  Top Delivery Person Ratings (Insights)
-- ================================================
SELECT
  Delivery_person_ID,
  ROUND(AVG(Delivery_person_Rating)::NUMERIC, 2) AS avg_person_rating
FROM Orders
GROUP BY Delivery_person_ID
ORDER BY avg_person_rating DESC;

-- ================================================
--  Avg Delivery by Traffic Level
-- ================================================
SELECT
  TrafficLevel,
  ROUND(AVG(DeliveryTimeMins)::NUMERIC, 2) AS avg_delivery_time
FROM Orders
GROUP BY TrafficLevel
ORDER BY avg_delivery_time;

-- ================================================
--  Predict: What if we reduce delivery time by 10%
-- (Simple Calculation Example)
-- ================================================
SELECT
  ROUND(AVG(DeliveryTimeMins)::NUMERIC, 2) AS current_avg,
  ROUND((AVG(DeliveryTimeMins) * 0.9)::NUMERIC, 2) AS predicted_avg
FROM Orders;

-- ================================================
--  Orders by Weather Conditions
-- ================================================
SELECT
  WeatherDescription,
  COUNT(*) AS total_orders,
  ROUND(AVG(DeliveryTimeMins)::NUMERIC, 2) AS avg_delivery
FROM Orders
GROUP BY WeatherDescription;

-- ================================================
--  Customers by Preferred Cuisine
-- ================================================
SELECT
  PreferredCuisine,
  COUNT(*) AS num_customers
FROM Customers
GROUP BY PreferredCuisine
ORDER BY num_customers DESC;

-- ================================================
--  Distance vs Delivery Time
-- ================================================
SELECT
  Distance_km,
  DeliveryTimeMins
FROM Orders
ORDER BY Distance_km DESC;

-- ================================================
--  Highest Demand Cuisines in Bangalore
-- ================================================
SELECT
  PreferredCuisine,
  COUNT(*) AS demand_count
FROM Customers
WHERE Location = 'Bangalore'
GROUP BY PreferredCuisine
ORDER BY demand_count DESC;
