# Introduction to R Basics

#### Console
# Clear the console with ctrl + L
# help(<topic) or ??vector
# e.g. help(vector) or ??vector

print(2^3)  # Power
print(5%%2) # Modulus

#### Variables #####

a <- 10 # Assignment
print (a)

# Style Guide for Variable Names
bank.account <- 100 # most common
bankAccount <- 100 # also found in R
bank_account <- 100 # not considered good in R

deposit <- 20
bank.account <- bank.account + deposit

#### R Data Types ####

# Numeric (Integer, Float)
# Logical (TRUE, FALSE) or (T, F)
b <- T
print(b)

# Character ("") or ('')
# double quotes are more common
c <- "hello"

# class funtion to check datatype
# similar to type in Python
print(class(a))
print(class(b))
print(class(c))

#### Vectors ####

# Combine Function c()

nvec <- c(1,2,3,4,5)
class(nvec)
cvec <- c("U","S","A")
class(cvec)
lvec <- c(T,F,T)
class(lvec)

# you can not have multiple data types in 1 vector
# R will try to type cast it
# List will allow you to mix different data types

v <- c(T, 20, 5)
class(v) # is of type numeric
print(v) # converts T to 1

v <- c("USA", 20, 5)
class(v) # is of type character
print(v)

# adding names to elements
temps <- c(72,71,68)
days <- c('Mon','Tue','Wed')
names(temps) <- days 
print(temps)

v1 <- c(1,2,3)
v2 <- c(5,6,7)
# Element wise operation
temp1 <- v1 + v2
temp2 <- v1 * v2
print (temp1)
print (temp2)

# Built In Functions
print (sum(v2)) # sum of elements
print (mean(v1)) # mean of elements
print (sd(v1)) # Standard Dev of elements
print (max(v2)) # Max of elements
print (min(v2)) # Min of elements
print (prod(v2)) # Product of elements

#### Vector Indexing and Slicing
# Indexing in R starts at 1
# vs. indexing in Python which starts at 0

v1 <- c(100,200,300)
v2 <- c('a','b','c')
print(v1[2])
print(v2[3])
print(v1[c(2,3)]) # passing a vector
print(v1[2:3]) # slicing way similar to Python

v <- c(1,2,3,4)
names(v) <- c('a','b','c','d')
print(v['b']) # calling single element by name
print(v[c('c','b','d')]) # calling multiple elements by name; order does not matter

## Comparison operation
print (5 >= 3)
print (2 == 3)
print (2 != 3)
print (v > 2) # element by element comparison
v2 <- c(4,3,2,1)
print (v >= v2)

## Logical masking
print (v[v>2]) # get all elements > 2 

#### Matrices ####
# 2D elements of same type

v <- 1:10 # creates a vector with 10 elements fromn 1 to 10
m <- matrix(v) # creates a matrix 10 rows, 1 column
print(m)

m <- matrix(v,nrow=5,ncol=2) # specify number of rows and columns
print(m)

# default fill is by columns
m <- matrix(1:12, byrow = FALSE, nrow = 4) # fils the matrix by columns - col1 then col2, etc...
print(m)

m <- matrix(1:12, byrow = T, nrow = 4) # fils the matrix by rows - row1 then row2, etc...
print(m)

goog <- c(450,451,452,445,468)
msft <- c(230,231,232,233,220)

stocks <- c(goog,msft)
print(stocks)

stock.matrix <- matrix(stocks, byrow = T, nrow = 2)
print(stock.matrix)

# similar to names function for vectors, we have colnames and rownames for matrix
days <- c('mon','tue','wed','thu','fri')
st.names <- c('GOOG','MSFT')

colnames(stock.matrix) <- days
rownames(stock.matrix) <- st.names

print (stock.matrix)

## Matrix Arithmetic
mat <- matrix(1:25,byrow=T, nrow = 5)
print(mat)
# element wise operations
print(mat*2)
print(mat/2)
print(mat^2)
print(1/mat)

mat2 <- mat[mat > 15]
print(mat > 15)
print(mat2) # note that this returns a vector, not a matrix

print (mat + mat)
print (mat %*% mat) # True matrix multiplication (Linear Algebra)

## Matrix Operations

