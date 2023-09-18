
rm(list=ls(all=T)) 

# Tabular Return Data Analytics

# 'SP500TR' and chosen tickers. 
require(PerformanceAnalytics)
require(PortfolioAnalytics)
require(ROI) 
require(ROI.plugin.quadprog)

# Convert data frames to xts (extensible time series)
Ra<-as.xts(eod_ret[,c("PEP","PG","PGR","AAPL","AMZN","AMD","ADP",
"ADBE","ABBV","CRY","CSCO","CPA"),drop=F])


Rb<-as.xts(eod_ret[,'SP500TR',drop=F]) #benchmark

#check
head(Ra)
tail(Ra)
ncol(Ra)

head(Rb)
tail(Rb)


# MV Portfolio Optimization -----------------------------------------------

# withhold the last 58 trading days (Jan 2016 to Dec 2020)
Ra_training<-head(Ra,-58)
nrow(Ra_training)
Rb_training<-head(Rb,-58)
nrow(Rb_training)


# use the last 58 trading days for testing (Jan 2021 to Mar 2021)
Ra_testing<-tail(Ra,58)
Rb_testing<-tail(Rb,58)

# optimize the MV (Markowitz 1950s) portfolio weights based on training

table.AnnualizedReturns(Ra_training)
mar_ra<-mean(Ra_training) #daily minimum acceptable return for our stocks during Range 1

table.AnnualizedReturns(Rb_training)
mar_rb<-mean(Rb_training) #daily minimum acceptable return for SP500TR during Range 1


# Cumulative return chart for 2016-2020

chart.CumReturns(Ra_training,legend.loc = 'topleft')


# Weights of optimized portfolio and the sum of these weights based on 2016-2020

pspec<-portfolio.spec(assets=colnames(Ra_training))
pspec<-add.objective(portfolio=pspec,type="risk",name='StdDev')
pspec<-add.constraint(portfolio=pspec,type="full_investment")
pspec<-add.constraint(portfolio=pspec,type="return",return_target=mar_rb)

# optimize portfolio for Jan 2016 to Dec 2020
opt_p<-optimize.portfolio(R=Ra_training,portfolio=pspec,optimize_method = 'ROI', digits=4)
opt_w<-round(opt_p$weights, digits = 4) #optimum weights
sum(opt_p$weights)


# Cumulative return chart for optimized portfolio and SP500TR index for all available
# 2021 data 
           
Rp<-Rb_testing # easier to apply the existing structure
#define new column that is the dot product of the two vectors
Rp$Portfolio<-Ra_testing %*% opt_w

chart.CumReturns(Rp,legend.loc = 'bottomright')

# Annualized returns for portfolio and SP500TR index for 2021 data 

table.AnnualizedReturns(Rp)





