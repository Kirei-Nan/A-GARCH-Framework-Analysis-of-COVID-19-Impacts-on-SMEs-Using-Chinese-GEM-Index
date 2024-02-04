# Libraries
library(conflicted)
library(Hmisc)
library(quantmod)
library(xts)
library(zoo)
library(PerformanceAnalytics)
library(rugarch)
library(parallel)
# Shanghai securities daily prices
getSymbols("AAPL")
chartSeries(AAPL)

# Daily returns
return <- CalculateReturns(AAPL$AAPL.Close)
return <- return[-1]
hist(return)
chart.Histogram(return,
                methods = c('add.density', 'add.normal'),
                colorset = c('blue', 'green', 'red'))
#blue is histogram, green is density, red is normal
chartSeries(return)

# Annualized volatility
chart.RollingPerformance(R = return["2008::2019"],
                         width = 252,
                         FUN = "sd.annualized",
                         scale = 252,
                         main = "Apple's yearly rolling volatility")

# 1. sGARCH model with contant mean
s <- ugarchspec(mean.model = list(armaOrder = c(0,0)),
                variance.model = list(model = "sGARCH"),
                distribution.model = 'norm')
m <- ugarchfit(data = return, spec = s)
plot(m,which='all')
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
