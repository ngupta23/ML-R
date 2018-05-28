my.prod <- function(a=2,b=3){
  return(a*b)
}
my.prod(3,4)

num.check <- function(my.int, my.vec){
  for (i in my.vec){
    if (my.int == i)
      return(TRUE)
      
  }
  return(FALSE)
}
num.check(2,c(1,2,3))
num.check(2,c(1,4,5))

num.count <- function(my.int, my.vec){
  count <- 0
  for (i in my.vec){
    if (my.int == i)
      count <- count + 1
    
  }
  return(count)
}
num.count(2,c(1,1,2,2,3,3))
num.count(1,c(1,1,2,2,3,1,4,5,5,2,2,1,3))

bar.count <- function(wt){
  num <- as.integer(wt/5)
  num <- num + wt%%5
  return(num)
}
bar.count(6)
bar.count(17)

summer <- function(a,b,c){
  sum <- 0
  if (a %% 3 != 0){
    sum <- sum + a
  }
  if (b %% 3 != 0){
    sum <- sum + b
  }
  if (c %% 3 != 0){
    sum <- sum + c
  }
  return(sum)
}
summer(7,2,3)
summer(3,6,9)
summer(9,11,12)

prime.check <- function(num){
  if (num == 2){
    return (TRUE)
  }
  for (i in 2:(num-1)){
    if (num%%i == 0){
      return(FALSE)  
    }
  }
  return (TRUE)
}
prime.check(2)
prime.check(5)
prime.check(4)
prime.check(237)
prime.check(131)