#Column and Row suns
print (colSums(stock.matrix))
print (rowSums(stock.matrix))
#Column and Row Means
print (colMeans(stock.matrix))
print (rowMeans(stock.matrix))

# adding rows and cols - rbind, cbind

FB <- c(111,112,113,120,145)
tech.stocks <- rbind(stock.matrix,FB) # binds as a new row
print(tech.stocks)

avg <- rowMeans(tech.stocks)
tech.stocks <- cbind(tech.stocks,avg)
print(tech.stocks)

## Matrix Selection and Indexing
mat <-  matrix(1:50,byrow=T, nrow=5)
print(mat)
print(mat[1,]) # if you want the entire row, just leave col index BLANK
print(mat[,1])
print(mat[1:2,1:3]) # slicing notation to grab a subset
print(mat[,-9:-10]) # removes last 2 columns

## Factor and Categorical Matrices
animal <- c('d','c','d','c','c')
id <- c(1,2,3,4,5)
fact.ani <- factor(animal) 
# Nominal Categorical Variables (no order), e.g. animal
# Ordinal Categorical Variable (have order) e.g. temperature
temps <- c('cold','med','hot','hot','hot','cold','med')
fact.temps <- factor(temps,ordered = T, levels = c('cold','med','hot'))
print (fact.temps)
summary(fact.temps)
summary(temps)


#### Data Frames ####
# similar to matrix but unlike matrices, al elements need not be of the same type

# built in datasets
state.x77
USPersonalExpenditure
women
data() # all built in datasets availabel in R
head(state.x77) # first 6 rows
tail(state.x77) # last 6 rows

# summary 
str(state.x77) # structure
summary(state.x77) # summary statistics, generic function can be used with other data types as well

# creating dataframe
days # reusing earlier vector
temp <- c(22.2,21,23,24.3,25)
rain <- c(T,T,F,F,T)
df <- data.frame(days,temp,rain) # adds by columns
df

# Indexing and Selection
df[1,]
df[,1]
df[2:3,1:2]
df[,'rain']
df[1:5,c('days','temp')] # IMPORTANT slicing by name and multiple cols passed as vector
df$days # all values of a columns, equivalent to df['days'], but subtle difference in output, this gives a vector
df['days'] # stays in Data Frame format

# similar to logical masking, we have subsetting in Data Frames
subset(df,subset = rain==T)
subset(df,subset = temp>23)

# ordering a data frame using the order function
sorted.temp <- order(df['temp'])
sorted.temp
df[sorted.temp,] # pass dataframe in that order

desc.temp <- order(df['temp'],decreasing = T) # descending order
df[desc.temp,]

desc.temp2 <- order(-df['temp']) # descending order alternate using -ve sign
df[desc.temp2,]

desc.temp3 <- order(-df$temp) # another descending order alternate usinf $ and -ve sign
df[desc.temp3,]

## Overview of Data Frame Operations

empty <- data.frame()
empty

c1 <- 1:10
c2 <- letters[1:10] # letters is the inbuild vector of all letters (lowercase)

df <- data.frame(col.name.1 = c1,col.name.2 = c2) # explicitly naming columns (not relying on vector name)
df

# Importing and Exporting data

write.csv(df,file='saved.csv') # index is also saved as column
df2 <- read.csv('saved.csv')
df2

# info about a Dataframe
nrow(df)
ncol(df)
colnames(df)
rownames(df)
str(df)
summary(df)

# Referencing cells
df[5,2]
df[5,'col.name.2']
df[2,'col.name.1'] <- 9999 # assigning value to a single cell
df

df[1,] # rows

# Getting columns - 4 ways
head(mtcars)
mtcars$mpg # returns vector of values
mtcars[,'mpg'] # returns vector
mtcars[,1] # return vector
mtcars[['mpg']] # note double bracket -- returns vector
mtcars['mpg'] # note single bracket -- returns Data Frame

mtcars[c('cyl','mpg')] # getting multiple columns back

# adding rows
df2 <- data.frame(col.name.1 = 2000, col.name.2 = 'new')
df2
df
df.new <- rbind(df,df2)
df.new

# adding columns (2 ways)
df$new.col <- df$col.name.1 * 2 # 1st method
df
df[,'new.col2'] <- df$col.name.1
df

