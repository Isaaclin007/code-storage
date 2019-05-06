pkgs.vec<-c("PerformanceAnalytics","quantmod","rugarch","rmgarch")
install.packages(pkgs.vec)
library("PerformanceAnalytics")
library("quantmod")
library("rugarch")
library("rmgarch")
install.packages('xlsx')
library(xlsx)
install.packages("xts")
install.packages('zoo')
library(zoo)
library(xts)
install.packages("readxl")
library(readxl)
#library("reshape2")
#library("ggplot2")
#install.packages("dplyr")
#library("dplyr")

#需要安装的包列表
pkgs.vec<-c("PerformanceAnalytics","quantmod","rugarch","rmgarch","xts",'zoo')

#安装包
install.packages(pkgs.vec)

#加载包
library("PerformanceAnalytics")
library("quantmod")
library("rugarch")
library("rmgarch")
library(zoo)
library(xts)

symbol.vec = c("COMM", "SP500")

setwd(getwd())


#,row.names = 1
COMM<- read.csv(file="bcom.csv", header=TRUE, sep=",",row.names = 1)
SP500<- read.csv(file="spx.csv", header=TRUE, sep=",",row.names = 1)
SP500 = as.xts(SP500)
COMM = as.xts(COMM)



COMM.ret = COMM[, "bcom_close", drop=F]
SP500.ret = SP500[, "spx_close", drop=F]



COMM.ret = CalculateReturns(COMM, method="log")
SP500.ret = CalculateReturns(SP500, method="log")

COMM.ret = COMM.ret[-1,]
SP500.ret = SP500.ret[-1,]





SP500.COMM.ret = merge(COMM.ret,SP500.ret)




plot(SP500.COMM.ret)



plot( coredata(COMM.ret), coredata(SP500.ret), xlab="COMM", ylab="SP500",type="p", pch=16, lwd=2, col="blue")
abline(h=0,v=0)


garch11.spec = ugarchspec(mean.model = list(armaOrder = c(0,0)),variance.model = list(garchOrder = c(1,1),model = "sGARCH"),distribution.model = "norm")


dcc.garch11.spec = dccspec(uspec = multispec( replicate(2, garch11.spec) ),dccOrder = c(1,1),distribution = "mvnorm")


dcc.fit = dccfit(dcc.garch11.spec, data = SP500.COMM.ret)
print(dcc.fit)

plot(dcc.fit)

