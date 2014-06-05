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
globalmdi<-globalmdi[,c("Year", "civil.wars", "mdi")]
globalmdi[2:length(names(globalmdi))]<-sapply(globalmdi[2:length(names(globalmdi))], function(x) scale(x))

global.molt<-melt(globalmdi, id="Year")

cbbPalette <- c("#000000", "#56B4E9", "#E69F00", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

global.plot<-ggplot(global.molt, aes(x=Year)) +
  geom_line(aes(y=value, colour=variable, linetype=variable)) +
  scale_colour_manual(values=cbbPalette) +
  labs(y="Z-scores (standardized values)") +
  theme_bw(base_size = 20)

