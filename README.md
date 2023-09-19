# Mean-Variance Portfolio Optimization for SP500 stocks
<img src="Screenshots/stocks_image.png" width="650" height="375" />


Mean-Variance (MV) portfolio optimization with six years of daily SP500 data from 2016-2020 and Q1 2021 for testing. The project aims to perform asset allocation considering a group of stock tickers and find an optimal portfolio for the target investor. In order to select the best combination of those tickers, I performed analysis on R using extracted Yahoo finance data stored in PostgreSQL. 

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

To initialize the ETL, I utilized three different data sets from a database I created on PostgreSQL. 
- Custom calendar to reflect the trading days on NYSE for the desired date range, 01/01/2021-03/26/2021. Generated an additional column creating previous trading date for daily return calculations.
- 
. For the first data set regarding the custom calendar, we created a custom calendar to analyze the desired date range, 01/01/2021-03/26/2021. Accounting for holidays when banks were closed and not trading, the value of trading day results on any holidays coded to zero. The data needed to upload to a custom_calendar table linked to the stockmarket_gp database and one more customized column for the previous trading date. For the second data set regarding eod_quotes, the data needed to upload to an eod_quotes table in the stockmarket_gp database. For the third and final data set regarding eod_indices, a .csv file to upload to an eod_indices table in the stockmarket_gp database originating from Yahoo finance indices data in the desired date range.

## Optimization 
<img src="Screenshots/portfolio.png" width="500" height="400" />

Optimization uses the minimum acceptable return of the SP500TR index for the 2016-2020 time period. 







