-- TRANSFORM
WITH source AS (

    SELECT
        CAST(symbol AS VARCHAR) AS symbol,
        CAST(country AS VARCHAR) AS country
    FROM {{ ref('bronze__symbol_countries') }}

)
-- LOAD
SELECT * FROM source