-- Urban Retail Co. Inventory Optimization SQL Scripts

-- 1. TABLE CREATION
CREATE TABLE inventory_forecasting (
    date DATE,
    store_id VARCHAR(10),
    product_id VARCHAR(10),
    category VARCHAR(50),
    region VARCHAR(20),
    inventory_level INT,
    units_sold INT,
    units_ordered INT,
    demand_forecast FLOAT,
    price FLOAT,
    discount FLOAT,
    weather_condition VARCHAR(20),
    holiday_promotion BOOLEAN,
    competitor_pricing FLOAT,
    seasonality VARCHAR(20)
);

-- 2. CSV IMPORT
LOAD DATA LOCAL INFILE 'PS1 Inventory Forecasting.csv'
INTO TABLE inventory_forecasting
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date, store_id, product_id, category, region, inventory_level, units_sold, units_ordered, demand_forecast, price, discount, weather_condition, holiday_promotion, competitor_pricing, seasonality);

-- 3. ANALYTICS QUERIES

-- a. Stock Level Calculations
SELECT 
    store_id, 
    product_id, 
    SUM(inventory_level) AS total_inventory
FROM 
    inventory_forecasting
GROUP BY 
    store_id, product_id;

-- b. Low Inventory Detection (example threshold: 50)
SELECT 
    store_id, 
    product_id, 
    inventory_level
FROM 
    inventory_forecasting
WHERE 
    inventory_level < 50;

-- c. Inventory Turnover Analysis
SELECT 
    product_id,
    SUM(units_sold) / NULLIF(AVG(inventory_level), 0) AS inventory_turnover_ratio
FROM 
    inventory_forecasting
GROUP BY 
    product_id;

-- d. Summary Report with KPIs
SELECT
    product_id,
    COUNT(CASE WHEN inventory_level = 0 THEN 1 END) AS stockout_days,
    AVG(inventory_level) AS avg_inventory,
    AVG(price) AS avg_price,
    SUM(units_sold) AS total_units_sold
FROM
    inventory_forecasting
GROUP BY
    product_id;

-- e. Reorder Point Estimation (example: average daily sales * 7 days lead time)
SELECT
    product_id,
    AVG(units_sold) AS avg_daily_sales,
    ROUND(AVG(units_sold) * 7) AS estimated_reorder_point
FROM
    inventory_forecasting
GROUP BY
    product_id;

-- f. Fast-selling vs Slow-moving Products
SELECT
    product_id,
    SUM(units_sold) AS total_units_sold
FROM
    inventory_forecasting
GROUP BY
    product_id
ORDER BY
    total_units_sold DESC;

-- g. Inventory Age (days since last sale)
SELECT
    product_id,
    MAX(date) AS last_sale_date,
    DATEDIFF(CURDATE(), MAX(date)) AS days_since_last_sale
FROM
    inventory_forecasting
WHERE
    units_sold > 0
GROUP BY
    product_id; 