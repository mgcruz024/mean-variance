# Mean-Variance Portfolio Optimization with SP500 stocks
<img src="Screenshots/stocks_image.png" width="650" height="375" />


Mean-Variance portfolio optimization with six years of daily Yahoo Finance SP500 and SP500TR data from 2016-2021 (Q1 2021 for testing). The project aims to perform asset allocation considering a group of stock tickers and find an optimal portfolio for the target investor. Utilized PortfolioAnalytics on R with extracted datasets stored in PostgreSQL for selecting the best weight distribution of the selected tickers. Portfolio tested against the SP500TR index to evaluate 2021 performance. 

## Packages Used
PostgreSQL 14
- SQL
  
R 4.3.0
- PortfolioAnalytics
- ggplot2
- RPostgres
- DBI
- reshape2
- zoo


## ETL

<img src="Screenshots/etl_process.png" width="800" height="400" />

ETL initialized using three different datasets from a PostgreSQL stocks database:
- custom calendar - trading calendar; contains a previous trading day column for calculating daily returns.
- daily prices - SP500 end of day quotes.
- eod_indices - SP500TR end of day quotes.

Transformation
- Percentage of completeness (>= 99%) and outlier removal (daily return > 100%) enforced to assure data quality. 
- Imputed missing data items with the previous date's data. Up to three in a row were allowed to be imputed.

## Optimization 
<img src="Screenshots/portfolio.png" width="700" height="425" />

Optimization uses the minimum acceptable return of the SP500TR index for the 2016-2020 time period. Model reflects "shorts" with a negative weight (ex. AAPL, ADBE, ADP, and AMD) and those that have the highest fluctuations are the lower values. Largest portions of optimized portfolio are stable, low-risk leading companies (ex. PG, PGR, AMZN, and PEP) that provide reliable returns throughout the year. 

The sum of portfolio ticker weights are always equal to 1. 

<img src="Screenshots/annualized_returns.png" width="400" height="200" />







