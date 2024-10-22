#### Linear Regression ####

df <- read.csv("student-mat.csv",sep = ';')
head(df)

summary(df) # check summary
any(is.na(df)) # check if there are any NA values

str(df) # check if features that are factors are actually factors and vice versa
# in this case you can change Medu and Fedu to factors

###################################
#### Exploratory Data Analysis ####
###################################

library(ggplot2)
library(ggthemes)
library(dplyr)

# check the corelations to see dependencies in data
num.cols <- sapply(df,is.numeric) ## gives which columns are numeric and which are not
num.cols
cor.data <- cor(df[,num.cols]) # inbuilt corelation fucntion in R
cor.data

# install packages for visualization of corelationd data 
#install.packages("corrgram")
library(corrgram)
#install.packages("corrplot")
library(corrplot)

corrplot(cor.data,method = 'color') # corelation using corrplot # needs us to clean the data to only include numeric columns
corrgram(df,order = TRUE             # here you can pass the whole DF include non numeric fields, it will filter it for you.
         , lower.panel = panel.shade # order = TRUE orders the matrix as per PCA
         , upper.panel = panel.pie)  # panels indicate how you want upper and lower panels to look like
ggplot(df,aes(x=G3)) + geom_histogram(bins=20,alpha= 0.5,fill = 'blue') # note 0 values

###########################
#### Linear Regression ####
###########################

# Pros:
#   
#   Simple to explain
#   Highly interpretable
#   Model training and prediction are fast
#   No tuning is required (excluding regularization)
#   Features don't need scaling
#   Can perform well with a small number of observations
#   Well-understood
# 
# Cons:
# 
#   Assumes a linear relationship between the features and the response
#   Performance is (generally) not competitive with the best supervised learning methods due to high bias
#   Can't automatically learn feature interactions


# Train Test Split
#install.packages("caTools")
library(caTools)
set.seed(101) # Set a Seed for reproducible results

sample <- sample.split(df$G3               # you can pass any columns of the df, but it is easier to read if you pass in the predicted value
                       ,SplitRatio = 0.7)  # Split Ratio
train <- subset(df,sample == TRUE)
test <- subset(df,sample == FALSE)

# model <- lm(y ~ x1 + x2, data) # linear model function
# model <- lm(y ~ ., data) # takes all columns as features, no need to specify all columns
model <- lm(G3 ~ . , train)
plot(model) # gives 4 plots
summary(model) # very useful summary                                    
# you want the residuals to be normal for linear regression (remember the assimption of Linear Regression from ST513 class)
# coefficients (slope value), note * next to p-values to find the most significant ones
# R2 value - amount of predictibility predicted by the model. However note that corelation does not imply causation

# checking for normality of residuals
res <- residuals(model)
res <- as.data.frame(res)
ggplot(res,aes(res)) + geom_histogram() # note negative residuals (these are negative scores predicted, however this is not possible in reality)


G3.predict <- predict(model,test)
results <- cbind(G3.predict,test$G3)
colnames(results) <- c("predicted","actual")
results <- as.data.frame(results)
results # note negative predicted values

# cap -ve values to 0
to_zero <- function(x){ 
  if (x < 0){
    return(0)
  }
  else{
    return(x)
  }
}

results$predicted <-  sapply(results$predicted,to_zero)
results # note all zeros are now capped at 0

#### METRICS ####
mse <- mean((results$actual - results$predicted)^2)
print(paste("Mean Square Error (MSE)       : ",mse))
print(paste("Root Mean Square Error (RMSE) : ",mse^0.5))

SSE <- sum((results$actual - results$predicted)^2)
SST <- sum((mean(df$G3) - results$actual)^2) 
  
R2 <- 1 - SSE/SST
print(paste("R2: ",R2))

#############################
#### Logistic Regression ####
#############################

df.train <- read.csv("titanic_train.csv")
str(df.train)

corrgram(df.train)

### for visualizing missing data
#install.packages("Amelia")
library(Amelia)

missmap(df.train,main = 'Missing Map', col = c('yellow','black'), legend = FALSE)
# Age is missing for some values; we can probably impute this

### Exploratory Data Analysis ###
library(ggplot2)