# renaming columns
colnames(df) <- c('1','2','3','4')
df
colnames(df)[1] <- 'new.col.name'
df

# selecting multiple rows
df[2:3,1:2]
df[-2,] # everythig but the second row

# conditional selection (2 ways)
mtcars[mtcars$mpg > 20,] # note there is a comma. 
# It is saying that the conditional statement is true of the rows, and give me all cols for those rows
subset(mtcars,subset = mpg > 20, select = c('hp','disp'))
mtcars[mtcars$mpg>20 & mtcars$cyl == 6 , c('hp','disp')]

# selecting multiple columns
mtcars[,c(1,2,3)]
mtcars[,c('mpg','hp')]

# missing data
any(is.na(mtcars))
any(is.na(mtcars$mpg))
df[is.na(df)] <- 'value'
df
mtcars$mpg[is.na(mtcars$mpg)] <- mean(mtcars$mpg) # replacing a column containing null values

###############
#### Lists ####
###############

# mainly used for organization tool, for data manipulation, we usually use data frames
v <- c(1,2,3)
m <- matrix(1:10,nrow=2)
df <- mtcars

# List allows to combine different vatiable into 1 variable
my.list <- list(v,m,df)
my.list # [[1]] 1st item in list, [[2]] 2nd item in list

## Naming and calling elements
my.named.list <- list(my.vec = v, my.mat = m, my.df = df) # naming the elements of a list
my.named.list # we get names with $ (so we can all it, instead if [[1]], etc.
# returns matrix (actual object stored)
class(my.named.list$my.mat) # this will return the matrix object not a list 
class(my.named.list[[2]]) # note double bracked, return format is matrix
# returns list (you can not manipulate it as a vector, matrix or dataframe - i.e. underlying object)
class(my.named.list['my.mat']) # this returns a list (similar to dataframes) - you can check this with class function
class(my.named.list[2]) # note single bracket notation, returns the list

# concatenating lists
double.list <- c(my.list, my.named.list)
double.list
str(double.list)

###############################
#### Data Input and Output ####
###############################

#### CSV Files ####

write.csv(mtcars,'cars.csv')
df <- read.csv('cars.csv')
df

#### Excel Files ####
## Install Packages ##
install.packages("readxl") # need quotes
library(readxl) # does no need quotes
excel_sheets('Sample-Sales-Data.xlsx') # reads the sheets of the excel
df <- read_excel('Sample-Sales-Data.xlsx',sheet='Sheet1') # each sheet can be read into a dataframe
head(df)
class(df)

# reading the entire excel file
entire.workbook <- lapply(excel_sheets('Sample-Sales-Data.xlsx'),read_excel,path='Sample-Sales-Data.xlsx')
entire.workbook

# write to excel file
install.packages("xlsx")
library(xlsx)
write.xlsx(mtcars,"mtcars.xlsx")


#### SQL (Structures Query Language) Files ####
install.packages('ROBDC')
# This will need lot of independent research to find the right package
# Google - Look for CRAN Package
# R-bloggers is also good for referencing on how to do something


#### Web Scrapping with R ####
#use import.io website (free from small use cases) if you have no knowledge of HTML and CSS
# otherwise use rvest package

install.packages('rvest')
library(rvest)
help(demo)
demo(package = 'rvest')
demo(package = 'rvest', topic = 'tripadvisor')
# Needs good knowlwdge of HTML, CSS and %>% operator

#### R Programming Basics ####

## Logical Operators ###
# & (AND), | (OR), ! (NOT)
x <- 10
x<20 & x>5 
(x<20) & (x>5) # add parenthesis for readbility, but not needed for corect syntax

df <- mtcars
df[df$mpg > 20,]
subset(df,mpg>20)

df[(df$mpg>20) & (df$hp>100),]


## If, Else, Else If statements
x <- 14
if(x==10){
  print (' x = 10')
}else if(x ==12){
  print ('x = 12')
}else{
  print('x is not 10 or 12')
}

## While loops ##
x <- 10
while (x > 0){
  print (paste('x is: ',x))
  x <- x-1
  if (x==5){
    print ("Ha Ha! breaking early!")
    break
  }
}

## For loops ##
v <- c(1,2,3)
for (var in v) {
  print (var)
} 

