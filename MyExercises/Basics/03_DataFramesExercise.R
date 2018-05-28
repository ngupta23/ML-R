Age <- c(22,25,26)
Weight <- c(150,165,120)
Sex <- c('M','M','F')
names <- c('Sam','Frank','Amy')
df <- data.frame(Age,Weight,Sex,row.names = names)
df

is.data.frame(mtcars)

mat <- matrix(1:25,nrow=5)
df2 <- as.data.frame(mat)
df2

df <- mtcars
df[1:6,]

mean(df$mpg)
df[df$cyl ==6,]
df[c('am','gear','carb')]

df$performance <- df$hp / df$wt
head(df)
df$performance <- round(df$performance,2)
head(df)

mean(df[df$hp > 100 & df$wt > 2.5,'mpg'])

df['Hornet Sportabout','mpg']
