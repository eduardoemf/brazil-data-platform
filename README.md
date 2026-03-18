
# Finance Data Platform

An end-to-end data platform that ingests Brazilian public APIs and builds analytics-ready datasets using modern data stack tools.

## 🎯 Project Overview

This project demonstrates a complete data engineering workflow following the medallion architecture pattern:
- **Data Ingestion**: Brazilian market APIs (Alpha Vantage, BRAPI, Banco Central)
- **Data Warehouse**: PostgreSQL with structured layered schema (Bronze/Silver/Gold)
- **Data Transformation**: dbt for building analytics-ready datasets
- **Orchestration**: Python-based pipelines with data quality checks

## 🏗️ Architecture

```
APIs → Python Ingestion → PostgreSQL (Bronze) → dbt Transformations (Silver/Gold) → Analytics
```

### Medallion Layer Architecture

The platform follows a three-tier medallion architecture:

- **Bronze Layer**: Raw, unmodified data ingested directly from APIs. Serves as a single source of truth for all raw data with minimal transformations.
- **Silver Layer**: Cleaned, deduplicated, and standardized datasets. Data quality checks are applied, null values handled, and business logic begins to emerge.
- **Gold Layer**: Analytics-ready, aggregated datasets optimized for reporting and business intelligence. Contains calculated metrics, business dimensions, and KPIs ready for consumption.

### Tech Stack
- **Languages**: Python 3.12+, SQL
- **Data Processing**: dbt-core 1.11.7, dbt-postgres
- **Database**: PostgreSQL 16
- **Data Formats**: Pandas, DuckDB, SQLAlchemy
- **Infrastructure**: Docker Compose
- **Development**: uv (package manager), SQLFluff

## 📦 Project Structure

```
finance-data-platform/
├── ingestion/           # Python data pipeline layer
│   ├── data_fonts/     # API connectors
│   ├── pipelines/      # ETL workflows
│   └── utils/          # Database utilities
├── dbt_project/        # dbt transformation layer
│   ├── models/
│   │   ├── bronze/     # Raw data models
│   │   ├── silver/     # Cleaned & standardized datasets
│   │   └── gold/       # Business-ready analytics tables
│   ├── tests/          # Data quality tests
│   └── macros/         # Custom dbt functions
├── docker-compose.yml  # PostgreSQL + volume setup
└── pyproject.toml      # Dependencies management
```

## 🚀 Getting Started

### Prerequisites
- Python 3.12+
- Docker & Docker Compose
- uv (or pip)

### Enviroments
```bash
# Create virtual environment with uv
uv venv

# Activate (Linux/macOS)
source .venv/bin/activate

# Activate (Windows)
.venv\Scripts\activate
```

.env file:
```bash
ALPHA_API_KEY=""

DB_USER=""
DB_PASSWORD=""
DB_HOST=""
DB_PORT=""
DB_NAME=""
```

### Installation

```bash
# Install dependencies
uv sync

# Start PostgreSQL
docker-compose up -d

# Verify database connection
```

### Running the Pipeline

```bash
# Execute ingestion
python main.py

# Run dbt transformations
cd dbt_project
dbt run
dbt test

# Generate & serve documentation
python build.py
```

## 📊 Data Models

### Bronze Layer
Raw data ingested directly from APIs with minimal transformation. Acts as a data lakehouse for all source systems.

- `bronze_alphavantage__stock_prices_daily`: Raw stock price data (OHLCV data)
- `bronze_brapi__stock_prices_daily`: Brazilian stock prices from BRAPI
- `bronze__symbol_countries`: Raw symbol metadata and mappings

**Purpose**: Immutable historical record; enables audit trail and data recovery.

### Silver Layer
Cleaned, deduplicated, and validated datasets with applied business rules. Data quality checks ensure consistency.

- `silver_alphavantage__stock_prices_daily`: Deduplicated, cleaned stock prices with null handling
- `silver_brapi__stock_prices_daily`: Standardized Brazilian market prices
- `silver__symbol_countries`: Validated symbol reference data

**Purpose**: Standardized data foundation for analytics; single source of truth for trusted data.

### Gold Layer
Aggregated, business-ready analytics tables optimized for reporting and decision-making.

**Analytics Tables**:
- `gold_daily_returns`: Daily return calculations (absolute and percentage) aggregated by symbol
- `gold_market_indicators__economic`: Economic indicators from Banco Central (interest rates, inflation, exchange rates)
- `gold_market_performance__aggregated`: Market-wide performance metrics and indices

**Key Metrics & Aggregations**:
- Daily percentage returns and volatility calculations
- Market-wide price movements and trends
- Economic indicators time-series for correlation analysis
- Symbol-level performance rankings and comparisons

**Purpose**: Enable business stakeholders and analysts to quickly access pre-calculated metrics without complex joins; reduce query latency for reporting tools and dashboards.

## 🔑 Key Features

✅ Modular pipeline architecture  
✅ Comprehensive data lineage with dbt  
✅ Type-safe Python with modern tooling  
✅ Docker containerization  
✅ SQL linting with SQLFluff  
✅ Extensible data source framework  
✅ Automated data quality testing  
✅ Production-ready medallion architecture  

## 📝 Development

```bash
# Initial test dbt connection
dbt debug

# Run data quality tests
dbt test

# Run dbt transform
dbt run

# Generate documentation
dbt docs generate

# Serve documentation locally
dbt docs serve --port 8081

```

## 📮 Contact

Created for demonstration of data engineering best practices in modern analytics platforms.

