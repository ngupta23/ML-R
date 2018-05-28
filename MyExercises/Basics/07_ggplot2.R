library(ggplot2)
library(ggthemes)
theme_set(theme_base())
head(mpg)

ggplot(mpg,aes(x=hwy)) + geom_histogram(color='red',fill='pink')
ggplot(mpg,aes(x=manufacturer)) + geom_bar(aes(fill=factor(cyl)))

    
head(txhousing)
ggplot(txhousing,aes(x=sales,y=volume)) + geom_point(alpha=0.5,color='blue') + geom_smooth(color='red',size=1.5)
 