-- models/gold/mercado_acoes/gold_daily_returns.sql

{{
  config(
    materialized = 'table',
    schema       = 'gold',
    tags         = ['mercado_acoes', 'daily']
  )
}}

with source as (

    select
        sp.symbol,
        sc.country,
        sp.date,
        sp.open_price,
        sp.high_price,
        sp.low_price,
        sp.close_price,
        sp.volume,
        lag(sp.close_price) over (
            partition by sp.symbol
            order by sp.date
        ) as prev_close_price

    from {{ ref('silver_alphavantage__stock_prices_daily') }} sp
    left join {{ ref('silver__symbol_countries') }}            sc
           on sp.symbol = sc.symbol

),

daily_returns as (

    select
        symbol,
        country,
        date,
        open_price,
        high_price,
        low_price,
        close_price,
        volume,
        prev_close_price,

        -- Retorno aritmético simples
        round(
            (close_price - prev_close_price) / nullif(prev_close_price, 0),
            6
        ) as daily_return,

        -- Retorno logarítmico (preferível para cálculos acumulados)
        round(
            ln(close_price / nullif(prev_close_price, 0)),
            6
        ) as log_return,

        -- Variação intraday (high - low) / open
        round(
            (high_price - low_price) / nullif(open_price, 0),
            6
        ) as intraday_range

    from source
    where 
        prev_close_price is not null  -- descarta o primeiro dia de cada ativo

)

select
    symbol,
    country,
    date,
    open_price,
    high_price,
    low_price,
    close_price,
    volume,
    daily_return,
    log_return,
    intraday_range,

    -- Retorno acumulado desde o início da série (via log_return)
    round(
        exp(
            sum(log_return) over (
                partition by symbol
                order by date
                rows between unbounded preceding and current row
            )
        ) - 1,
        6
    ) as cumulative_return,

    -- Retorno acumulado dos últimos 30 dias
    round(
        exp(
            sum(log_return) over (
                partition by symbol
                order by date
                rows between 29 preceding and current row
            )
        ) - 1,
        6
    ) as rolling_30d_return,

    -- Retorno acumulado dos últimos 365 dias
    round(
        exp(
            sum(log_return) over (
                partition by symbol
                order by date
                rows between 364 preceding and current row
            )
        ) - 1,
        6
    ) as rolling_365d_return

from daily_returns
order by symbol, date