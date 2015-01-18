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
pdf$lmdi<-pdf$mdi
pdf$ld.mdi<-diff(pdf$mdi, differences=1)
pdf$lnews<-pdf$newsli
pdf$ld.news<-diff(pdf$newsli, differences=1)
pdf$lradio<-pdf$radioli
pdf$ld.radio<-diff(pdf$radioli, differences=1)
pdf$ltv<-pdf$tvli
pdf$ld.tv<-diff(pdf$tvli, differences=1)
df<-as.data.frame(pdf)
df<-subset(df, select=(1:length(df)))

df$logmdi<-log(df$mdi+1)
df$mdi2<-df$mdi*df$mdi


write.csv(df, "data/warren.csv")