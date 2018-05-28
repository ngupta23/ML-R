# get the data
adult <- read.csv("adult_sal.csv")
head(adult)
str(adult)
factor(adult$education_num)

# Removing redundant index column
adult$X <- NULL
str(adult)

# you can also do this with the dplyr library
# library(dplyr)
# adult <- select(adult,-X)

summary(adult)


### reducing the number of factors
# for employer type
table(adult$type_employer) # nice way to make a table


combine.unemployed <- function (job){
  if (job == 'Never-worked' | job == 'Without-pay'){
    return ("Unemployed")
  }
  else{
    return(as.character(job)) # since type_employer is a factor, it returns numbers instead of the characters
  }
}

adult$type_employer <- sapply(adult$type_employer,combine.unemployed)
table(adult$type_employer) # nice way to make a table

combine.sl.gov <- function (job){
  if (job == 'State-gov' | job == 'Local-gov'){
    return ("SL-gov")
  }
  else{
    return(as.character(job)) # since type_employer is a factor, it returns numbers instead of the characters
  }
}

adult$type_employer <- sapply(adult$type_employer,combine.sl.gov)
table(adult$type_employer) # nice way to make a table

combine.self.empl <- function (job){
  if (job == 'Self-emp-inc' | job == 'Self-emp-not-inc'){
    return ("Self-empl")
  }
  else{
    return(as.character(job)) # since type_employer is a factor, it returns numbers instead of the characters
  }
}

adult$type_employer <- sapply(adult$type_employer,combine.self.empl)
table(adult$type_employer) # nice way to make a table

### reducing the number of factors
# for maritial status

table(adult$marital)

combine.married <- function (married.status){
  if (married.status == 'Married-AF-spouse' | married.status == 'Married-civ-spouse' | married.status == 'Married-spouse-absent'){
    return ("Married")
  }
  else{
    return(as.character(married.status)) # since type_employer is a factor, it returns numbers instead of the characters
  }
}

adult$marital <- sapply(adult$marital,combine.married)
table(adult$marital) # nice way to make a table

combine.not.married <- function (married.status){
  if (married.status == 'Divorced' | married.status == 'Separated' | married.status == 'Widowed'){
    return ("Not-Married")
  }
  else{
    return(as.character(married.status)) # since married is a factor, it returns numbers instead of the characters
  }
}

adult$marital <- sapply(adult$marital,combine.not.married)
table(adult$marital) # nice way to make a table

### reducing the number of factors
# for countries

Asia <- c('China','Hong','India','Iran','Cambodia','Japan', 'Laos' ,
          'Philippines' ,'Vietnam' ,'Taiwan', 'Thailand')

North.America <- c('Canada','United-States','Puerto-Rico' )

Europe <- c('England' ,'France', 'Germany' ,'Greece','Holand-Netherlands','Hungary',
            'Ireland','Italy','Poland','Portugal','Scotland','Yugoslavia')

Latin.and.South.America <- c('Columbia','Cuba','Dominican-Republic','Ecuador',
                             'El-Salvador','Guatemala','Haiti','Honduras',
                             'Mexico','Nicaragua','Outlying-US(Guam-USVI-etc)','Peru',
                             'Jamaica','Trinadad&Tobago')
Other <- c('South')

combine.countries <- function (country){
  if (country %in% Asia ){
    return ("Asia")
  }
  else if (country %in% North.America){
    return ("North.America")
  }
  else if (country %in% Europe){
    return ("Europe")
  }
  else if (country %in% Latin.and.South.America){
    return ("Latin.and.South.America")
  }
  else{
    return("Other") # since country is a factor, it returns numbers instead of the characters
  }
}

adult$country <- sapply(adult$country,combine.countries)
table(adult$country) # nice way to make a table


# columns that were changed from factor type should be changed back.
str(adult)

adult$type_employer <- factor(adult$type_employer)
adult$marital <- factor(adult$marital)
adult$country <- factor(adult$country)

str(adult)

### Missing Data ###
library(Amelia)
adult[adult == "?" | adult ==" ?"] <- NA

table(adult$type_employer)
adult$type_employer <- factor(adult$type_employer)

missmap(adult,main = 'Missing Map', col = c('yellow','black'), legend = TRUE)

adult <- na.omit(adult)
missmap(adult,main = 'Missing Map', col = c('yellow','black'), legend = TRUE)

###################################
#### Exploratory Data Analysis ####
###################################

library(ggplot2)

ggplot(adult,aes(age)) + geom_histogram(alpha=0.3,aes(fill=income),color='black')
ggplot(adult,aes(hr_per_week)) + geom_histogram(alpha=0.3,fill='lightblue',color='blue')

colnames(adult)[colnames(adult) == "country"] <- 'region'
str(adult)
         
ggplot(adult,aes(region)) + geom_bar(alpha=0.3,aes(fill=income),color='black') + coord_flip() 

#############################
#### Logistic Regression ####
#############################

library(caTools)

set.seed(101) # Set a Seed for reproducible results

sample <- sample.split(adult$income,SplitRatio = 0.7)  
sample
train <- subset(adult,sample == TRUE)
test <- subset(adult,sample == FALSE)

str(train)
str(test)

log.model <- glm(income ~ ., family = binomial(link = 'logit'),data=train)  # generalized Linear Model -- used for Logistic Regression 
summary(log.model)

new.model <- step(log.model)
summary(new.model)

#################
#### Metrics ####
#################

### Confusion Matrix
fitted.probabilities <- (predict(new.model,test,type = 'response'))
table(test$income, fitted.probabilities > 0.5)     # Actual Value, True Predictions

head(fitted.probabilities,20)

fitted.results <- ifelse(fitted.probabilities>0.5,1,0)
head(fitted.results,20)

test$income <- ifelse(test$income == ">50K",1,0)

mis.class.error <- mean(fitted.results != test$income)
accuracy <- 1 - mis.class.error
print(paste("Accuracy: ",accuracy))

#install.packages('caret')
#install.packages('e1071')
library(caret)
library(e1071)

test$income <- factor(test$income)
fitted.results <- factor(fitted.results)
factor(test$income)

factor(fitted.results)
confusionMatrix(fitted.results, test$income)

