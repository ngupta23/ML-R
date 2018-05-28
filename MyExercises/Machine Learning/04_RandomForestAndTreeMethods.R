library(ISLR)
df <- College
head(df)

# Explolratory Data Analysis
library(ggplot2)
ggplot(df,aes(Room.Board,Grad.Rate)) + geom_point(aes(color=Private))
ggplot(df,aes(F.Undergrad)) + geom_histogram(aes(fill=Private),color='black')
ggplot(df,aes(Grad.Rate)) + geom_histogram(aes(fill=Private),color='black')

df[df$Grad.Rate > 100,]$Grad.Rate <- 100
ggplot(df,aes(Grad.Rate)) + geom_histogram(aes(fill=Private),color='black')

# Test Train Split
library(caTools)
set.seed(101)
split <- sample.split(df$Grad.Rate,SplitRatio = 0.7)
train <- subset(df, split == TRUE)
test <- subset(df, split == FALSE)
str(train) # test if split happened correctly
str(test)

# Train Model
library(rpart) # recusrive partitioning and decision trees
set.seed(101)
tree <- rpart(Private ~ .,method='class',data=train)

# Visualize Model
library(rpart.plot)
prp(tree)

# predictions
pred.val <- predict(tree,test)
head(pred.val,20)
class(pred.val)

Private <- pred.val[,'Yes'] > 0.5
pred.val <- Private

head(pred.val,20)
str(pred.val)

# Metrixs for a single tree
table(pred.val,test$Private)

#####################
### Random Forest ###
#####################

library(randomForest)
set.seed(101)
rf.model <- randomForest(Private ~ .,method='class',data=train,importance=TRUE)
print(rf.model)

# Metrics (Self)
rf.model$confusion
rf.model$importance

# Predictions
pred.rf <- predict(rf.model,test)
head(pred.rf,20)

# Metrics
table(pred.rf,test$Private)


