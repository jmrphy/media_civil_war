require(ggplot2)
require(reshape2)
require(XLConnect)
require(psData)

setwd("~/Dropbox/R Code")
source("shift.R")

setwd("~/Dropbox/Data General/COW Intra-state Wars")
war<-read.csv("Intra-StateWarData_v4.1.csv")

setwd("~/Dropbox/Data General/maddison")
maddison <- readWorksheet(loadWorkbook("mpd_2013-01.xlsx"),sheet=1,startRow=3, header=T)


### Make a full-year dataframe
yearsdf<-as.data.frame(1816:1999)
names(yearsdf)<-"Year"
yearsdf$Year<-as.factor(yearsdf$Year)

### Make a dataframe for # of intrastate war entries each year
startyear.int<-as.data.frame(table(war$StartYear1))
names(startyear.int)<-c("Year", "Entries.int")
class(startyear.int$Year)

### Merge dataframe for total war entries in all years
yearsdf<-merge(yearsdf, startyear.int, by="Year", all.x=TRUE)
yearsdf$Entries.int<-ifelse(is.na(yearsdf$Entries.int), 0, yearsdf$Entries.int)

### Make a dataframe for # of war exits each year
endyear.int<-as.data.frame(table(war$EndYear1))
names(endyear.int)<-c("Year", "Exits.int")

### Merge exits with entries
yearsdf<-merge(yearsdf, endyear.int, by="Year", all.x=TRUE)
yearsdf$Exits.int<-ifelse(is.na(yearsdf$Exits.int), 0, yearsdf$Exits.int)

yearsdf$Exits.int<-as.ts(yearsdf$Exits.int)
yearsdf$Entries.int<-as.ts(yearsdf$Entries.int)

yearsdf$Exits2.int<-shift(yearsdf$Exits.int, -1)
yearsdf$Exits2.int[is.na(yearsdf$Exits2.int)]<-0

yearsdf$civil.wars<-cumsum(yearsdf$Entries.int - yearsdf$Exits2.int)
data<-yearsdf
data<-data[,c(1,5)]
rm(yearsdf)
rm(endyear.int)
rm(startyear.int)

data$Year<-as.numeric(levels(data$Year))
summary(data$Year)

hist<-subset(df, select=c("cowcode", "year", "mdi", "tvli", "radioli", "newsli"))
attach(hist)
hist <-aggregate(hist, by=list(year), 
                   FUN=mean, na.rm=TRUE)
detach(hist)
hist$Year<-as.numeric(levels(hist$Group.1))

historical<-merge(data, hist, by=c("Year"), all.x=TRUE)
historical<-historical[,c(1,2,6:9)]

molten<-melt(historical, id="Year")


global.plot<-ggplot(molten, aes(x=Year)) +
  geom_line(aes(y=value, colour=variable, linetype=variable)) +
  labs(y="Value", title="Mass Media Density and Civil Wars Globally") +
  theme_bw()

historical$tvlong<-historical$tvli
historical$tvlong[1:129]<-0


setwd("~/Dropbox/Data General/historical_cross_country/CHAT")
options(scipen=999)
chat<-read.dta("CHAT.dta")
chat$country<-as.factor(chat$country)

#chat$chat.elec<-chat$elecprod/chat$xlpopulation
chat$chat.radio<-chat$radio/chat$xlpopulation
chat$chat.phone<-chat$telephone/chat$xlpopulation
chat$chat.tgram<-chat$telegram/chat$xlpopulation
chat$chat.mail<-chat$mail/chat$xlpopulation
chat$chat.tv<-chat$tv/chat$xlpopulation
chat$chat.news<-chat$newspaper/chat$xlpopulation
chat$chat.cellphone<-chat$cellphone/chat$xlpopulation
chat$Year<-chat$year

chat<-subset(chat, select=c("country", "wbcode", "Year", "chat.radio", "chat.phone", "chat.tgram", "chat.mail",
                            "chat.cellphone", "chat.news", "chat.tv"))
attach(chat)
chat <-aggregate(chat, by=list(Year), 
                 FUN=mean, na.rm=TRUE)
detach(chat)

chat$hmdi<-rowMeans(chat[,5:length(names(chat))], na.rm=T)

chat<-subset(chat, select=c("Year", "hmdi"))



historical<-merge(historical, chat, by=c("Year"))

cor(historical$mdi, historical$hmdi, use="complete.obs")
cor(historical$radioli, historical$hmdi, use="complete.obs")
cor(historical$tvli, historical$hmdi, use="complete.obs")
cor(historical$newsli, historical$hmdi, use="complete.obs")


maddison<-maddison[35:222,]
maddison<-subset(maddison, select=-c(X12.W..Europe, X30.W..Europe., W..Offshoots., X7.E..Europe,
                                     F..Yugoslavia., F..Czecho.slovakia, F..USSR., X8.L..America,
                                     X15.L..America, L..America, X16.E..Asia, X30.E..Asia, X15.W..Asia,
                                     Asia., Total.Africa., Col184, Total.World))

maddison<- reshape(maddison, 
                   varying = c(names(maddison[2:168])),
                   v.names = "gdppc",
                   timevar = "Col1", 
                   times = c(names(maddison[2:168])),
                   direction = "long")

