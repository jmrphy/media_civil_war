require(XLConnect)
setwd("~/Dropbox/Data General/maddison")
maddison <- readWorksheet(loadWorkbook("mpd_2013-01.xlsx"),sheet=1,startRow=3, header=T)

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

setwd("~/Dropbox/gh_projects/media_civil_war")
write.csv(maddison, "data/maddison.csv")