-- TRANSFORM
WITH source AS (

    SELECT
        symbol,
        country
    FROM {{ source('landing_zone', 'csv_symbol_countries') }}

)
-- LOAD
SELECT * FROM source