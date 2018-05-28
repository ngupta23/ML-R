library(ggplot2)
df <- read.csv('Economist_Assignment_Data.csv')
# could have also  done the following which is faster
#library(data.table)
#df <- fread('Economist_Assignment_Data.csv', drop =1) # drops 1st column whihc is the index
head(df)

pl <- ggplot(df,aes(x=CPI, y=HDI)) + geom_point(aes(color=Region),size=5,shape=1) # shape = 1 is empty circles, other numbers are other shapes
pl
pl2 <- pl + geom_smooth(color='red',method = lm,formula = y ~ log(x),se = FALSE)


pointsToLabel <- c("Russia", "Venezuela", "Iraq", "Myanmar", "Sudan",
                   "Afghanistan", "Congo", "Greece", "Argentina", "Brazil",
                   "India", "Italy", "China", "South Africa", "Spane",
                   "Botswana", "Cape Verde", "Bhutan", "Rwanda", "France",
                   "United States", "Germany", "Britain", "Barbados", "Norway", "Japan",
                   "New Zealand", "Singapore")

pl3 <- pl2 + geom_text(aes(label = Country),data = subset(df, Country %in% pointsToLabel), check_overlap = TRUE)
pl4 <- pl3 + theme_economist_white() +  scale_x_continuous(name='Corruption Perception Index, 2011 (10=Least corrupt)',limits = c(0,10),breaks = 1:10)
pl5 <- pl4 + scale_y_continuous(name='Human Development Index, 2011 (1=Best)',limits = c(0.2,1),breaks=seq(0.2,1,0.1)) 
pl5 + ggtitle('Corruption and Human Development')
