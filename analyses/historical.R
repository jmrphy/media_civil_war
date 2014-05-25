require(ggplot2)
require(TTR)
require(reshape2)
setwd("~/Dropbox/R Code")
source("shift.R")
setwd("~/Dropbox/Data General/COW Intra-state Wars")
war<-read.csv("Intra-StateWarData_v4.1.csv")


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
historical$tvli[1:129]<-0
historical<-historical[,c(1,2,6:9)]

molten<-melt(historical, id="Year")


global.plot<-ggplot(molten, aes(x=Year)) +
  geom_line(aes(y=value, colour=variable, linetype=variable)) +
  labs(y="Value", title="Mass Media Density and Civil Wars Globally") +
  theme_bw()