setwd("~/Dropbox/gh_projects/media_civil_war")
require(ggplot2)
require(reshape2)
require(foreign)
require(Zelig)
require(stargazer)
require(arm)


warren<-read.csv("data/warren.csv")

model1vars<-subset(warren, select=c("country", "year", "onset", "oil2l", "mdi", "logmdi", "mdi2", "lgdpl", "larea",
                                    "lmtn", "lpopl", "deml", "ltv", "lradio", "lnews",
                   "deml2", "ethfracl", "relfracl", "pcyrs", "spline1", "spline2", "spline3"))
model1vars.unscaled<-model1vars

model1vars<-model1vars[complete.cases(model1vars),]
model1vars[-(1:4)]<-sapply(model1vars[-(1:4)], function(x) rescale(x))

detach("package:arm", unload=TRUE)
require(ZeligGAM)

### Testing non-linearity

# Using MGCV

rep.model.lin.log <- gam(onset ~ logmdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                       deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                       spline3,
                     data=model1vars.unscaled,
                     family=binomial)
# summary(rep.model.lin.log)

rep.model.nonlin <- gam(onset ~ s(logmdi) + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                            deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                            spline3,
                          data=model1vars.unscaled,
                          family=binomial)
# summary(rep.model.nonlin)

anov<-anova(rep.model.lin.log, rep.model.nonlin, test="Chisq")
names(anov)<-c("Resid. Df","Resid. Dev", "Df", "Deviance", "P-value")
# plot(rep.model.nonlin, main="Effect of MDI on Civil War Across Levels of MDI")
# abline(a=0,b=0, col = "red", lty = 9)

threshold<-mean(warren$mdi[warren$logmdi>=1.999 & warren$logmdi<=2.001], na.rm=TRUE)
numcases<-nrow(subset(warren, mdi<=threshold))
numcases.percent<-round(nrow(subset(warren, mdi<=threshold))/length(warren$mdi)*100)
percentunder4<-round(nrow(subset(warren, mdi<=4))/length(warren$mdi)*100)
percentunder10<-round(nrow(subset(warren, mdi<=10))/length(warren$mdi)*100)
mindiff<-min(subset(warren, mdi<quantile(warren$mdi, .20, na.rm=TRUE))$ld.mdi, na.rm=TRUE)
meandiff<-mean(subset(warren, mdi<quantile(warren$mdi, .20, na.rm=TRUE))$ld.mdi, na.rm=TRUE)
maxdiff<-max(subset(warren, mdi<quantile(warren$mdi, .20, na.rm=TRUE))$ld.mdi, na.rm=TRUE)

rep.model.tv.nonlin <- gam(onset ~ s(log(ltv+1)) + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                          deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                          spline3,
                        data=model1vars,
                        family=binomial)

# summary(rep.model.tv.nonlin)

# plot(rep.model.tv.nonlin, main="Effect of TV Density on Civil War Across Levels of TV Density")
# abline(a=0,b=0, col = "red", lty = 9)

rep.model.radio.nonlin <- gam(onset ~ s(log(lradio+1)) + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                             deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                             spline3,
                           data=model1vars,
                           family=binomial)
# summary(rep.model.radio.nonlin)

# plot(rep.model.radio.nonlin, main="Effect of Radio Density on Civil War Across Levels of Radio Density")
# abline(a=0,b=0, col = "red", lty = 9)

rep.model.news.nonlin <- gam(onset ~ s(log(lnews+1)) + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                                deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                                spline3,
                              data=model1vars,
                              family=binomial)
#summary(rep.model.news.nonlin)

# plot(rep.model.news.nonlin, main="Effect of Radio Density on Civil War Across Levels of Radio Density")
# abline(a=0,b=0, col = "darkred", lty = 9)





rep.model<-zelig(onset ~ mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                   deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                   spline3,
                 data=model1vars,
                 model="relogit",
                 robust=TRUE,
                 cite=F)

rep.belowmedian<-zelig(onset ~ mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                   deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                   spline3,
                 data=subset(model1vars, mdi<=quantile(model1vars$mdi, .5, na.rm=TRUE)),
                 model="relogit",
                 robust=TRUE,
                 cite=F)
# summary(rep.belowsixtieth)

# rep.model.mass<-zelig(onset ~ mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
#                    deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
#                    spline3,
#                  data=subset(model1vars, mdi>= quantile(model1vars$mdi, .20, na.rm=TRUE)),
#                  model="relogit",
#                  robust=TRUE,
#                  cite=F)
# 
# subset(warren, mdi< quantile(warren$mdi, .20, na.rm=TRUE))

