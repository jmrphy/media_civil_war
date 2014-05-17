setwd("~/Dropbox/gh_projects/media_civil_war")
require(ggplot2)
require(reshape2)
require(foreign)

# Read in the data from Warren 2014
df<-read.dta("data/Warren_IO_reg_data.dta")

# Make country variable a factor instead of character
df$country<-as.factor(df$country)

onsets<-df[df$onset==1,]
onsetcountries<-as.character(unique(onsets$country))

cases<-subset(df, country %in% onsetcountries)

cases[cases$onset==1, c("year","country")]

case<-subset(cases, select=c("country","year","onset", "mdi","newsli", "radioli", "tvli"))
case <- melt(case, id.vars=c("country","year", "onset"))

full_panel_plot<-ggplot(case) +
  geom_rect(data = subset(case, onset == 1), 
            aes(ymin = -Inf, ymax = Inf, xmin = year-0.5, xmax = year+0.5), 
            alpha = 0.2)+
  geom_line(aes(x=year, y=value, linetype=variable, colour=variable)) +
  theme_bw() +
  facet_wrap( ~ country)
