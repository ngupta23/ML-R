df <- read.csv("bank_note_data.csv")
head(df)
str(df)

### EDA ###

ggplot(df,aes(Image.Var)) + geom_histogram(bins = 20)
ggplot(df,aes(Image.Skew)) + geom_histogram(bins = 20)
ggplot(df,aes(Image.Curt)) + geom_histogram(bins = 20)
ggplot(df,aes(Entropy)) + geom_histogram(bins = 20)
ggplot(df,aes(Class)) + geom_histogram(bins = 20)

# data seems to already be normalized or close to normalized

library(caTools)
set.seed(101)
split <- sample.split(df$Class,SplitRatio = 0.7)
train <- subset(df, split == TRUE)
test <- subset(df, split == FALSE)
str(df)
str(train)
str(test)

library(neuralnet)

n <- names(train)
f <- as.formula(paste("Class ~", paste(n[!n %in% "Class"], collapse = " + "))) # since neuralnet does not accept the standard . notation
f


nn <- neuralnet(f,train,hidden=c(10),linear.output = FALSE) 
plot(nn)

# Predictions
predicted.nn.values <- compute(nn,test[1:4]) ## compute instead of predict as in previous cases
## we want the net result from here and also unscale to actual values

# predictions are still probabilities; need to convert to classes of 0 and 1
true.predictions <- round(predicted.nn.values$net.result)
head(true.predictions)

# Metrics
table(true.predictions,test$Class)

# Comparison to RF

library(randomForest)
rf.model <- randomForest(Class ~ .,method='class',data=train)
print(rf.model)

fitted.probabilities <- (predict(rf.model,test[1:4],type = 'response'))
head(fitted.probabilities)
fitted.results <- ifelse(fitted.probabilities>0.5,1,0) # short cur way to write if-then-else
head(fitted.results)

table(fitted.results,test$Class)
