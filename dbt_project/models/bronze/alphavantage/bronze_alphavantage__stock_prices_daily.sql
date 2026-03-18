-- TRANSFORM
WITH source AS (

    SELECT
        date,
        symbol,
        open,
        high,
        low,
        close,
        volume
    FROM {{ source('landing_zone', 'alphavantage_stock_prices_daily') }}

)
-- LOAD
SELECT * FROM source