require(reshape2)
require(ggplot2)
require(psData)

################# LOAD/TRANSFORM CLEANED DATA

setwd("~/Dropbox/gh_projects/media_civil_war")
hist_intrastate<-read.csv("data/hist_intrastate.csv")
warren<-read.csv("data/warren.csv")
maddison<-read.csv("data/maddison.csv")

### Aggregate Warren data into yearly means

warren<-subset(warren, select=c("cowcode", "year", "mdi", "tvli", "radioli", "newsli"))
attach(warren)
warren <-aggregate(warren, by=list(year), 
                   FUN=mean, na.rm=TRUE)
detach(warren)
warren$Year<-warren$Group.1
warren$tvlong<-warren$tvli
warren$tvlong[warren$Year<=1944]<-0

### Merge Warren and Intra-state war data

globalmdi<-merge(hist_intrastate, warren, by=c("Year"), all.x=TRUE)
globalmdi.war<-globalmdi[,c("Year", "civil.wars", "mdi", "tvli", "radioli", "newsli", "tvlong")]
globalmdi.war$tvlong<-globalmdi.war$tvli
globalmdi.war$tvlong[1:129]<-0


### Load and aggregate cleaned historical GDP data from Maddison 

attach(maddison)
maddison <-aggregate(maddison, by=list(id), 
                     FUN=mean, na.rm=TRUE)
detach(maddison)

maddison$Year<-1816:2003

mdi.war.mad<-merge(globalmdi.war, maddison, by=c("Year"))

### Download Polity2

polity <- PolityGet(vars = "polity2")
polity<-subset(polity, year>=1816 & year<=2003)

attach(polity)
polity <-aggregate(polity, by=list(year), 
                   FUN=mean, na.rm=TRUE)
detach(polity)

polity$Year<-polity$year

historical<-merge(mdi.war.mad, polity, by=c("Year"))


longrun<-subset(historical, select=c("Year", "tvlong", "civil.wars", "gdppc", "polity2"))
longrun.unscaled<-subset(historical, select=c("Year", "tvlong", "civil.wars", "gdppc", "polity2"))
require(tseries)
adf.test(longrun.unscaled$civil.wars)

detach("package:Zelig", unload=TRUE)
require(arm)
longrun[c(2:length(names(longrun)))]<-sapply(longrun[c(2:length(names(longrun)))], function(x) rescale(x))

molten<-melt(longrun, id="Year")

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

longrun.plot<-ggplot(molten, aes(x=Year)) +
  geom_line(aes(y=value, colour=variable, linetype=variable)) +
  scale_colour_manual(values=cbbPalette) +
  labs(y="Z (standardized)") +
  theme_bw()

## Make subset for count models, standardizing all but civil war counts
modelvars<-subset(historical, select=c("Year", "tvlong", "civil.wars", "gdppc", "polity2"))
modelvars[c(2,4:length(names(modelvars)))]<-sapply(modelvars[c(2,4:length(names(modelvars)))], function(x) rescale(x))
detach("package:arm", unload=TRUE)

require(Zelig)


modelvars$d.civil.wars[2:184]<-diff(modelvars$civil.wars)
modelvars$ld.civil.wars[3:184]<-lag(modelvars$d.civil.wars)
modelvars$l.civil.wars[2:184]<-lag(modelvars$civil.wars)
modelvars$l2.civil.wars[3:184]<-lag(modelvars$civil.wars, lag=2)
modelvars$d.tvlong[2:184]<-diff(modelvars$tvlong)
modelvars$ld.tvlong[3:184]<-lag(modelvars$d.tvlong)
modelvars$l.tvlong[2:184]<-lag(modelvars$tvlong)

modelvars$l2.tvlong[3:184]<-lag(modelvars$tvlong, lag=2)
modelvars$d.gdppc[2:184]<-diff(modelvars$gdppc)
modelvars$ld.gdppc[3:184]<-lag(modelvars$d.gdppc)

modelvars$l.gdppc[2:184]<-lag(modelvars$gdppc)
modelvars$l2.gdppc[3:184]<-lag(modelvars$gdppc, lag=2)
modelvars$d.polity2[2:184]<-diff(modelvars$polity2)
modelvars$ld.polity2[3:184]<-lag(modelvars$d.polity2)

modelvars$l.polity2[2:184]<-lag(modelvars$polity2)
modelvars$l2.polity2[3:184]<-lag(modelvars$polity2, lag=2)

modelvars$l.polity2.2[2:184]<-lag(modelvars$polity2)*lag(modelvars$polity2)
modelvars$l2.polity2.2[3:184]<-lag(modelvars$polity2, lag=2)*lag(modelvars$polity2, lag=2)


modelvars[c(2,4:length(names(modelvars)))]<-sapply(modelvars[c(2,4:length(names(modelvars)))], function(x) x+abs(min(modelvars$polity2)))

modelvars<-modelvars[complete.cases(modelvars),]
modelvars$fortyfive<-ifelse(modelvars$Year==1945,1,0)
modelvars$ww2<-ifelse(modelvars$Year>=1939 & modelvars$Year>=1944,1,0)
modelvars$ww1<-ifelse(modelvars$Year>=1914 & modelvars$Year>=1918,1,0)

z.out<-zelig(civil.wars ~ d.gdppc + d.gdppc + l.tvlong +
                d.tvlong + l.polity2 +
                d.polity2 + l.civil.wars + d.civil.wars + Year +
                ww1 + ww2,
              model="negbinom",
              data=modelvars,
             cite=F)
summary(z.out)

# plot(z.out$result$fitted.values, z.out$result$residuals, )
# plot(z.out$result$residuals, z.out$result$y)


modelvars2<-longrun.unscaled
modelvars2$d.civil.wars[2:184]<-diff(modelvars2$civil.wars)
modelvars2$l.civil.wars[2:184]<-lag(modelvars2$civil.wars)
modelvars2$d.tvlong[2:184]<-diff(modelvars2$tvlong)
modelvars2$l.tvlong[2:184]<-lag(modelvars2$tvlong)
modelvars2$d.gdppc[2:184]<-diff(modelvars2$gdppc)
modelvars2$l.gdppc[2:184]<-lag(modelvars2$gdppc)
modelvars2$d.polity2[2:184]<-diff(modelvars2$polity2)
modelvars2$l.polity2[2:184]<-lag(modelvars2$polity2)
modelvars2$l2.polity2[2:184]<-lag(modelvars2$polity2)*lag(modelvars2$polity2)
modelvars2<-modelvars2[complete.cases(modelvars2),]

modelvars2$fortyfive<-ifelse(modelvars2$Year==1945,1,0)
modelvars2$ww2<-ifelse(modelvars2$Year>=1939 & modelvars2$Year>=1944,1,0)
modelvars2$ww1<-ifelse(modelvars2$Year>=1914 & modelvars2$Year>=1918,1,0)

z.out2<-zelig(civil.wars ~ d.gdppc + d.gdppc + l.tvlong +
               d.tvlong + l.polity2 +
               d.polity2 + l.civil.wars + d.civil.wars + Year +
               ww1 + ww2,
             model="negbinom",
             data=modelvars2,
             cite=F)
summary(z.out2)