mat <- matrix(1:25, nrow=5,byrow = TRUE)
mat
for (item in mat){ # prints column wise
  print(item)
}

mat
for (i in 1:nrow(mat)){
  for (j in 1:ncol(mat)){
    print (mat[i,j])
  }
}

## Functions
my.pow <- function(arg1=3,arg2=4){
  var <- arg1^arg2
  return(var)
}
print (my.pow(2,3))
print (my.pow(2)) # using default values e.g. 1
print (my.pow()) # using default values e.g. 2


#### Advanced R Programming ####

# Sequence
seq(0,100,by=2) # start, end, step (by)
seq(0,100,10)

# sort
v <- c(1,4,7,2,13,3,11)
sort(v) # sorted version inn ascending order
sort(v,decreasing = TRUE) # descending order

cv <- c('b','d','a','C') # capital is treated same as non capital
sort(cv)

# reverse
rev(v)

# structure
str(v)
str(cv)
str(mtcars)

# append (works on vectors and lists)
v <- 1:10
v2 <- 35:40
append(v,v2)

# checking and converting datatype
is.array(v)
is.vector(v)
is.matrix(v)
is.data.frame(v)

l <- as.list(v)
l
m <- as.matrix(v)
m

#### Apply function ####
sample(1:10,5)
v <- 1:5
add.rand <- function(x){
  ran <- sample(1:100,1)
  return (x+ran)
}
add.rand(10)

lapply(v,add.rand) # applies function to every single element in the list, returns list
sapply(v,add.rand) # simplified apply function, returns vector

## Anonymous functions (similar to Lamdba expressions in Python)
sapply(v, function(num){num*2}) # function(input){return.value}

# Apply function with additinoal arguments
add.choice <- function(num,choice){
  return(num+choice)
}
add.choice(10,2)
sapply(v,add.choice,choice=2) # 1st arhument comes from iterating over v, 2nd argument is passed explicitly here
sapply(v,add.choice,2) # 1st arhument comes from iterating over v, 2nd argument is passed implicitly here (as 2)

#### Math Functions ####
abs(-2)
abs(c(-1,3,-10))
sum(c(2,3,4))
mean(c(3,6,1))
round(3.3)
round(3.5533, digits = 1)
round(3.55, digits = 1)

#### Regular Expressions ####
text <- "Hi there, do you know who you are voting for?"
grepl('voting',text) # returns logical true or false
grepl('dog',text)
grepl('do you',text)

v <- c('a','b','c','d','d')
grepl("b",v)
grep("d",v) # returns actual index

#### Date and Timestamp information ####
# Date information
today <- Sys.Date()
today
class(today)
c <- "1990-01-01"
class(c)
my.date <- as.Date(c)
class(my.date)
my.date <- as.Date("nov-02-90",format("%b-%d-%y")) # %b is month in 3 letter format, %y is year in 2 digit format
my.date
my.date <- as.Date("June,01,2002",format("%B,%d,%Y")) # %B is month in full format, %Y is year in 4 digit format
my.date

# Time Information
as.POSIXct("11:02:03",format="%H:%M:%S")
strptime("11:02:03",format="%H:%M:%S") # you can get codes for format by using help for this function


##################################
#### Data Manipulation with R ####
##################################

# dplyr >> For manipulating date
# tidyr >> For cleaning data

install.packages("dplyr")
install.packages("nycflights13")
library(dplyr)
library(nycflights13)

head(flights)

# filter -- similar to subset function
# easier to read and write than subset
head(filter(flights,month == 11,day == 3, carrier == 'AA'))
head(flights[flights$month == 11 & flights$day == 3 & flights$carrier == 'AA',]) # compare ease of writing for filter function

# slice - returns rows by position
slice(flights, 2:20) # returns rows from 2 to 20

# similar to filter, except it orders stuff
head(arrange(flights,year,month,day,arr_time)) # sorts in order, first by year, then by month, etc
head(arrange(flights,year,month,day,desc(arr_time)))

# select certain columns only
head(select(flights,carrier, arr_time))

# rename columns
head(rename(flights,airline.carrier=carrier, dist=distance)) # syntax new column name = old column name
# note that this does not change the original dataframe
 
# select distinct values in the table or column
distinct(flights, carrier)

# add new columns that are functions of existing columns
head(mutate(flights, new.col = arr_delay - dep_delay))

