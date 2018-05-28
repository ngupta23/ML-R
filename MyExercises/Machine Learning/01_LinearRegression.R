# reading the data
df <- read.csv("bikeshare.csv")
head(df)
# We need to predict the "count" variable

###################################
#### EXPLORATORY DATA ANALYSIS ####
###################################

library(ggplot2)
library(caTools)

# Plotting count vs. temperature
ggplot(df,aes(temp,count)) + geom_point(alpha = 0.3,color='#56ae29')

str(df)
# Plotting count vs. datetime
# Need to convert datetime to POSIXct first
df$datetime <- as.POSIXct(df$datetime)
str(df)
ggplot(df,aes(datetime,count)) + geom_point(aes(color=temp)) + scale_color_gradient(low='blue',high='red')

# Corelation between variables
cor(df$count,df$temp)
library(corrgram)
corrgram(df)

# count vs. seasons
ggplot(df,aes(factor(season),count)) + geom_boxplot(aes(color=factor(season))) + theme_bw()

#############################
#### FEATURE ENGINEERING ####
#############################

# create an Hour column
df$hour <- as.POSIXlt(df$datetime)$hour
head(df,30)                                                

# below could also have been done by calling the dplyr library (a little cleaner)
# you can use scale_color_gradientn to specify a gradient of colors
working <- df[df['workingday'] == 1,] # may not need to create a variable here, just use it directly below
ggplot(working,aes(hour,count)) + geom_point(aes(color=temp,size=1),position=position_jitter(w=1, h=0)) + scale_color_gradient(low='blue',high='red')

nonworking <- df[df['workingday'] == 0,]
ggplot(nonworking,aes(hour,count)) + geom_point(aes(color=temp,size=1),position=position_jitter(w=1, h=0)) + scale_color_gradient(low='blue',high='red')
       
###########################
#### LINEAR REGRESSION ####
###########################

# predicting on temperature only
temp.model <- lm(count ~ temp , df)
summary(temp.model)
predict(temp.model,data.frame(temp=25)) # note you have to name temp explicitly and pass it as a dataframe

# predicting on many features
# note you can do factors(hour) or just hour, bth give different R2 values
full.model <- lm(count ~ season + holiday + workingday + weather + temp + humidity + windspeed + factor(hour), df)
# if you want to just remove some columns, use the '-' sign instead of the '+' sign
# example y ~ . - casual - datetime (note the . in there fo all date)
summary(full.model)

#### Note that linear model is not goof for time-series data ####

