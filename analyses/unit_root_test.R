units <- pdf[!is.na(pdf$mdi)]

units<-aggregate(units$mdi, by=list(units$country), FUN=length)
units<-units[order(units$x),]

units<-subset(pdf, country=="Uruguay" |
                   country=="U.S.A" |
                country=="Switzerland" |
                country=="Sweden" |
                country=="Romania" |
                country=="Norway" |
                country=="Nicaragua" |
                country=="Netherlands" |
                country=="Mexico" |
                country=="Luxembourg" |
                country=="Ireland" |
                country=="Hungary" |
                country=="Honduras" |
                country=="Haiti" |
                country=="Gautemala" |
                country=="France" |
                country=="Finland" |
                country=="El Salvador" |
                country=="Dominican Republic" |
                country=="Denmark" |
                country=="Cuba" |
                country=="Costa Rica" |
                country=="China" |
                country=="Canada" |
                country=="Belgium" |
                country=="Afghanistan")
                

purtest(units$mdi, lags="AIC", exo = "trend", test = "levinlin")
purtest(units$mdi, lags="AIC", exo = "trend", test = "ips")

cipstest(units$mdi, type="trend")

subset(df, year==1945, select=c("country", "year", "mdi"))