maddison$gdppc[maddison$gdppc==" "]<-NA
maddison$gdppc[maddison$gdppc==""]<-NA
class(maddison$gdppc)
summary(maddison$gdppc)

maddison$gdppc<-gsub(",", "", maddison$gdppc)

maddison$gdppc<-as.numeric(maddison$gdppc)

attach(maddison)
maddison <-aggregate(maddison, by=list(id), 
                     FUN=mean, na.rm=TRUE)
detach(maddison)

maddison$Year<-1816:2003

historical<-merge(historical, maddison, by=c("Year"))

polity <- PolityGet(vars = "polity2")
polity<-subset(polity, year>=1816 & year<=2003)

attach(polity)
polity <-aggregate(polity, by=list(year), 
                     FUN=mean, na.rm=TRUE)
detach(polity)

polity$Year<-polity$year

historical<-merge(historical, polity, by=c("Year"))


longrun<-subset(historical, select=c("Year", "hmdi", "civil.wars", "gdppc", "polity2"))
longrun.unscaled<-subset(historical, select=c("Year", "hmdi", "civil.wars", "gdppc", "polity2"))

detach("package:Zelig", unload=TRUE)
require(arm)
longrun[c(2:length(names(longrun)))]<-sapply(longrun[c(2:length(names(longrun)))], function(x) rescale(x))

molten<-melt(longrun, id="Year")

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

longrun.plot<-ggplot(molten, aes(x=Year)) +
  geom_line(aes(y=value, colour=variable, linetype=variable)) +
  scale_colour_manual(values=cbbPalette) +
  labs(y="Value", title="Television, Civil War, and Economic Growth in the Long Run") +
  theme_bw()

longrun<-subset(historical, select=c("Year", "hmdi", "civil.wars", "gdppc", "polity2"))
longrun[c(2,4:length(names(longrun)))]<-sapply(longrun[c(2,4:length(names(longrun)))], function(x) rescale(x))
detach("package:arm", unload=TRUE)

require(Zelig)


longrun$d.civil.wars[2:184]<-diff(longrun$civil.wars)
longrun$l.civil.wars[2:184]<-lag(longrun$civil.wars)
longrun$d.hmdi[2:184]<-diff(longrun$hmdi)
longrun$l.hmdi[2:184]<-lag(longrun$hmdi)
longrun$d.gdppc[2:184]<-diff(longrun$gdppc)
longrun$l.gdppc[2:184]<-lag(longrun$gdppc)
longrun$d.polity2[2:184]<-diff(longrun$polity2)
longrun$l.polity2[2:184]<-lag(longrun$polity2)
longrun$l2.polity2[2:184]<-lag(longrun$polity2)*lag(longrun$polity2)

longrun[c(2,4:length(names(longrun)))]<-sapply(longrun[c(2,4:length(names(longrun)))], function(x) x+abs(min(longrun$polity2)))

longrun<-longrun[complete.cases(longrun),]
model<-zelig(civil.wars ~ l.gdppc + d.gdppc + l.hmdi +
            d.hmdi + l.polity2 +
            d.polity2 + l2.polity2 + l.civil.wars + d.civil.wars + Year,
            model="negbinom",
            data=longrun)
summary(model)

longrun2<-longrun.unscaled
longrun2$d.civil.wars[2:184]<-diff(longrun2$civil.wars)
longrun2$l.civil.wars[2:184]<-lag(longrun2$civil.wars)
longrun2$d.hmdi[2:184]<-diff(longrun2$hmdi)
longrun2$l.hmdi[2:184]<-lag(longrun2$hmdi)
longrun2$d.gdppc[2:184]<-diff(longrun2$gdppc)
longrun2$l.gdppc[2:184]<-lag(longrun2$gdppc)
longrun2$d.polity2[2:184]<-diff(longrun2$polity2)
longrun2$l.polity2[2:184]<-lag(longrun2$polity2)
longrun2$l2.polity2[2:184]<-lag(longrun2$polity2)*lag(longrun2$polity2)
longrun2<-longrun2[complete.cases(longrun2),]

model2<-zelig(civil.wars ~ l.gdppc + d.gdppc + l.hmdi +
               d.hmdi + l.polity2 +
               d.polity2 + l2.polity2 + l.civil.wars + d.civil.wars + Year,
             model="negbinom",
             data=longrun2)
summary(model2)


# doesn't work:
dtv.r <- seq(min(longrun2$d.tvlong), max(longrun2$d.tvlong), .1)

x.dtv<-setx(model2, d.tvlong=dtv.r)
s.out<-sim(model2, x = x.dtv)
plot.ci(s.out, ci=c(90,95,99), qi="ev", leg=3, ylim=0:1,
                  xlab="Change in Television Density Global Mean",
                  ylab="Expected Number of Civil Wars")

x.lo <- setx(model2, d.tvlong=0)
x.hi <- setx(model2, d.tvlong=mean(longrun2$d.tvlong))
s.out <- sim(model2, x = x.lo, x1 = x.hi)
dtv.plot<-plot(s.out, ci=c(90,95,99), qi="ev", leg=3, ylim=0:1,
                  xlab="Change in Television Density Global Mean",
                  ylab="Expected Number of Civil Wars")
mean(s.out.fdi$qi$fd)

