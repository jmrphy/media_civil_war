require(reshape2)
require(ggplot2)
require(psData)
require(arm)
require(lmtest)
source("~/Dropbox/R Code/shift.R")

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
globalmdi.war<-globalmdi[,c("Year", "civil.wars", "onsets", "mdi", "tvli", "radioli", "newsli", "tvlong")]
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

historical$d.civil.wars[2:184]<-diff(historical$civil.wars)
historical$d2.civil.wars[3:184]<-diff(historical$civil.wars,2)
historical$d3.civil.wars[4:184]<-diff(historical$civil.wars,3)
historical$d4.civil.wars[5:184]<-diff(historical$civil.wars,4)

historical$ld.civil.wars<-shift(historical$d.civil.wars, -1)
historical$ld2.civil.wars<-shift(historical$d2.civil.wars, -2)

historical$l.civil.wars<-shift(historical$civil.wars, -1)
historical$l2.civil.wars<-shift(historical$civil.wars, -2)
historical$l3.civil.wars<-shift(historical$civil.wars, -3)

historical$d.onsets[2:184]<-diff(historical$onsets)
historical$d2.onsets[3:184]<-diff(historical$onsets,2)
historical$d3.onsets[4:184]<-diff(historical$onsets,3)
historical$d4.onsets[5:184]<-diff(historical$onsets,4)

historical$ld.onsets<-shift(historical$d.onsets, -1)
historical$ld2.onsets<-shift(historical$d2.onsets, -2)

historical$l.onsets<-shift(historical$onsets, -1)
historical$l2.onsets<-shift(historical$onsets, -2)
historical$l3.onsets<-shift(historical$onsets, -3)

historical$d.tvlong[2:184]<-diff(historical$tvlong)
historical$ld.tvlong<-shift(historical$d.tvlong, -1)
historical$l.tvlong<-shift(historical$tvlong, -1)
historical$d.gdppc[2:184]<-diff(historical$gdppc)
historical$l.gdppc<-shift(historical$gdppc, -1)
historical$d.polity2[2:184]<-diff(historical$polity2)
historical$l.polity2<-shift(historical$polity2, -1)
historical$l2.polity2<-shift(historical$polity2, -1)*shift(historical$polity2, -1)

historical$ww2<-ifelse(historical$Year>=1939 & historical$Year>=1944,1,0)
historical$ww1<-ifelse(historical$Year>=1914 & historical$Year>=1918,1,0)
historical$cold<-ifelse(historical$Year>=1947 & historical$Year>=1991,1,0)

longrun<-historical

longrun[c(2:length(names(longrun)))]<-sapply(longrun[c(2:length(names(longrun)))], function(x) rescale(x))

molten<-melt(subset(longrun, select=c("Year", "tvlong", "civil.wars", "polity2", "gdppc")), id="Year")

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

longrun.plot<-ggplot(molten, aes(x=Year)) +
  geom_line(aes(y=value, colour=variable, linetype=variable)) +
  scale_colour_manual(values=cbbPalette) +
  labs(y="Z-scores (standardized values") +
  theme_bw()



## Make subset for count models, standardizing all but civil war counts

modelvars2.unscaled<-subset(historical, select=c("Year", "d.civil.wars", "d.onsets", "onsets", "ww1", "ww2", "cold", "l.tvlong", "d.tvlong", "l.gdppc",
                                        "l.polity2", "l2.polity2", "d.polity2", "d.gdppc", "civil.wars", "l.civil.wars", "d2.civil.wars", "l.onsets", "l2.onsets",
                                        "d2.onsets"))
modelvars2.unscaled<-modelvars2.unscaled[complete.cases(modelvars2.unscaled),]

# require(tseries)
# adf.test(modelvars.unscaled$civil.wars)
# adf.test(modelvars.unscaled$onsets)
# acf(modelvars.unscaled$onsets)


detach("package:Zelig", unload=TRUE)
require(arm)
modelvars2<-subset(historical, select=c("Year", "d.civil.wars", "d.onsets", "onsets", "ww1", "ww2", "cold", "l.tvlong", "d.tvlong", "l.gdppc",
                                       "l.polity2", "l2.polity2", "d.gdppc", "d.polity2", "civil.wars", "l.civil.wars", "d2.civil.wars", "l.onsets", "l2.onsets",
                                       "d2.onsets", "ld.onsets"))
modelvars2[c(1,6:length(names(modelvars2)))]<-sapply(modelvars2[c(1,6:length(names(modelvars2)))], function(x) rescale(x))
modelvars2<-modelvars2[complete.cases(modelvars2),]

detach("package:arm", unload=TRUE)
require(Zelig)

z.out.hist1<-zelig(onsets ~ l.tvlong + d.tvlong + l.gdppc + d.gdppc + l.polity2 + d.polity2 + l2.polity2 + civil.wars +
                     l.onsets + d.onsets + Year,
                   model="negbinom",
                   robust=TRUE,
                   data=modelvars2,
                   cite=F)
# summary(z.out.hist1)

z.out.hist2<-zelig(onsets ~ l.tvlong + d.tvlong + l.gdppc + d.gdppc + l.polity2 + d.polity2 + l2.polity2 + civil.wars +
                     l.onsets + d.onsets + Year + ww1 + ww2 + cold,
                   model="negbinom",
                   robust=TRUE,
                   data=modelvars2,
                   cite=F)
# summary(z.out.hist2)
# plot(modelvars2$Year, z.out.hist3$result$residuals)
# plot(modelvars2$l.tvlong, z.out.hist3$result$residuals)
# plot(modelvars2$onsets, z.out.hist3$result$residuals)

modelvars2$imputed<-ifelse(modelvars2$Year<0.352, 1, 0) # scaled "1945"
z.out.hist3<-zelig(onsets ~ l.tvlong + d.tvlong + l.gdppc + d.gdppc + l.polity2 + d.polity2 + l2.polity2 + civil.wars +
                     l.onsets + d.onsets + Year + ww1 + ww2 + cold + imputed,
                   model="negbinom",
                   robust=TRUE,
                   data=modelvars2,
                   cite=F)
# summary(z.out.hist3)


z.out.hist2.unscaled<-zelig(onsets ~ l.tvlong + d.tvlong + l.gdppc + d.gdppc + l.polity2 + d.polity2 + l2.polity2 +
                              civil.wars + l.onsets + d.onsets + Year + ww1 + ww2 + cold,
                   model="negbinom",
                   robust=TRUE,
                   data=modelvars2.unscaled,
                   cite=F)
# summary(z.out.hist2.unscaled)

dtv.r<-seq(-.1827,.9664,.1)
tv.r<-seq(0,20,1)

x.dtv <- setx(z.out.hist2.unscaled, d.tvlong= dtv.r)
x.tv <- setx(z.out.hist2.unscaled, l.tvlong= tv.r)

s.out.d <- sim(z.out.hist2.unscaled, x = x.dtv)
s.out <- sim(z.out.hist2.unscaled, x = x.tv)

pdf(file="figure/dtv_effect.pdf", pointsize=15)
#png(file="figure/dtv_effect.png", pointsize=15)

par(xpd=TRUE)
plot(s.out.d,
     xlab="Change in International Mean of TV Density",
     ylab="Predicted Number of Civil Wars Onsets",
     cex.lab=3,
     ci=c(90,95,99.9),
     leg=3)
dev.off()

