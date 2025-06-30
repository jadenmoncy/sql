# Entity Relationship Diagram (ERD)

```mermaid
erDiagram
    INVENTORY_FORECASTING {
        DATE date
        VARCHAR store_id
        VARCHAR product_id
        VARCHAR category
        VARCHAR region
        INT inventory_level
        INT units_sold
        INT units_ordered
        FLOAT demand_forecast
        FLOAT price
        FLOAT discount
        VARCHAR weather_condition
        BOOLEAN holiday_promotion
        FLOAT competitor_pricing
        VARCHAR seasonality
    }
``` 