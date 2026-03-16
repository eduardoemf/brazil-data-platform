# financial-data-platform
End-to-end data platform that ingests Brazilian public APIs and builds analytics-ready datasets using Python, PostgreSQL and DBT.

## Overview
This platform automates the ingestion of Brazilian financial and market data from public APIs, transforms it into structured datasets, and provides analytics-ready tables through a modern data stack architecture.

## Architecture
- **Ingestion Layer**: Python-based ETL pipelines extracting data from APIs (Banco Central Brasil, Stock Market Alpha)
- **Storage Layer**: PostgreSQL for persistent data storage
- **Transformation Layer**: DBT for data modeling and analytics preparation
- **Orquestration**: Airflow
- **Query Layer**: DuckDB and Pandas for data analysis

## Key Features
- Automated daily stock price ingestion
- Central Bank of Brazil economic indicators
- Modular pipeline structure for easy extension
- Type-safe Python 3.13+ codebase

## Getting Started

### Prerequisites
```
Python >=3.13
PostgreSQL database
```

### Installation
```bash
pip install -e .
```

### Running Pipelines
```bash
python main.py
```

## Project Structure
```
ingestion/          # Data extraction modules
├── data_fonts/     # API connectors
├── pipelines/      # Transformation logic
└── utils/          # Database utilities
```

## Dependencies
See `pyproject.toml` for full dependency list.


