-- TRANSFORM
WITH source AS (

    SELECT
        symbol,
        date,
        open AS open_price,
        high AS high_price,
        low AS low_price,
        close AS close_price,
        volume
    FROM {{ ref('bronze_alphavantage__stock_prices_daily') }}

),

typed AS (

    SELECT
        symbol,
        TO_DATE(date, 'YYYY-MM-DD') AS date,
        CAST(open_price AS NUMERIC(18,6)) AS open_price,
        CAST(high_price AS NUMERIC(18,6)) AS high_price,
        CAST(low_price AS NUMERIC(18,6)) AS low_price,
        CAST(close_price AS NUMERIC(18,6)) AS close_price,
        CAST(volume AS BIGINT) AS volume
    FROM source

)

-- LOAD
SELECT 
    * 
FROM 
    typed 
ORDER BY 
    symbol, 
    date