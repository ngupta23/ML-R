library(ggplot2)
library(data.table)
df <- read.csv('Batting.csv')
head(df)
str(df)
df2 <- fread('Batting.csv') 
head(df2)
str(df2)

head(df$AB,5)
head(df$X2B)
head(df[['X2B']]) # another way to do this
head(df2$`2B`)

df['batting.avg'] <- df$H / df$AB
colnames(df)
head(df)
tail(df$batting.avg,5)

df['on.base.percent'] = (df$H + df$BB + df$HBP) / (df$AB + df$BB + df$HBP + df$SF)
df['slugging.percent'] = (1*(df$H-df$X2B-df$X3B-df$HR) + 2*df$X2B + 3*df$X3B + 4*df$HR) / df$AB

str(df)

sal <- read.csv('Salaries.csv')
head(sal)
str(sal)

library(dplyr)
df <- filter(df,yearID >= 1985)
# chrcking that filtering went well
str(df)
factor(df$yearID)
summary(df)
combo <- merge(df,sal,by=c('playerID','yearID'))

head(df)
head(sal)
head(combo)
summary(combo)

lost.players <- filter(combo,playerID == 'giambja01' | playerID == 'damonjo01' | playerID == 'saenzol01')
lost.players

lost.players <- filter(lost.players,yearID == 2001)
lost.players
lost.players <- select(lost.players,playerID,H,X2B,X3B,HR,on.base.percent,slugging.percent,batting.avg,AB)
lost.players

lost.players.sum.AB = summarize(lost.players,  sum(AB,na.rm = TRUE))
lost.players.sum.AB

lost.players.mean.OBP = summarize(lost.players,  mean(on.base.percent,na.rm = TRUE))
lost.players.mean.OBP

combo <- filter(combo,yearID == 2001, !is.na(AB), !is.na(on.base.percent))
combo <- arrange(combo,salary,AB,on.base.percent)
combo

ggplot(combo,aes(AB,on.base.percent)) + geom_point(aes(color=salary))

found.it = FALSE
found.players <- data.frame()
while (found.it == FALSE){
  found.players <- sample_n(combo,3)
  found.players.mean.OBP <- summarize(found.players,  mean(on.base.percent))
  found.players.sum.AB <- summarize(found.players,  sum(AB))
  found.players.sum.salary <- summarize(found.players,  sum(salary)) 
  if  (found.players.mean.OBP >= lost.players.mean.OBP){
    if (found.players.sum.AB >= lost.players.sum.AB){
      if (found.players.sum.salary < 15000000){
        found.it = TRUE  
      }
    }
  }
}


found.players.summarize <- function(){
  print ("Found 3 undervalued players: ")
  print (found.players)
  
  print (paste("Lost Player AB sum: ", lost.players.sum.AB))
  print (paste("Found Player AB sum: ", found.players.sum.AB))       
  
  print (paste("Lost Player OBP sum: ", lost.players.mean.OBP))
  print (paste("Found Player OBP sum: ", found.players.mean.OBP))
  
  print (paste("Found Player Salary sum: ", found.players.sum.salary))
  
}

found.players.summarize()

# Improvements Needed
# 1. Remove the 3 lost players from the combo list before searching for 3 new ones, else you might get same folks
# 2. Some anomalies may be present such as OBP = 1 (if someone only went to bat once and got on base. Remove them)

