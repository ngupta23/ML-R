
x <- 3

if (x%%2 == 0){
  print("x is even")
}else{
  print("x is odd")
}

x<- matrix()

if (is.matrix(x)){
  print("Is a matrix")
}else{
  print("Not a matrix")
}

v <- c(3,7,1)

for (i in order(v)){
  print (v[i])
}

if (v[1] > v[2] & v[1] > v[3]){
  print (v[1])
}else if (v[2] > v[1] & v[2] > v[3]){
  print (v[2])
}else{
  print (v[3])
}
  

