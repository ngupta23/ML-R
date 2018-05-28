# Load the IRIS Dataset
library(ISLR)
head(iris)
str(iris)

# Scale the data
standardize.iris <- scale(iris[-5])
var(standardize.iris)

head(standardize.iris)
str(standardize.iris)

# add the target
standardize.iris <- cbind(standardize.iris,iris[5])
head(standardize.iris)

# test train split
library(caTools)
set.seed(101)
split <- sample.split(standardize.iris$Species,SplitRatio = 0.7)
final.train <- subset(standardize.iris, split == TRUE)
final.test <- subset(standardize.iris, split == FALSE)
str(final.train) # check that the split happened correctly
str(final.test)

# apply KNN algorithm
library(class)
predicted.species <- knn(final.train[-5],final.test[-5],final.train$Species,k=1)  # order is Train Data, Test Data, Train Predictions
head(predicted.species)

# metrics
mis.class.error <- mean(predicted.species != final.test$Species)
mis.class.error
accuracy <- 1 - mis.class.error
accuracy

# Choosing the K-value
misclass <- NULL
acc <- NULL
for (i in 1:30){
  set.seed(101) # important to set the seed each time you call any algorithm
  pred.species <- knn(final.train[-5],final.test[-5],final.train$Species,k=i)  # order is Train Data, Test Data, Train Predictions
  misclass[i] <-  mean(pred.species != final.test$Species)
  acc[i] <- 1 - misclass[i]
}

# visualizing error
library(ggplot2)
misclass <- as.data.frame(misclass)
acc <- as.data.frame(acc) # inly needed if this is being plotted

ggplot(misclass,aes(seq(1:30),misclass)) + geom_point()