ggplot(df.train,aes(Survived)) + geom_bar()
ggplot(df.train,aes(Survived)) + geom_bar(aes(fill=factor(Pclass)))
ggplot(df.train,aes(Survived)) + geom_bar(aes(fill=factor(Sex)))
ggplot(df.train,aes(Age)) + geom_histogram(alpha=0.3,fill='blue')
ggplot(df.train,aes(SibSp)) + geom_bar()
ggplot(df.train,aes(Fare)) + geom_histogram(alpha=0.3,fill='green',color='darkgreen')

# Dealing with missing data
# one way os to drop the data, but better approach is to impute the data
# Lets fill in the average age per Pclass

ggplot(df.train,aes(factor(Pclass),Age)) + geom_boxplot() + scale_y_continuous(breaks = seq(min(0), max(80), by = 2))

impute_age <- function(age,class){
  out <- age
  for (i in 1:length(age)){
    
    if (is.na(age[i])){
      
      if (class[i] == 1){
        out[i] <- 37
        
      }else if (class[i] == 2){
        out[i] <- 29
        
      }else{
        out[i] <- 24
      }
    }else{
      out[i]<-age[i]
    }
  }
  return(out)
}

fixed.ages <- impute_age(df.train$Age,df.train$Pclass)
df.train$Age <- fixed.ages
missmap(df.train,main = 'Missing Map', col = c('yellow','black'), lefend = FALSE)

### Train the model ###
str(df.train)

library(dplyr)
df.train <- select(df.train,-PassengerId,-Name,-Ticket,-Cabin)

str(df.train)
# you can choose to change integers to factors
df.train$Survived <- as.factor(df.train$Survived)
df.train$Pclass <- as.factor(df.train$Pclass)
df.train$SibSp <- as.factor(df.train$SibSp)
df.train$Parch <- as.factor(df.train$Parch)

log.model <- glm(Survived ~ ., family = binomial(link = 'logit'),data=df.train)  # generalized Linear Model -- used for Logistic Regression 
summary(log.model)

### Test Train Split
library(caTools)
set.seed(101)
split <- sample.split(df.train$Survived,SplitRatio = 0.7)
str(df.train)
final.train <- subset(df.train, split == TRUE)
final.test <- subset(df.train, split == FALSE)

final.log.model <- glm(Survived ~ ., family = binomial(link = 'logit'),data=final.train)  # generalized Linear Model -- used for Logistic Regression 
summary(log.model)
coef(final.log.model) # coefficients are of the form 'logits'
# If coefficient (logit) is positive, the effect of the predictor is positive and vice versa

#### For Meghna ####
# conversion form logit to log-odds to probabilities
# https://sebastiansauer.github.io/convert_logit2prob/
# To convert a logit (glm output) to probability, follow these 3 steps:
#   
# Take glm output coefficient (logit)
# compute e-function on the logit using exp() "de-logarithimize" (you'll get odds then)
# convert odds to probability using this formula prob = odds / (1 + odds). For example, say odds = 2/1, then probability is 2 / (1+2)= 2 / 3 (~.67)

logit2prob <- function(logit){
  odds <- exp(logit)
  prob <- odds / (1 + odds)
  return(prob)
}

logit2prob(coef(final.log.model))
####################

### Predictions ###
fitted.probabilities <- (predict(final.log.model,final.test,type = 'response'))
head(fitted.probabilities)
fitted.results <- ifelse(fitted.probabilities>0.5,1,0) # short cur way to write if-then-else
head(fitted.results)

### Metrics ###
mis.class.error <- mean(fitted.results != final.test$Survived)
accuracy <- 1 - mis.class.error
print(paste("Accuracy: ",accuracy))

# Confusion Matrix      
table(final.test$Survived, fitted.probabilities > 0.5)     # Actual Value, True Predictions


#############################
#### K Nearest Neighbors ####
#############################

#install.packages("ISLR")
library(ISLR)
str(Caravan) # we will predict whether the customer will purchase insurance from Caravan company
summary(Caravan$Purchase)
any(is.na(Caravan)) # no NA Values


purchase <- Caravan$Purchase

# Scale of the variables really matter since we are calculating distance
# need to standardize
var(Caravan[,1:2]) # variance (self) of 1st 2 entries is on a very different scale

standardize.Caravan <- scale(Caravan[,-86])
var(standardize.Caravan[,1:2]) # variance (self) of 1st 2 entries is on the same scale now

#Train Test Split
# We could so this using Catools as well

test.index <- 1:1000
test.data <- standardize.Caravan[test.index,]
test.purchase <- purchase[test.index]

