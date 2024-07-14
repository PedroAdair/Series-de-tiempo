## ts vs zoo en series de  tiempo

library(readr)
#lectura de la base de datos de starbucs
sbux.df = sbuxPrices
View((sbux.df))
class((sbux.df))
sbux.ts = ts(data = sbux.df$Adj.Close,
             frequency = 12,
             start = c(1993,3),
             end = c(2008,3)) #convertir el datafrime en una seire de tiempo
class(sbux.ts)
plot(sbux.ts)
summary(sbux.ts)
### cargar los datos de mirosoft
msft.df = msftPrices
View((msft.df))
class((msft.df))
msft.ts = ts(data = msft.df$Adj.Close,
             frequency = 12,
             start = c(1993,3),
             end = c(2008,3)) #convertir el datafrime en una seire de tiempo
class(msft.ts)
plot(msft.ts)
summary(msft.ts)

#############################3
# metodos de la clase ts
#############################
#permite datos espaciados regulares, en meses o  años
#visualizar de forma matricial
start(sbux.ts)
sbux.ts
#obtener suvconjuntos
tmp =  sbux.ts[1:10] #los primeros 10 registros
class(tmp) #una lista, no una sub serie de tiempo (numeric)


tmp  = window(sbux.ts, start=c(1998,3), end = c(2000, 1))
tmp
class(tmp)

#combinar 2 series de tiempo
sbuxmsft.ts = cbind(sbux.ts, msft.ts)
sbuxmsft.ts
class(sbuxmsft.ts) #[1] "mts" (multiple time series)   "ts"     "matrix" "array" 

window(sbuxmsft.ts, start = c(2000,1), end = c(2002,1))
plot(sbux.ts, 
     col="blue",
     lwd = 1,
     ylab = "Adjusted close",
     main = "Monthly adjusted close price of SBUX")

#grafico sobre una sola parte del tiempo
plot(window(sbux.ts,start = c(2000,1), end = c(2008,12),) , 
     col="blue",
     lwd = 1,
     ylab = "Adjusted close",
     main = "Monthly adjusted close price of SBUX")

###multiples seres de tiempo

plot(sbuxmsft.ts) #en dos graficos separados

#un unico grafico
plot(sbuxmsft.ts,
     plot.type = "single",
     main = "SBUX vs MSFT monthly closed prices",
     ylab = "Adj close.price ",
     col = c("blue", "red"),
     lty =  1:2)
legend(1994,35, legend= c("SBUX", "MSFT"), col=c("blue", "red"), lty =1:2)
#############################3
# metodos de la clase zoo
#############################
library(zoo)
#tiene mayores libertades
td =  seq(as.Date("1993/3/31"), as.Date("2002/3/31"), "months") #crear una secuencia temporal
class(td)
#otra opcion usando el dataframe
td =  as.Date(sbux.df$Date, format = "%m/%d/%Y") #crear una secuencia temporal usando el df
#crear las series de itempo usando zoo
sbux.z =  zoo(x=sbux.df$Adj.Close, order.by = td)
msft.z =  zoo(x=msft.df$Adj.Close, order.by = td)

str(msft.z)
############################################
#Libreria Yahoo finance
library(tseries)
SBUX.z =  get.hist.quote(instrument = "sbux", 
                         start = "1993-03-01", 
                         end= "2024-07-14",
                         quote = c("AdjClose"),
                         provider = c("yahoo"),
                         compression = "d",
                         retclass = "zoo")

MSFT.z =  get.hist.quote(instrument = "msft", 
                         start = "1993-03-01", 
                         end= "2024-07-14",
                         quote = c("AdjClose"),
                         provider = c("yahoo"),
                         compression = "d",
                         retclass = "zoo")
#compresion, la regularidad de los datos, diario ("d"),semanal("w"),..
# retclass, lcase en la que retorna, como tiemseries (ts) o como zoo (zoo)
View(SBUX.z)
plot(cbind(SBUX.z, MSFT.z),
     plot.type = "single",
     main = "SBUX vs MSFT monthly closed prices",
     ylab = "Adj close.price ",
     col = c("blue", "red"),
     lty =  1:2)
legend(x="topleft", legend= c("SBUX", "MSFT"), col=c("blue", "red"), lty =1:2)
#### Mejorar la visualizacion
library(dygraphs)
dygraph(data = MSFT.z,
        main = "MSFT daily closed price")
#combinar las series
dygraph(data = cbind(MSFT.z, SBUX.z),
        main = "MSFT vs SBUXdaily closed price")
