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

### Merge dataframe for total intra-state war entries in all years
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
yearsdf$onsets<-yearsdf$Entries.int
data<-yearsdf
data<-data[,c(1,5,6)]
rm(yearsdf)
rm(endyear.int)
rm(startyear.int)

data$Year<-as.numeric(levels(data$Year))
summary(data$Year)

#### Number of states in the international system

setwd("~/Dropbox/gh_projects/media_civil_war/data")
system<-read.csv("system2011.csv")

states<-as.data.frame(table(as.factor(system$year)))
names(states)<-c("Year", "states")

data<-merge(data, states, by=c("Year"))

setwd("~/Dropbox/gh_projects/media_civil_war")
write.csv(data, "data/hist_intrastate.csv")

