pkgs.vec<-c("PerformanceAnalytics","quantmod","rugarch","rmgarch")
install.packages(pkgs.vec)
library("PerformanceAnalytics")
library("quantmod")
library("rugarch")
library("rmgarch")
library("reshape2")
library("ggplot2")
#install.packages("dplyr")
#library("dplyr")
symbol.vec = c("COMM", "SP500")

setwd("C:/Users/apple/Desktop")


COMM <- read.csv(file="BCOMIndex.csv", header=TRUE, sep=",",row.names = 1)
SP500<- read.csv(file="SPXIndex.csv", header=TRUE, sep=",",row.names = 1)
head(COMM)
head(SP500)
#symbol1.vec = c("MSFT", "^GSPC")
#A<-getSymbols(symbol1.vec, from ="2010-01-01", to = "2012-12-31")
#COMM$Date = strptime(COMM$Date,"%d-%m-%Y")
#COMM$Date <- strptime(as.character(COMM$Date), "%d/%m/%Y")

#head(COMM)
#head(SP500)
COMM = COMM[, "PX_LAST", drop=F]
SP500 = SP500[, "PX_LAST", drop=F]

#COMM = subset(COMM, select=c("Date", "PX_LAST"))
#SP500 = subset(SP500, select=c("Date", "PX_LAST"))

#head(COMM)
#head(SP500)

#plot(COMM)
#plot(SP500)

COMM.ret = CalculateReturns(COMM, method="log")
SP500.ret = CalculateReturns(SP500, method="log")
#plot(COMM.ret)
#plot(COMM.ret$PX_LAST)

COMM.ret = COMM.ret[-1,]
SP500.ret = SP500.ret[-1,]


#colnames(COMM.ret) ="COMM"
#colnames(SP500.ret) = "SP500"


SP500.COMM.ret = merge(COMM.ret,SP500.ret)


head(COMM.SP500.ret)

#plot(COMM.SP500.ret)
#plot(GSPC.ret)


plot( coredata(COMM.ret), coredata(SP500.ret), xlab="COMM", ylab="SP500",type="p", pch=16, lwd=2, col="blue")
abline(h=0,v=0)


garch11.spec = ugarchspec(mean.model = list(armaOrder = c(0,0)),variance.model = list(garchOrder = c(1,1),model = "sGARCH"),distribution.model = "norm")


dcc.garch11.spec = dccspec(uspec = multispec( replicate(2, garch11.spec) ),dccOrder = c(1,1),distribution = "mvnorm")


dcc.fit = dccfit(dcc.garch11.spec, data = SP500.COMM.ret)