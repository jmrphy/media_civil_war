setwd("~/Dropbox/gh_projects/media_civil_war")
require(ggplot2)
require(reshape2)
require(foreign)

# Read in the data from Warren 2014
df<-read.dta("data/Warren_IO_reg_data.dta")

model<-zelig(onset ~ lgdpl + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=df, model="logit", robust=TRUE)
summary(model)

model<-zelig(onset ~ mdi + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=df, model="logit", robust=TRUE)
summary(model)

model<-zelig(onset ~ mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=df, model="logit", robust=TRUE)
summary(model)

lowmdi<-subset(df, mdi<= 11)
himdi<-subset(df, mdi>= 11)

model<-zelig(onset ~ ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=lowmdi, model="relogit", robust=TRUE)
summary(model)

lowmdi<-subset(df, mdi<= 10)
himdi<-subset(df, mdi>= 10)

model<-zelig(onset ~ ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=lowmdi, model="relogit", robust=TRUE)
summary(model)


lowmdi<-subset(df, mdi<= 9)
himdi<-subset(df, mdi>= 9)

model<-zelig(onset ~ ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=lowmdi, model="relogit", robust=TRUE)
summary(model)

lowmdi<-subset(df, mdi<= 8.1)
himdi<-subset(df, mdi>= 8.1)

model<-zelig(onset ~ ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=lowmdi, model="relogit", robust=TRUE)
summary(model)

lowmdi<-subset(df, mdi<= 7)
himdi<-subset(df, mdi>= 7)

model<-zelig(onset ~ ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=lowmdi, model="relogit", robust=TRUE)
summary(model)

lowmdi<-subset(df, mdi<= 6)
himdi<-subset(df, mdi>= 6)

model<-zelig(onset ~ ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=lowmdi, model="relogit", robust=TRUE)
summary(model)

lowmdi<-subset(df, mdi<= 5)
himdi<-subset(df, mdi>= 5)

model<-zelig(onset ~ ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=lowmdi, model="relogit", robust=TRUE)
summary(model)

model<-zelig(onset ~ lmdi + ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=himdi, model="relogit", robust=TRUE)
summary(model)