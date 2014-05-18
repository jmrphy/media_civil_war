lowmdi<-subset(df, mdi<= 9)
himdi<-subset(df, mdi>= 9)

model<-zelig(onset ~ ld.mdi + ld.mdi + lgdpl + larea + lmtn + lpopl + oil2l + deml + deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 + spline3, data=lowmdi, model="relogit", robust=TRUE)
summary(model)

lowmdi<-subset(df, mdi<= 8)
himdi<-subset(df, mdi>= 8)

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


lowmdi<-subset(df, mdi<= 10)
disag.model<-zelig(onset ~ lmdi + ld.news + ld.radio + ld.tv + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
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

disag.model<-zelig(onset ~ newsli + radioli + tvli + d.news + d.radio + d.tv + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=lowmdi,
                   model="relogit",
                   robust=TRUE,
                   cite=F)

disag.model<-zelig(onset ~ newsli + d.news + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=lowmdi,
                   model="relogit",
                   robust=TRUE,
                   cite=F)

disag.model<-zelig(onset ~ radioli + d.radio + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=lowmdi,
                   model="relogit",
                   robust=TRUE,
                   cite=F)

disag.model<-zelig(onset ~ tvli + d.tv + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=lowmdi,
                   model="relogit",
                   robust=TRUE,
                   cite=F)

mediummdi<-subset(df, mdi<= 10)





disag.model<-zelig(onset ~ radioli + d.radio + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=mediummdi,
                   model="relogit",
                   robust=TRUE,
                   cite=F)

disag.model<-zelig(onset ~ tvli + d.tv + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=mediummdi,
                   model="relogit",
                   robust=TRUE,
                   cite=F)



disag.model<-zelig(onset ~ newsli + radioli + tvli + d.news + d.radio + d.tv + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=mediummdi,
                   model="relogit",
                   robust=TRUE,
                   cite=F)

disag.model<-zelig(onset ~ lradio + ld.radio + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=mediummdi,
                   model="relogit",
                   robust=TRUE,
                   cite=F)

disag.model<-zelig(onset ~ ltv + ld.tv + lgdpl + larea + lmtn + lpopl + oil2l + deml +
                     deml2 + ethfracl + relfracl + pcyrs + spline1 + spline2 +
                     spline3,
                   data=mediummdi,
                   model="relogit",
                   robust=TRUE,
                   cite=F)

