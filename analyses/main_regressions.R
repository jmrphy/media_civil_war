setwd("~/Dropbox/gh_projects/media_civil_war")
require(ggplot2)
require(reshape2)
require(foreign)
require(Zelig)
require(stargazer)



rep.model<-zelig(onset ~ mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                   deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                   spline3,
                 data=df,
                 model="relogit",
                 robust=TRUE,
                 cite=F)

lowmdi<-subset(df, mdi<= 10)

diff.model<-zelig(onset ~ ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
               deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3,
             data=lowmdi,
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