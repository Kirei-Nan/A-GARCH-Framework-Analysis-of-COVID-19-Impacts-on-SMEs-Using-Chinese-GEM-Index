# Libraries

library(forecast)
library(quantmod)
library(xts)
library(PerformanceAnalytics)
library(rugarch)

# Apple daily prices
sh<-read.table("C:/Users/14309/Desktop/project/sh.csv", header = T,sep = ',')
Sys.setlocale("LC_TIME","English")
xtssh<-xts(sh[2:6],as.Date(sh$date,format("%Y/%m/%d")))

#getSymbols("AAPL",from = "2008-01-01",to = "2019-12-31")

chartSeries(xtssh)

# Daily returns
return <- CalculateReturns(xtssh$close)
return <- return[-1]
return_clean<-tsclean(return)
hist(return_clean)
chart.Histogram(return_clean,
                methods = c('add.density', 'add.normal'),
                colorset = c('blue', 'green', 'red'))
chartSeries(return_clean)

# Annualized volatility
chart.RollingPerformance(R = return_clean["1991::2019"],
                         width = 252,
                         FUN = "sd.annualized",
                         scale = 252,
                         main = "SSEC's yearly rolling volatility")

# 1. sGARCH model with contant mean
s <- ugarchspec(mean.model = list(armaOrder = c(0,0)),
                variance.model = list(model = "sGARCH"),
                distribution.model = 'norm')
m <- ugarchfit(data = return, spec = s)
plot(m)
f <- ugarchforecast(fitORspec = m, n.ahead = 20)
plot(fitted(f))
plot(sigma(f))

# Application example - portfolio allocation
v <- sqrt(252) * sigma(m)
w <- 0.1/v
plot(merge(v, w), multi.panel = T)

# 2. GARCH with sstd
s <- ugarchspec(mean.model = list(armaOrder = c(0,0)),
                variance.model = list(model = "sGARCH"),
                distribution.model = 'sstd')
m <- ugarchfit(data = return, spec = s)
plot(m)

# 3. GJR-GARCH
s <- ugarchspec(mean.model = list(armaOrder = c(0,0)),
                variance.model = list(model = "gjrGARCH"),
                distribution.model = 'sstd')
m <- ugarchfit(data = return, spec = s)
plot(m)

#4. AR(1) GJR-GARCH
s <- ugarchspec(mean.model = list(armaOrder = c(1,0)),
                variance.model = list(model = "gjrGARCH"),
                distribution.model = 'sstd')
m <- ugarchfit(data = return, spec = s)
plot(m)

#5. GJR-GARCH in mean
s <- ugarchspec(mean.model = list(armaOrder = c(0,0),
                                  archm =T,
                                  archpow = 2),
                variance.model = list(model = "gjrGARCH"),
                distribution.model = 'sstd')
m <- ugarchfit(data = return, spec = s)
plot(m)

# Simulation
s <- ugarchspec(mean.model = list(armaOrder = c(0,0)),
                variance.model = list(model = "gjrGARCH"),
                distribution.model = 'sstd')
m <- ugarchfit(data = return, spec = s)
sfinal <- s
setfixed(sfinal) <- as.list(coef(m))

f2008 <- ugarchforecast(data = return["/2008-12"],
                        fitORspec = sfinal,
                        n.ahead = 252)
f2019 <- ugarchforecast(data = return["/2019-12"],
                        fitORspec = sfinal,
                        n.ahead = 252)
par(mfrow = c(1,1))
plot(sigma(f2008))
plot(sigma(f2019))

sim <- ugarchpath(spec = sfinal,
                  m.sim = 3,
                  n.sim = 1*252,
                  rseed = 123)
plot.zoo(fitted(sim))
plot.zoo(sigma(sim))
p <- 291.52*apply(fitted(sim), 2, 'cumsum') + 291.52
matplot(p, type = "l", lwd = 3)
