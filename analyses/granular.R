setwd("~/Dropbox/gh_projects/media_civil_war")
require(ggplot2)
require(foreign)

# Civil war onsets as proportion of mdi categories (row proportions)
# and as proportion of all civil wars (column proportions)
df$mdicut<-cut(df$mdi, breaks=100)
tbl <- table(df$mdicut, df$onset)
props1<-prop.table(tbl,1)[1:15,2]
props2<-prop.table(tbl,2)[1:15,2]
props<-as.data.frame(cbind(props1,props2))
names(props)<-c("rowprops", "colprops")
colpropsum<-sum(props$colprops)


violinplot <- ggplot(subset(df, onset==1), aes(factor(onset), mdi)) +
  geom_violin(fill = "grey80", colour = "#000000", scale="count") +
  scale_y_continuous(breaks=seq(0,145,5)) +
  theme_bw()