require(reshape2)
require(ggplot2)

setwd("~/Dropbox/gh_projects/media_civil_war")
hist_intrastate<-read.csv("data/hist_intrastate.csv")
warren<-read.csv("data/warren.csv")

warren<-subset(warren, select=c("cowcode", "year", "mdi", "tvli", "radioli", "newsli"))
attach(warren)
warren <-aggregate(warren, by=list(year), 
                        FUN=mean, na.rm=TRUE)
detach(warren)
warren$Year<-warren$Group.1

globalmdi<-merge(hist_intrastate, warren, by=c("Year"), all.x=TRUE)
globalmdi<-globalmdi[,c("Year", "civil.wars", "mdi", "tvli", "radioli", "newsli")]

global.molt<-melt(globalmdi, id="Year")

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

global.plot<-ggplot(global.molt, aes(x=Year)) +
  geom_line(aes(y=value, colour=variable, linetype=variable)) +
  scale_colour_manual(values=cbbPalette) +
  labs(y="Z (standardized values)", title="Mass Media Density and Civil Wars Globally, 1816-1999") +
  theme_bw()

