setwd("~/Dropbox/gh_projects/media_civil_war")
require(foreign)
require(plm)
require(Zelig)
require(ggplot2)
require(reshape2)

# Read in the data from Warren 2014
df<-read.dta("data/Warren_IO_reg_data.dta")

# Make country variable a factor instead of character
df$country<-as.factor(df$country)

# Make new variables panel-style
pdf<-pdata.frame(df, index=c("cowcode", "year"))
pdf$lonset<-lag(pdf$onset)
pdf$lmdi<-lag(pdf$mdi)
pdf$d.mdi<-diff(pdf$mdi, differences=1)
pdf$ld.mdi<-diff(pdf$lmdi, differences=1)
pdf$lnews<-lag(pdf$newsli)
pdf$d.news<-diff(pdf$newsli, differences=1)
pdf$ld.news<-diff(pdf$lnews, differences=1)
pdf$lradio<-lag(pdf$radioli)
pdf$d.radio<-diff(pdf$radioli, differences=1)
pdf$ld.radio<-diff(pdf$lradio, differences=1)
pdf$ltv<-lag(pdf$tvli)
pdf$d.tv<-diff(pdf$tvli, differences=1)
pdf$ld.tv<-diff(pdf$ltv, differences=1)
df<-as.data.frame(pdf)
df<-subset(df, select=(1:length(df)))

write.csv(df, "data/warren.csv")