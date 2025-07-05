-- =============================================
-- CREATING DATABASE
-- =============================================
-- CREATE DATABASE swiggy_analytics;


-- Drop old
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Restaurants;

-- ===============================
-- Create Restaurants Table
-- ===============================
CREATE TABLE Restaurants (
  RestaurantID VARCHAR(50) PRIMARY KEY,
  Area VARCHAR(50),
  City VARCHAR(50),
  RestaurantName VARCHAR(100),
  Price FLOAT,
  AvgRating FLOAT,
  TotalRatings INT,
  FoodType TEXT,
  Address VARCHAR(200),
  DeliveryTimeMins INT
);

-- ===============================
-- Create Orders Table (matching CSV!)
-- ===============================
CREATE TABLE Orders (
  OrderID VARCHAR(50) PRIMARY KEY,
  RestaurantID VARCHAR(50) REFERENCES Restaurants(RestaurantID),
  TrafficLevel VARCHAR(20),
  Delivery_person_ID VARCHAR(50),
  WeatherDescription VARCHAR(50),
  Type_of_order VARCHAR(50),
  Type_of_vehicle VARCHAR(20),
  Delivery_person_Age INT,
  Delivery_person_Rating FLOAT,
  Restaurant_latitude VARCHAR(20),
  Restaurant_longitude VARCHAR(20),
  Delivery_location_latitude VARCHAR(20),
  Delivery_location_longitude VARCHAR(20),
  Temperature FLOAT,
  Humidity FLOAT,
  Precipitation FLOAT,
  Distance_km FLOAT,
  DeliveryTimeMins FLOAT
);

-- ===============================
-- Create Customers Table
-- ===============================
CREATE TABLE Customers (
  CustomerID SERIAL PRIMARY KEY,
  OrderID VARCHAR(50) REFERENCES Orders(OrderID),
  Age INT,
  AgeGroup VARCHAR(20),
  Gender VARCHAR(10),
  IncomeLevel VARCHAR(20),
  OrderFrequency VARCHAR(20),
  Location VARCHAR(50),
  PreferredCuisine VARCHAR(50)
);

-- ===============================
-- INSERT INTO Restaurants
-- ===============================
INSERT INTO Restaurants (RestaurantID, Area, City, RestaurantName, Price, AvgRating, TotalRatings, FoodType, Address, DeliveryTimeMins) VALUES
('316772', 'Madhavaram', 'Chennai', 'Idlicurry', 150.0, 4.0, 100, 'South Indian', 'Perambur', 66),
('118742', 'Isanpur', 'Ahmedabad', 'Kutchi Karnavati', 100.0, 3.5, 20, 'Fast Food,Pizzas,Chinese,Snacks', 'Isanpur', 43),
('280507', 'T. Nagar', 'Chennai', 'Courtyard By Marriott', 700.0, 4.3, 100, 'Biryani,Combo,Pizzas,Home Food,Indian,Continental', 'T Nagar', 67),
('54473', 'George Town', 'Chennai', 'Hotel Shiva Shagar', 450.0, 4.1, 100, 'Beverages,North Indian,South Indian', 'Park Town', 36),
('347069', 'Kothrud', 'Pune', 'Fried Chicken Destination', 200.0, 4.2, 500, 'Fast Food,American,Snacks', 'Kothrud', 58);

-- ===============================
-- INSERT INTO Orders
-- ===============================
INSERT INTO Orders (
  OrderID, RestaurantID, TrafficLevel, Delivery_person_ID, WeatherDescription, 
  Type_of_order, Type_of_vehicle, Delivery_person_Age, Delivery_person_Rating, 
  Restaurant_latitude, Restaurant_longitude, Delivery_location_latitude, 
  Delivery_location_longitude, Temperature, Humidity, Precipitation, 
  Distance_km, DeliveryTimeMins
) VALUES
('4FBB', '316772', 'Moderate', 'MYSRES15DEL01', 'clear sky', 'Drinks', 'scooter', 28, 4.8, '12.352.058', '7.660.665', '12.392.058', '7.664.665', 20.75, 67.0, 0.0, 10.51, 43.45),
('C6BB', '118742', 'Moderate', 'LUDHRES18DEL03', 'clear sky', 'Meal', 'scooter', 34, 5.0, '30.890.184', '75.829.615', '30.920.184', '75.859.615', 18.88, 57.0, 0.0, 5.97, 38.16),
('7172', '280507', 'High', 'INDORES14DEL02', 'clear sky', 'Buffet', 'motorcycle', 22, 3.5, '22.761.593', '75.886.362', '22.841.593', '75.966.362', 22.21, 44.0, 0.0, 14.73, 39.81),
('66B9', '54473', 'Moderate', 'BANGRES17DEL02', 'mist', 'Buffet', 'scooter', 28, 4.9, '12.972.532', '77.608.179', '13.022.532', '77.658.179', 19.40, 92.0, 0.0, 8.64, 35.46),
('3.00E+21', '347069', 'Moderate', 'MUMRES19DEL03', 'smoke', 'Buffet', 'motorcycle', 30, 4.6, '19.131.141', '72.813.074', '1.916.114', '72.843.074', 26.97, 44.0, 0.0, 7.29, 34.95);

-- ===============================
-- INSERT INTO Customers
-- ===============================
INSERT INTO Customers (OrderID, Age, AgeGroup, Gender, IncomeLevel, OrderFrequency, Location, PreferredCuisine) VALUES
('4FBB', 52, '46+', 'Female', 'Low', 'Low', 'Bangalore', 'Biryani'),
('C6BB', 21, '18-25', 'Female', 'High', 'Medium', 'Bangalore', 'Gujarati'),
('7172', 50, '46+', 'Male', 'Low', 'Low', 'Bangalore', 'North Indian'),
('66B9', 53, '46+', 'Female', 'Medium', 'High', 'Bangalore', 'Desserts'),
('3.00E+21', 18, '18-25', 'Female', 'Medium', 'Low', 'Bangalore', 'South Indian');



SELECT * FROM Customers;