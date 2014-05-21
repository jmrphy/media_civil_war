# subset with no missing values
unit <- pdf[!is.na(pdf$mdi)]

# obtain number of time periods per country
unit<-aggregate(unit$mdi, by=list(unit$country), FUN=length)

# order to identify countries with longest time-series
unit<-unit[order(unit$x),]

# subset to only countries with longest panels (55 years)
unit<-subset(pdf, country=="Uruguay" |
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

# count number of countries
unitn<-length(unique(unit$country))

# make list of countries
unitcountry<-unique(as.character(unit$country))
                
# run levin-lin-chu test
levinlin<-purtest(unit$mdi, lags="AIC", exo = "trend", test = "levinlin")

# save p.value
levinlin.p<-levinlin$statistic$p.value

# run i-p-s test
ips<-cipstest(unit$mdi, type="trend")

# save p.value
ips.p<-ips$p.value

