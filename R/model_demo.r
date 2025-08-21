## demo for runmulticox
rm(list = ls())
library(survival)
source("R/runmulticox.r")
data(lung)
head(lung)

lung$status <- ifelse(lung$status == 2, 1, 0)

result <- runmulticox(
  data = lung,
  main_var = c("age", "sex", "ph.ecog"),   
  covariates = c("ph.karno", "wt.loss"),    
  endpoint = c("time", "status")           
)

print(result)
