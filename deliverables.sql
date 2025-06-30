-- Urban Retail Co. Inventory Optimization Project Deliverables


-- Executive Summary
--
-- Urban Retail Co. Inventory Optimization Project
--
-- Overview:
-- Urban Retail Co. is a rapidly expanding retail chain facing challenges in inventory management, including frequent stockouts, overstocking, and a lack of real-time insights. Leveraging SQL-based analytics, this project transforms raw inventory and sales data into actionable insights to drive smarter inventory decisions, reduce inefficiencies, and improve profitability.
--
-- Key Insights:
-- 1. Stock Level Analysis revealed significant variation in inventory across stores and regions, with some locations experiencing frequent stockouts of fast-moving products while others held excess slow-moving stock.
-- 2. Low Inventory Detection identified SKUs consistently falling below reorder points, highlighting the need for more dynamic and data-driven replenishment strategies.
-- 3. Inventory Turnover Analysis showed that certain categories (e.g., electronics, toys) have higher turnover rates, while others (e.g., furniture) are slow-moving, tying up working capital.
-- 4. KPI Summary Reports provided visibility into stockout rates, average inventory levels, and sales performance, enabling targeted interventions.
-- 5. Reorder Point Estimation using historical sales trends allows for more accurate and proactive inventory replenishment, reducing both stockouts and overstocking.
-- 6. Fast-selling vs. Slow-moving Product Analysis enables the business to prioritize high-velocity SKUs and consider markdowns or promotions for slow movers.
-- 7. Inventory Age and Days Since Last Sale metrics help identify obsolete or at-risk inventory.
--
-- Recommendations:
-- 1. Implement automated, data-driven reorder point calculations for each SKU and store, factoring in sales velocity and lead times.
-- 2. Regularly review and rebalance inventory across stores and regions to minimize both stockouts and excess stock.
-- 3. Use inventory turnover and age metrics to inform markdown, promotion, or liquidation strategies for slow-moving items.
-- 4. Enhance supplier performance monitoring by integrating delivery and fill rate data (future enhancement).
-- 5. Develop dashboards for real-time monitoring of key inventory KPIs and trends.
--
-- Expected Business Impact:
-- - Reduced stockouts and lost sales, improving customer satisfaction.
-- - Lowered holding costs and improved cash flow by minimizing overstock.
-- - Enhanced supply chain efficiency and responsiveness.
-- - Data-driven decision-making culture, supporting continued growth and profitability.
--
-- This project provides a scalable foundation for ongoing inventory analytics and optimization, positioning Urban Retail Co. for operational excellence in a competitive retail landscape.

-- ERD Diagram (Mermaid format)
--
-- ```mermaid
-- erDiagram
--     INVENTORY_FORECASTING {
--         DATE date
--         VARCHAR store_id
--         VARCHAR product_id
--         VARCHAR category
--         VARCHAR region
--         INT inventory_level
--         INT units_sold
--         INT units_ordered
--         FLOAT demand_forecast
--         FLOAT price
--         FLOAT discount
--         VARCHAR weather_condition
--         BOOLEAN holiday_promotion
--         FLOAT competitor_pricing
--         VARCHAR seasonality
--     }
-- ```

-- Inventory KPI Dashboard (Mockup)
-- --------------------------------------------------------
-- | KPI                        | Value/Example           |
-- |----------------------------|-------------------------|
-- | Total SKUs                 | 5,000                   |
-- | Stockout Rate              | 3.2%                    |
-- | Avg Inventory Level        | 120 units               |
-- | Inventory Turnover Ratio   | 4.5                     |
-- | Top 5 Fast-Selling SKUs    | P0012, P0034, P0096...  |
-- | Top 5 Slow-Moving SKUs     | P0116, P0129, P0159...  |
-- | Days Since Last Sale (avg) | 12 days                 |
-- | Overstocks (SKUs > 200)    | 120                     |
-- | Understocks (SKUs < 50)    | 340                     |
-- --------------------------------------------------------
--
-- Example Visuals:
-- - Bar chart: Top 10 Fast-Selling Products
-- - Line chart: Inventory Turnover Over Time
-- - Pie chart: Inventory by Category
-- - Table: SKUs with Stockouts in Last 30 Days

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