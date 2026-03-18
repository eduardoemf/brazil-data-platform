from __future__ import annotations

import os
import time
from typing import List

import duckdb
import pandas as pd
from dotenv import load_dotenv
import logging

from ingestion.utils.db_insert_data import ingest_dataframe
from ingestion.utils.db_read_data_to_dataframe import read_sql_to_dataframe
from ingestion.data_fonts.mercado_de_acoes_alpha import api_symbol_daily

logger = logging.getLogger(__name__)


def _load_api_key() -> str:
    """Carrega a chave da API Alpha Vantage do ambiente.

    Returns:
        str: Chave da API.

    Raises:
        ValueError: Caso a variável de ambiente não esteja definida.
    """
    load_dotenv()
    api_key: str | None = os.getenv("ALPHA_API_KEY")

    if api_key is None:
        raise ValueError("ALPHA_API_KEY NÃO DEFINIDA NO AMBIENTE.")

    return api_key


def _get_existing_records() -> pd.DataFrame:
    """Obtém os registros já carregados no banco.

    Returns:
        pd.DataFrame: DataFrame contendo (date, symbol) já existentes.
    """
    query = """
        SELECT DISTINCT date, symbol
        FROM landing_zone.alphavantage_stock_prices_daily
        ORDER BY date DESC
        LIMIT 100
    """

    try:
        df_db: pd.DataFrame = read_sql_to_dataframe(query=query)

        # OTIMIZAÇÃO DE MEMÓRIA
        df_db["symbol"] = df_db["symbol"].astype("category")

        logger.info(msg='Há dados prévios no banco. Fazendo carga incremental...')

        return df_db

    except:
        # CASO A TABELA AINDA NÃO EXISTA
        logger.error(msg='Não há dados prévios no banco. Fazendo carga completa...')
        return pd.DataFrame(columns=["date", "symbol"])


def _filter_new_rows(
    df_api: pd.DataFrame,
    df_db: pd.DataFrame,
) -> pd.DataFrame:
    """Filtra apenas registros ainda não presentes no banco.

    Args:
        df_api: Dados retornados pela API.
        df_db: Dados já presentes no banco.

    Returns:
        pd.DataFrame: Apenas registros novos.
    """
    if df_db.empty:
        return df_api

    con = duckdb.connect()

    con.register("df_api", df_api)
    con.register("df_db", df_db)

    df_new: pd.DataFrame = con.execute(
        """
        SELECT a.*
        FROM df_api a
        LEFT JOIN df_db b
        USING (date, symbol)
        WHERE b.date IS NULL
        """
    ).fetchdf()

    return df_new


def stock_prices_daily(symbols: List[str] | None = None) -> None:
    """Executa ingestão incremental de preços diários de ações.

    A função consulta a API Alpha Vantage, identifica registros novos
    e realiza carga incremental na landing zone.

    Args:
        symbols: Lista de tickers a serem coletados.
    """
    api_key: str = _load_api_key()

    if symbols is None:
        symbols = ["NVDA", "MSFT", "AAPL", "ITUB4.SA", "PETR4.SA"]

    df_db: pd.DataFrame = _get_existing_records()

    for symbol in symbols:
        print("=" * 60)
        print(f"ACAO: {symbol}")
        print("=" * 60)

        df_api: pd.DataFrame = api_symbol_daily.extract_api_alpha_daily(
            api_key=api_key,
            symbol=symbol,
            outputsize="compact",
        )

        df_new: pd.DataFrame = _filter_new_rows(df_api, df_db)

        if df_new.empty:
            print("NENHUM NOVO REGISTRO.")
            continue

        ingest_dataframe(
            df=df_new,
            table_name="alphavantage_stock_prices_daily",
            schema="landing_zone",
            if_exists="append",
        )

        # RESPEITA RATE LIMIT DA API
        time.sleep(2)