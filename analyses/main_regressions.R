setwd("~/Dropbox/gh_projects/media_civil_war")
require(ggplot2)
require(reshape2)
require(foreign)
require(Zelig)
require(stargazer)
require(arm)


warren<-read.csv("data/warren.csv")

model1vars<-subset(warren, select=c("country", "year", "onset", "oil2l", "mdi", "logmdi", "mdi2", "lgdpl", "larea",
                                    "lmtn", "lpopl", "deml",
                   "deml2", "ethfracl", "relfracl", "pcyrs", "spline1", "spline2", "spline3"))

model1vars<-model1vars[complete.cases(model1vars),]
model1vars[-(1:4)]<-sapply(model1vars[-(1:4)], function(x) rescale(x))

detach("package:arm", unload=TRUE)
require(ZeligGAM)

### Testing non-linearity

# Using MGCV

rep.model.lin.log <- gam(onset ~ logmdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                       deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                       spline3,
                     data=model1vars,
                     family=binomial)
# summary(rep.model.lin.log)

rep.model.nonlin <- gam(onset ~ s(logmdi) + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                            deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                            spline3,
                          data=model1vars,
                          family=binomial)
# summary(rep.model.nonlin)

# anova(rep.model.lin.log, rep.model.nonlin, test="Chisq")


# plot(rep.model.nonlin, main="title")


# Using Zelig

z.nonlin <- zelig(onset ~ s(logmdi) + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                          deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                          spline3,
                        data=model1vars,
                        model="logit.gam")
# summary(z.nonlin)

# quantile(warren$mdi, .05, na.rm=TRUE)
# quantile(warren$mdi, .25, na.rm=TRUE)

x.low <- setx(z.nonlin, logmdi= -1.18) # lowest value
x.high <- setx(z.nonlin, logmdi= quantile(model1vars$logmdi, .25)) # 25% of cases
s.out <- sim(z.nonlin, x=x.low, x1=x.high)
# summary(s.out)
# plot(s.out)

x.real.high <- setx(z.nonlin, logmdi= quantile(model1vars$logmdi, .90, na.rm=TRUE)) # 25% of cases
s.out <- sim(z.nonlin, x=x.low, x1=x.real.high)
# summary(s.out)
# plot(s.out)


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


lowmdi<-subset(warren, mdi<= quantile(warren$mdi, .25, na.rm=TRUE))

model2vars<-subset(lowmdi, select=c("country", "year", "onset", "oil2l", "mdi", "lgdpl", "larea",
                                    "lmtn", "lpopl", "deml", "ld.mdi",
                                    "deml2", "ethfracl", "relfracl", "pcyrs", "spline1", "spline2", "spline3"))
model2vars<-model2vars[complete.cases(model2vars),]

detach("package:ZeligGAM", unload=TRUE)
detach("package:Zelig", unload=TRUE)
require(arm)
model2vars[-(1:4)]<-sapply(model2vars[-(1:4)], function(x) rescale(x))

detach("package:arm", unload=TRUE)
require(Zelig)

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