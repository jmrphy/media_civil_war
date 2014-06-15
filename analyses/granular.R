setwd("~/Dropbox/gh_projects/media_civil_war")
require(ggplot2)
require(foreign)
require(gridExtra)

props<-subset(df, select=c("mdi", "onset"))
props<-props[complete.cases(props),]

# Civil war onsets as proportion of mdi categories (row proportions)
# and as proportion of all civil wars (column proportions)
b=200
props$mdicut<-cut(props$mdi, breaks=b)
tbl <- table(props$mdicut, props$onset)
props1<-prop.table(tbl,1)[1:100,2]
props2<-prop.table(tbl,2)[1:100,2]
props<-as.data.frame(cbind(props1,props2))
names(props)<-c("rowprops", "colprops")

props$rownames<-as.factor(row.names(props))
props$rownames<-factor(props$rownames, levels=props$rownames, ordered=TRUE)

tbl1<-ggplot(props, aes(x=rownames, y=rowprops)) +
  geom_bar(stat="identity") +
  coord_flip()

tbl2<-ggplot(props, aes(x=rownames, y=colprops)) +
  geom_bar(stat="identity") +
  coord_flip()

colpropsum<-sum(props$colprops)

median.quartile <- function(x){
  out <- quantile(x, probs = c(0.25,0.5,0.75))
  names(out) <- c("ymin","y","ymax")
  return(out) 
}

violinplot1 <- ggplot(subset(df), aes(factor(onset), mdi)) +
  geom_violin(fill = "grey80", colour = "#000000", scale="count") +
  stat_summary(fun.y=median.quartile, geom="point", shape=1, size=2) +
  scale_y_continuous(breaks=seq(0,320,10)) +
  theme_bw()

violinplot2 <- ggplot(subset(df, onset==0), aes(factor(onset), mdi)) +
  geom_violin(fill = "grey80", colour = "#000000", scale="count") +
  stat_summary(fun.y=median.quartile, geom="point", shape=1, size=2) +
  scale_y_continuous(breaks=seq(0,320,10)) +
  theme_bw()

violinplot3 <- ggplot(subset(df, onset==1), aes(factor(onset), mdi)) +
  geom_violin(fill = "grey80", colour = "#000000", scale="count") +
  stat_summary(fun.y=median.quartile, geom="point", shape=1, size=2) +
  scale_y_continuous(limits = c(0,320), breaks=seq(0,320,10)) +
  theme_bw()

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2)))
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
print(violinplot1, vp = vplayout(1, 1:2))  # key is to define vplayout
print(violinplot2, vp = vplayout(2, 1))
print(violinplot3, vp = vplayout(2, 2))
