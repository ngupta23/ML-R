### Read Data
df1 <- read.csv('winequality-red.csv',sep=";")
head(df1)
df2 <- read.csv('winequality-white.csv',sep=";")
head(df2)

# Add labels for later (this will not be available in real life)
df1 <-  cbind(df1,label='red')
head(df1)
df2 <-  cbind(df2,label='white')
head(df2)

# merge dataframes
wine <- rbind(df1,df2)
str(wine)

#################################
### Exploratory Data Analysis ###
#################################

library(ggplot2)

ggplot(wine,aes(residual.sugar)) + geom_histogram(aes(fill=factor(label)),alpha=0.7) + theme_bw()
ggplot(wine,aes(citric.acid,fill=factor(label))) + geom_histogram(alpha=0.7) + theme_bw()
ggplot(wine,aes(alcohol,fill=factor(label))) + geom_histogram(alpha=0.7) + theme_bw()                                                  
    
ggplot(wine,aes(residual.sugar,citric.acid)) + geom_point(aes(color=factor(label)))                                              
ggplot(wine,aes(volatile.acidity,residual.sugar)) + geom_point(aes(color=factor(label)))   

####################
#### Clustering ####
####################

str(wine)
clus.data <- wine[,-13]
head(clus.data)

set.seed(101)
wine.cluster <- kmeans(clus.data,2,nstart = 20 ) # data, K (groups), nstart = number of random starts you can do
wine.cluster

# testing, in real world, you will not have this labelled data
table(wine.cluster$cluster,wine$label)

# testing with more clusters to see if we can split the wines into more categories for better prediction
set.seed(101)
wine.cluster <- kmeans(clus.data,4,nstart = 20 ) # data, K (groups), nstart = number of random starts you can do
wine.cluster

# testing, in real world, you will not have this labelled data
table(wine.cluster$cluster,wine$label)



# cluster visualization
library(cluster)
# this plots the clusters against the 2 components that explain the most variability
# this is not very useful if you have a lot of features
clusplot(wine,wine.cluster$cluster,color = TRUE, shade = TRUE, lines = 0) 
 