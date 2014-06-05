setwd("~/Dropbox/gh_projects/media_civil_war")
require(ggplot2)
require(reshape2)
require(foreign)
require(Zelig)
require(stargazer)
require(arm)

warren<-read.csv("data/warren.csv")

model1vars<-subset(warren, select=c("country", "year", "onset", "oil2l", "mdi", "lgdpl", "larea",
                                    "lmtn", "lpopl", "deml",
                   "deml2", "ethfracl", "relfracl", "pcyrs", "spline1", "spline2", "spline3"))
model1vars<-model1vars[complete.cases(model1vars),]
model1vars[-(1:4)]<-sapply(model1vars[-(1:4)], function(x) rescale(x))

rep.model<-zelig(onset ~ mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                   deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                   spline3,
                 data=model1vars,
                 model="relogit",
                 robust=TRUE,
                 cite=F)

low.model1vars<-subset(warren, mdi<= 10)

(table(warren$onset)[2]/table(warren$onset)[1])*100
(table(low.model1vars$onset)[2]/table(low.model1vars$onset)[1])*100



rep.model2<-zelig(onset ~ mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                   deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                   spline3,
                 data=low.model1vars,
                 model="relogit",
                 robust=TRUE,
                 cite=F)
summary(rep.model2)


lowmdi<-subset(warren, mdi<= 10)

model2vars<-subset(lowmdi, select=c("country", "year", "onset", "oil2l", "mdi", "lgdpl", "larea",
                                    "lmtn", "lpopl", "deml", "ld.mdi",
                                    "deml2", "ethfracl", "relfracl", "pcyrs", "spline1", "spline2", "spline3"))
model2vars<-model2vars[complete.cases(model2vars),]
model2vars[-(1:4)]<-sapply(model2vars[-(1:4)], function(x) rescale(x))

diff.model<-zelig(onset ~ ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
               deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3,
             data=model2vars,
             model="relogit",
             robust=TRUE,
             cite=F)


disag.model<-zelig(onset ~ ld.news + ld.radio + ld.tv + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=lowmdi,
                   model="relogit",
                   robust=TRUE,
                   cite=F)