train.data <- standardize.Caravan[-test.index,]
train.purchase <- purchase[-test.index]

#### 
library(class) # contains KNN algorithm calls
set.seed(101)

predicted.purchase <- knn(train.data,test.data,train.purchase,k=1)  # order is Train Data, Test Data, Train Predictions
head(predicted.purchase)

mis.class.error <- mean(predicted.purchase != test.purchase)
mis.class.error
accuracy <- 1 - mis.class.error
accuracy

# Choosing the K-value
k.max = 30
acc <- rep(0,k.max)
for (i in 1:k.max){
  set.seed(101) # important to set the seed each time you call any algorithm
  pred.purchase <- knn(train.data,test.data,train.purchase,k=i)  # order is Train Data, Test Data, Train Predictions
  misclass <-  mean(pred.purchase != test.purchase)
  acc[i] <- 1 - misclass
}

library(ggplot2)
acc <- as.data.frame(acc)
ggplot(acc,aes(seq(1:k.max),acc)) + geom_point()

###########################################
#### Decision Trees and Random Forests ####
###########################################

#install.packages('rpart')
library(rpart) # recusrive partitioning and decision trees
str(kyphosis) # type if deformation in spine; age ni months for kids, number = number of vertebra involved
head(kyphosis)

tree <- rpart(Kyphosis ~ .,method='class',data=kyphosis)
printcp(tree) # prints cp table
plot(tree,uniform=TRUE,main='My Tree') # plots the tree
text(tree, use.n=TRUE,all=TRUE)

# Visualization is much better in rpart.plot
#install.packages('rpart.plot')
library(rpart.plot)
prp(tree)

### Random Forest ###
#install.packages('randomForest')
library(randomForest)
rf.model <- randomForest(Kyphosis ~ .,method='class',data=kyphosis)
print(rf.model)

str(rf.model) # this is a list, we can call entries using the $ method
rf.model$ntree
rf.model$confusion

#######################################
#### Support Vector Machines (SVM) ####
#######################################
library(ISLR)
head(iris)

#install.packages('e1071')
library(e1071)
help(svm)

model <- svm(Species ~ ., data=iris)
# This shold really be done with a test set
pred.values <- predict(model,iris)
table(pred.values,iris$Species)

summary(model)
# Cost - allows SVM to have a soft margin (some examples can be placed on the wrong side of margin)
# Gamma - used for non linear kernels (like radial kernels), large Gamma >> small variance (large bias) -- double check this statement

# tune function performs grid search to tune the best parameters
tune.results <- tune(svm,train.x = iris[1:4],train.y = iris[,5],kernel='radial',ranges = list(cost=c(0.1,1,10),gamma=c(0.5,1,2)))   
summary(tune.results)

tune.results.alt <- tune(svm,train.x = Species ~ . ,data = iris,kernel='radial',ranges = list(cost=c(0.1,1,10),gamma=c(0.5,1,2)))
summary(tune.results.alt)

# fine tuning further
tune.results <- tune(svm,train.x = iris[1:4],train.y = iris[,5],kernel='radial',ranges = list(cost=seq(0.2,2,0.2),gamma=seq(0.1,1,0.1)))   
summary(tune.results)

# we get cost = 1, gamma = 0.1
tuned.svm <- svm(Species ~ .,data = iris,kernel = 'radial', cost = 1, gamma = 0.1)
summary(tuned.svm)

############################
#### K Means Clustering ####
############################

library(ISLR)
head(iris)

library(ggplot2)
ggplot(iris,aes(Petal.Width,Petal.Length,color=Species)) + geom_point()

set.seed(101)
# no additional library needed

irisCluster <- kmeans(iris[,1:4],3,nstart = 20 ) # data, K (groups), nstart = number of random starts you can do
irisCluster

# testing, in real world, you will not have this labelled data
table(irisCluster$cluster,iris$Species)

# cluster visualization
library(cluster)
# this plots the clusters against the 2 components that explain the most variability
# this is not very useful if you have a lot of features
clusplot(iris,irisCluster$cluster,color = TRUE, shade = TRUE, lines = 0) 


#####################################
#### Natural Language Processing ####
#####################################

# A document represented as a vector of word counts (features) is called "Bag of Words"
# you may use similarity methods such as cosine similarity to figure out if documents are related
# Bag of Words can be improved by using frequency in corpus (group of documents)
# We use TF-IDF (Term Frequency, Inverse Document Frequency)
# TF = Importance of term in that document
# IDF = Importance of term in Corpus

