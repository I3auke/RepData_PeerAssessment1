---
title: "PA1_template"
author: "Bauke Visser"
date: "Thursday, March 05, 2015"
output: html_document
---

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r, echo=TRUE}
setwd("C:/DATA/prive/R_Coursera/05 Reproducible")
act <- read.csv(file="activity.csv",header=T)
act$date<-strptime(act$date,"%Y-%m-%d")
library(plyr)
sumperday<-ddply(act,.(date),summarize,sum_steps=sum(steps))
#summaryperday<-ddply(act,.(date),summarize, mean_steps=mean(steps, na.rm=TRUE), median_steps=median(steps, na.rm=TRUE))
```

Histogram of the sum of the number of steps per day:

```{r, echo=TRUE}
plot(sumperday$date,sumperday$sum_steps ,type="h", xlab="date", ylab= "sum steps")
#library(reshape)
#df <- melt(summaryperday ,  id = 'date', variable_name = 'series')
#library(ggplot2)
#ggplot(df, aes(date,value)) + geom_line(aes(colour = series))
#str(df)
```

Mean of the number of steps per day:
```{r, echo=TRUE}
mean(sumperday$sum_steps, na.rm=TRUE)
```

Median of the number of steps per day:
```{r, echo=TRUE}
median(sumperday$sum_steps, na.rm=TRUE)
```

activity pattern:
```{r, echo=TRUE}
meanperinterval<-ddply(act,.(interval),summarize,mean_steps=mean(steps,na.rm=TRUE))
plot(meanperinterval$interval,meanperinterval$mean_steps ,type="l", xlab="interval", ylab= "mean steps")
```

max time interval:
```{r, echo=TRUE}
max<-max(meanperinterval$mean_steps)
subs<-meanperinterval[meanperinterval$mean_steps==max,]
maxinterval<-subs$interval
print(maxinterval)
```

inputing missing values
total number of NAs:
```{r, echo=TRUE}
sum(is.na(act$steps))
```

fill NAs with average of interval:
```{r, echo=TRUE}
for(i in 1:nrow(act)) {
    if (is.na(act$steps[i])){
        subs<-meanperinterval[meanperinterval$interval==act$interval[i],]
        act$steps[i]<-subs$mean_steps
    }
}

```