# similar to mutate, but only get the new columns
head(transmute(flights, new.col = arr_delay - dep_delay))

# collapse df to single row by using an aggregrate function
summarize(flights,avg.air.time = mean(air_time,na.rm = TRUE))
summarize(flights,total.air.time = sum(air_time,na.rm = TRUE))

# Sampling (takes a random number of rows or a random fraction of rows)
sample_n(flights,10) # takes a random sample of 10 rows
sample_frac(flights,0.01) # takes a random sample of 0.01 or 1% of rows


#### Pipe Operator %>% ####

df <- mtcars
# Nested operation
arrange(sample_n(filter(df,mpg>20),5),desc(mpg)) # dificult to read this code, hence use pipe operation
# Multiple assignments
a <- filter(df,mpg>20) 
b <- sample_n(a,5) 
c <- arrange(b,desc(mpg))  
c # problem here is that I am wasting a bunch of space in my memory by creating variables

# Hence we use pipe operator
# note that the data gets passed as 1st argument to the next step of the pipe operator
df %>% filter(mpg>20) %>% sample_n(5) %>% arrange(desc(mpg))

#### Tidying Data #####

install.packages("tidyr")
install.packages("data.table") # very much similar to data.frame, but faster than data.frame
install.packages("rlang") # not needed, but since tidyr would not work without this, I had to explicitly install it
library(tidyr)
library(data.table)

# gather (collapse multiple columns into key pair values)
comp <- c(1,1,1,2,2,2,3,3,3)
yr <- c(1998,1999,2000,1998,1999,2000,1998,1999,2000)
q1 <- runif(9, min=0, max=100)
q2 <- runif(9, min=0, max=100)
q3 <- runif(9, min=0, max=100)
q4 <- runif(9, min=0, max=100)

df <- data.frame(comp=comp,year=yr,Qtr1 = q1,Qtr2 = q2,Qtr3 = q3,Qtr4 = q4)
df # wide table
gather(df,Quarter,Revenue,Qtr1:Qtr4) # converts short-wide to tall-skinny 
# collapses the last argument (Qtr1:Qtr4) into a key-pair value (Quarter, Revenue)

# Spread is oppopsite of gather
# converts tall skinny to short wide
stocks <- data.frame(
  time = as.Date('2009-01-01') + 0:9,
  X = rnorm(10, 0, 1),
  Y = rnorm(10, 0, 2),
  Z = rnorm(10, 0, 4)
)
stocks
stocks.gathered <- stocks %>% gather(stock,price,X,Y,Z)
stocks.gathered

spread(stocks.gathered,stock,price)
stocks.gathered %>% spread(stock,price)
spread(stocks.gathered,time,price)

# Separate - turn a single char column into multiple columns
df <- data.frame(new.col=c(NA,"a.x","b.y","c.z"))
df
separate(df,new.col,c('ABC','XYZ')) # default separator is non-alpha numeric

df <- data.frame(new.col=c(NA,"a-x","b-y","c-z"))
df
separate(df,new.col,c('ABC','XYZ')) 

# explicitly specifying argument
df <- data.frame(new.col=c(NA,"a-x","b-y","c-z"))
df
df.sep <- separate(data = df,col = new.col, into = c('ABC','XYZ'), sep="-") 
df.sep

# unite - combines multiple columns into a single column
unite(df.sep,new.joined.col,ABC,XYZ,sep = '---')

############################
#### Data Visualization ####
############################

# ggplot2 has Layers 
#   - Mandatory : Data, Aesthetics, Geometries 
#       - Data        : Data variable to plot from
#       - Aesthetics  : What variables to plot from Data
#       - Geometries  : Type of plot, e.g. scatter, histogram, etc
#   - Optional  : Facets, Statistics, Coordinates, Themes (allow to customize plots)
#       - Facets      : Allow multiple plots on a single canvas
#       - Statistics  : Allows us to add some statistics
#       - Coordintes  : Alloes us to change X and Y range, etc
#       - Theme       : Color, Gridlines, etc

install.packages("ggplot2")
install.packages("ggplot2movies")

library(ggplot2)
library(ggplot2movies)