low.model1vars<-subset(warren, mdi<=quantile(warren$mdi, .20, na.rm=TRUE))

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

model2vars<-subset(warren, mdi<=quantile(warren$mdi, .20, na.rm=TRUE))

model2vars<-subset(model2vars, select=c("country", "year", "onset", "oil2l", "mdi", "lgdpl", "larea",
                                    "lmtn", "lpopl", "deml", "ld.mdi", "ld.tv", "ld.news", "ld.radio",
                                    "deml2", "ethfracl", "relfracl", "pcyrs", "spline1", "spline2", "spline3"))

model2vars.unscaled<-model2vars[complete.cases(model2vars),]
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

disag.model.news<-zelig(onset ~ ld.news + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=model2vars,
                   model="relogit",
                   robust=TRUE,
                   cite=F)

disag.model.radio<-zelig(onset ~ ld.radio + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                          deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                          spline3,
                        data=model2vars,
                        model="relogit",
                        robust=TRUE,
                        cite=F)

disag.model.tv<-zelig(onset ~ ld.tv + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                           deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                           spline3,
                         data=model2vars,
                         model="relogit",
                         robust=TRUE,
                         cite=F)

disag.model<-zelig(onset ~ ld.news + ld.radio + ld.tv + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=model2vars,
                   model="relogit",
                   robust=TRUE,
                   cite=F)



model1vars.unscaled<-model1vars.unscaled[complete.cases(model1vars.unscaled),]


### Predicted probability plot

warren.unscaled<-zelig(onset ~ mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                         deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                         spline3,
                     data=model1vars.unscaled,
                     model="relogit",
                     robust=TRUE,
                     cite=F)

mdi.r<-seq(0,300,50) # ~ min to max in sample

x.mdi <- setx(warren.unscaled, mdi= mdi.r)
s.out <- sim(warren.unscaled, x = x.mdi)


pdf(file="figure/mdi_effect.pdf", pointsize=15)
#png(file="figure/mdi_effect.png", pointsize=15)

par(xpd=TRUE)
plot(s.out,
     main="All Communications Systems",
     xlab="Level of Mass Media Density",
     ylab="Probability of Civil War Onset",
     cex.lab=3,
     ci=c(80,95,99.9),
     leg=4)
dev.off()

### Estimate baseline prediction of moving from 0 MDI to 20th percentile

x.low<-setx(warren.unscaled, mdi = 0)
x.hi<-setx(warren.unscaled, mdi = quantile(model1vars.unscaled$mdi, .20, na.rm=TRUE))

s.out.warren <- sim(warren.unscaled, x = x.low, x1 = x.hi)

# summary(s.out.warren)


diff.unscaled<-zelig(onset ~ ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=model2vars.unscaled,
                   model="relogit",
                   robust=TRUE,
                   cite=F)

### Estimate baseline prediction of moving from 0 MDI to 20th percentile

x.low<-setx(diff.unscaled, ld.mdi = 0)
x.hi<-setx(diff.unscaled, ld.mdi = quantile(model1vars.unscaled$mdi, .20, na.rm=TRUE))

s.out.diff <- sim(diff.unscaled, x = x.low, x1 = x.hi)


### Estimate baseline prediction of moving from 0 MDI change to a MDI change of 1

x.low<-setx(diff.unscaled, ld.mdi = 0)
x.hi<-setx(diff.unscaled, ld.mdi = 1)

s.out.diff1 <- sim(diff.unscaled, x = x.low, x1 = x.hi)

# summary(s.out.diff1)

### Estimate baseline prediction of moving from 0 MDI change to a MDI change of 2.5

x.low<-setx(diff.unscaled, ld.mdi = 0)
x.hi<-setx(diff.unscaled, ld.mdi = 2.5)

s.out.diff2 <- sim(diff.unscaled, x = x.low, x1 = x.hi)

# summary(s.out.diff2)


ld.mdi.r<-seq(0,3,1) # ~ zero change to ~ max change

x.ld.mdi <- setx(diff.unscaled, ld.mdi= ld.mdi.r)
s.out.d <- sim(diff.unscaled, x = x.ld.mdi)

pdf(file="figure/d_mdi_effect.pdf", pointsize=15)
#png(file="figure/d_mdi_effect.png", pointsize=15)

par(xpd=TRUE)
plot(s.out.d,
     main="Pre-Mass Communications Systems",
     xlab="Change in Mass Media Density",
     ylab="Probability of Civil War Onset",
     cex.lab=3,
     ci=c(80,95,99.5),
     leg=3)
dev.off()