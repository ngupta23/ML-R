# Load Data
loans <- read.csv("loan_data.csv")
head(loans)
str(loans)
summary(loans)


loans$inq.last.6mths <- factor(loans$inq.last.6mths)
loans$delinq.2yrs <- factor(loans$delinq.2yrs)
loans$pub.rec <- factor(loans$pub.rec)
loans$not.fully.paid <- factor(loans$not.fully.paid)
loans$credit.policy <- factor(loans$credit.policy)

str(loans)

###################################
#### Exploratory Data Analysis ####
###################################

library(ggplot2)
ggplot(loans,aes(fico)) + geom_histogram(aes(fill=not.fully.paid),color='black',alpha = 0.3)
ggplot(loans,aes(purpose)) + geom_bar(aes(fill=not.fully.paid),color='black',alpha = 0.3,position = 'dodge')
ggplot(loans,aes(fico,int.rate)) + geom_point(aes(color=not.fully.paid),alpha = 0.7)

#########################
#### Train the Model ####
#########################

library(caTools)
set.seed(101)
split <- sample.split(loans$not.fully.paid,SplitRatio = 0.7)
train <- subset(loans, split == TRUE)
test <- subset(loans, split == FALSE)
str(train)
str(test)

library(e1071)
set.seed(101)
model <- svm(not.fully.paid ~ ., data=train)
summary(model)

pred.values <- predict(model,test[1:13])
table(pred.values,test$not.fully.paid)

# tune function performs grid search to tune the best parameters
tune.results <- tune(svm,train.x = not.fully.paid ~ ., data=train,kernel='radial',ranges = list(cost=c(100.200),gamma=c(0.1)))   
tune.results$best.model

# fine tuning further
# skipping due to computation times

# we get cost = 100, gamma = 0.1
tuned.svm <- svm(not.fully.paid ~ .,data = model,kernel = 'radial', cost = 100, gamma = 0.1)
tuned.svm
# alternately use tune.results$best.model (better approach)

tuned.pred <- predict(tune.results$best.model,test[1:13])
table(tuned.pred,test$not.fully.paid)
