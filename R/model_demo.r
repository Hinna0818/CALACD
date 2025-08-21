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

## demo for data visualization with ggplot2
library(ggplot2)
lung$sex <- factor(lung$sex)

p1 <- ggplot(data = lung, aes(x = time, y = age, color = sex)) + geom_point()
p1

p2 <- p1 + geom_smooth(method = "lm")
p2

p3 <- ggplot(data = lung, mapping = aes(x = time, y = age)) + 
  geom_point(mapping = aes(color = sex)) + 
  geom_smooth(method = "lm")

p3

p4 <- ggplot(data = lung, mapping = aes(x = time, y = age)) + 
  geom_point(mapping = aes(color = sex, shape = sex)) + 
  geom_smooth(method = "lm")

p4

p5 <- p4 + labs(
  title = "time vs age",
    x = "time (years)", 
    y = "age (years)",
    color = "sex",
    shape = "sex"
)

p5

p6 <- ggplot(lung, aes(x = sex)) + geom_bar()
p6

p7 <- lung[!is.na(lung$meal.cal), ] |> 
  ggplot(aes(x = meal.cal)) +
  geom_histogram(binwidth = 200)

p7

p8 <- lung[!is.na(lung$meal.cal), ] |> 
  ggplot(aes(x = meal.cal)) +
  geom_density()
p8


p9 <- ggplot(lung, aes(x = sex, y = meal.cal)) +
  geom_boxplot()
p9

p10 <- ggplot(lung, aes(x = time, y = age)) +
  geom_point(aes(color = sex, shape = sex)) + 
  facet_wrap(~status)

p10