# install.packages("tm")
# install.packages("twitteR")
# install.packages("wordcloud")
# install.packages("RColorBrewer")
# install.packages("e1017")
# install.packages("class")

library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)

# Connect to twitter
consumer_key = 'N8HZxcDwJ0eWEyt7OwKeU72Rm'
consumer_secret = '6bnJ6wr4VP5hsbeZzbquYULN424mpRIbwO2YQR1SivMzb8xJJk'
access_token = '113640406-Bb1Y3roepYShWsLyAFunoJWyY9Gzv705iBtfIig8'
access_secret = 'CAIf47trCjWFjl9eihXG5QeRTUOIxwNJIJ3bgPG3fNoDM'
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# returning tweets
soccer.tweets <- searchTwitter('@TXInstruments',n=1000,lang='en') # 1000 most recent tweets in englisg that had soccor in it
# there are many other options available, for example, geographical location. search help for these

## get text from those tweets
soccer.text <- sapply(soccer.tweets,function(x) x$getText()) # using annonymous functons

# Clean the text
soccer.text <- iconv(soccer.text,'UTF-8','ASCII') ## removing emoticons and chars that are not in UTF-8

# develop a corpus
soccer.corpus <- Corpus(VectorSource(soccer.text))

### create a document term matrix ###
# removing puunctuation
# stopwords = common words that should be removed
# removing numbers
# converting everything to lower case
# we are using tm or text manipulation library here
term.doc.matrix <- TermDocumentMatrix(soccer.corpus,
                                      control = list(removePunctuation = TRUE,
                                                     stopwords=c('@TXInstruments','https','txinstruments',stopwords('english')),
                                                     removeNumbers = TRUE,
                                                     tolower = TRUE))

# convert term.doc.matrix object into a matrix
term.doc.matrix <- as.matrix(term.doc.matrix)

# get word counts
word.freq <- sort(rowSums(term.doc.matrix),decreasing = TRUE)
head(word.freq)
dm <- data.frame(word=names(word.freq),freq=word.freq)
head(dm)

# create a wordcloud
wordcloud(dm$word,dm$freq,random.order = FALSE,colors = brewer.pal(8,'Dark2'))


#########################
#### Neural Networks ####
#########################

install.packages('MASS')
library(MASS)
head(Boston)

# we will try to predict the median value of the houses

str(Boston)
any(is.na(Boston))

data <- Boston

# Need to normalize data for neural network. This is important
maxs <- apply(data,MARGIN = 2,max) # apply over columns
maxs
mins <- apply(data,MARGIN = 2,min) # apply over columns
mins

# center = value >> 'value' is subtracted form each point
# scale = value >> each point is going to be divided by 'value'
scaled.data <- scale(data,center=mins,scale=(maxs-mins))
scaled.data <- as.data.frame(scaled.data)
head(scaled.data)
head(data)

library(caTools)
set.seed(101)
split <- sample.split(scaled.data$medv,SplitRatio = 0.7)
train <- subset(scaled.data, split == TRUE)
test <- subset(scaled.data, split == FALSE)
str(train)
str(test)

#install.packages("neuralnet")
library(neuralnet)

n <- names(train)
f <- as.formula(paste("medv ~", paste(n[!n %in% "medv"], collapse = " + "))) # since neuralnet does not accept the standard . notation
f

# 2 hidden layers with 5 and 3 neurons
# linear.output = TRUE for continuous variable ; FALSE for categorical variable
nn <- neuralnet(f,train,hidden=c(5,3),linear.output = TRUE) # 2 hidden layers with 5 and 3 neurons
plot(nn)

# Predictions
predicted.nn.values <- compute(nn,test[1:13]) ## compute instead of predict as in previous cases
str(predicted.nn.values) 
## we want the net result from here and also unscale to actual values
true.predictions <- predicted.nn.values$net.result*(max(data$medv)-min(data$medv)) + min(data$medv)
test.r <- test$medv*(max(data$medv)-min(data$medv)) + min(data$medv) 

# Metrics
MSE.nn <- sum((test.r - true.predictions)^2)/nrow(test)
MSE.nn
error.df <- data.frame(test.r,true.predictions)
head(error.df)

library(ggplot2)
ggplot(error.df,aes(x=test.r,y=true.predictions)) + geom_point() + stat_smooth()
