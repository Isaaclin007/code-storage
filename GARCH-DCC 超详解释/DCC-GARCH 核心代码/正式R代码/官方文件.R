#需要安装的包列表
pkgs.vec<-c("PerformanceAnalytics","quantmod","rugarch","rmgarch")

#安装包
install.packages(pkgs.vec)

#加载包
library("PerformanceAnalytics")
library("quantmod")
library("rugarch")
library("rmgarch")

#证券代码，MSFT（微软）-^GSPC（标准普尔500指数）
symbol.vec = c("MSFT", "^GSPC")

#下载数据，from开始时间，to结束时间
getSymbols(symbol.vec, from ="2010-01-01", to = "2012-12-31")

#查看下载的数据基本信息
head(MSFT)
head(GSPC)

print(MSFT)
class(MSFT)
typeof(MSFT)

dim(MSFT)


#只保留.Adjusted列
MSFT = MSFT[, "MSFT.Adjusted", drop=F]
GSPC = GSPC[, "GSPC.Adjusted", drop=F]

#查看数据图像
plot(MSFT)
plot(GSPC)




#计算GARCH所需的对数收益率
MSFT.ret = CalculateReturns(MSFT, method="log")
GSPC.ret = CalculateReturns(GSPC, method="log")
head(MSFT.ret)
#只保留第2行后面的数据
MSFT.ret = MSFT.ret[-1,]
GSPC.ret = GSPC.ret[-1,]

#修改数据表变量名
colnames(MSFT.ret) ="MSFT"
colnames(GSPC.ret) = "GSPC"

# 产生合并数据表
MSFT.GSPC.ret = merge(MSFT.ret,GSPC.ret)

#查看合并表的前6行数据
head(MSFT.GSPC.ret)

# 查看收益率的图像
plot(MSFT.ret)
plot(GSPC.ret)

#两个收益率序列的散点图
plot( coredata(GSPC.ret), coredata(MSFT.ret), xlab="GSPC", ylab="MSFT",type="p", pch=16, lwd=2, col="blue")
abline(h=0,v=0)

#设定GARCH模型（均值模型，方程模型，分布模型）
garch11.spec = ugarchspec(mean.model = list(armaOrder = c(0,0)),variance.model = list(garchOrder = c(1,1),model = "sGARCH"),distribution.model = "norm")

#设定DCC模型
dcc.garch11.spec = dccspec(uspec = multispec( replicate(2, garch11.spec) ),dccOrder = c(1,1),distribution = "mvnorm")

#计算
dcc.fit = dccfit(dcc.garch11.spec, data = MSFT.GSPC.ret)

#计算结果
dcc.fit

#输出各种图形
plot(dcc.fit)