#### Histograms ####
# Data and Aesthetics
pl <- ggplot(movies, aes(x=rating))
# Geometry
pl2 <- pl + geom_histogram(binwidth=0.1,color='red',fill='blue',alpha=0.5,aes(fill=..count..)) # alpha sets transparency
pl3 <- pl2 + xlab('Movie Rating') + ylab('Count') # comes from Facet Layer
print (pl3 + ggtitle("Histogram of Ratings"))

pl2 <- pl + geom_histogram(binwidth=0.1,aes(fill=..count..)) # fill color by count number
pl3 <- pl2 + xlab('Movie Rating') + ylab('Count')
print (pl3 + ggtitle("Histogram of Ratings"))

#### Scatter Plot ####
# Data and Aesthetics
pl <- ggplot(mtcars,aes(x=wt,y=mpg))
# geometry
print(pl + geom_point(size=5,alpha=0.5))
print(pl + geom_point(size=5,color='#56ae29')) # google hex color
# NOTE: you can passs size, color outside of aes but then it is a fixed value
#       if you want it to be based on another column it has to be passed into the aes function
print(pl + geom_point(aes(size=hp))) # for sizing bubbles by continuous variable 'hp'
print(pl + geom_point(aes(size=factor(cyl)))) # for sizing bubbles by discrete variable 'cyl'
print(pl + geom_point(aes(shape=factor(cyl),color=factor(cyl)),size=3)) # Shape is preferred over size for discrete variables
print(pl + geom_point(aes(shape=factor(cyl),color=hp),size=3)) # color by continuous variable

pl2 <- pl + geom_point(aes(color=hp),size=3) # default color gradient based on 'hp'
pl3 <- pl2 + scale_color_gradient(low='blue',high='red') # add color gradient to 'hp'
print(pl3)

#### Bar Plot ####
# similar to histogram, but has categorical data on x axis, histogram had continuous data
df <- mpg
head(df)
pl <- ggplot(df,aes(x=class))
print(pl + geom_bar())
print(pl + geom_bar(aes(fill=drv),position='fill')) # similar to histogram, if we want to fill by another column, we pass the aes argument to geom
# position = 'dodge' allows to stack separately
# position = 'fill' > Instead of count, it shows position
# google to find all arguments

#### Box Plot ####
df <- mtcars
pl <- ggplot(df,aes(x=factor(cyl),y=mpg))
print(pl + geom_boxplot())
print(pl + geom_boxplot() + coord_flip()) # adding a coordinate layer
print(pl + geom_boxplot(aes(fill=factor(cyl))))


#### 2 variable Plotting ####
library(ggplot2movies)
pl <- ggplot(movies,aes(x=year,y=rating))
pl + geom_bin2d() # sort of a heatmap for # occurances of that rating in that year
pl + geom_bin2d() + scale_fill_gradient(high='red',low='blue')
pl + geom_bin2d(binwidth=c(3,1))

install.packages('hexbin')
pl + geom_hex() + scale_fill_gradient(high='red',low='blue')

# 2D density Plot
pl + geom_density2d()

#### Coordinates and faceting ####
pl <- ggplot(mpg,aes(x=displ,y=hwy)) + geom_point()
pl

pl + coord_cartesian(xlim = c(1,4),ylim = c(15,30)) # resizing x and y scales
pl + coord_fixed(ratio = 0.33) # changing aspect ratio

# Facet grid
help("facet_grid")
pl + facet_grid(. ~ cyl) # what you want to facet on the x axis ~ what you want to facet on the y axis
pl + facet_grid(drv ~ cyl) # faceting by 2 dimentions

#### Themes ####
theme_set(theme_dark()) # adds to all future plots
pl <- ggplot(mtcars,aes(x=wt,y=mpg)) + geom_point()
pl + theme_light() # adding theme to specific plots

install.packages('ggthemes')
library(ggthemes)
pl + theme_economist() # emulating Economist Magazine theme
pl + theme_wsj() # I like this one
pl + theme_fivethirtyeight()

################################################
#### Interactive Visualizations with Plotly ####
################################################

install.packages("plotly")
library(plotly)
# Regular plot
pl <- ggplot(mtcars,aes(mpg,wt)) + geom_point()
pl
#interactive plot
gpl <- ggplotly(pl)
gpl
## More examples can be found here: https://plot.ly/ggplot2/
