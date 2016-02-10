func = function(x) {
  #do something, such as square a passed value of x
  minim = min(x)
  avg = mean(x)
  med = median(x)
  maxi = max(x)
  ran = range(x)
  stan = sd(x)
  cv = stan/avg
  
  info <- c(minim, avg, med, maxi, ran, cv)
  
  return(info) #if applicable, return something
}
Trees <- read.csv("./Trees.csv",header = TRUE,sep = ",")
attach(Trees)

func(z.m.)
