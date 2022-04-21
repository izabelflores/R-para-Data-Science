
# Exercícios R para data science - 11/09

# cap 2

y <-  seq(10, 1)
seq(10,1)
(y <-  seq(10, 1))

# 1. Por que o codigo nao funciona?

my_variable <- 10
my_variable

# dica 1 (ctrl ^) rever comando

# 2. Ajuste cada um dos comandos para executrem noormalmente

library(tidyverse)

# dica 2 (ggpl Tab)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)
filter(diamonds, carat >= 3)

# 3. o que acontece se apertar (alt shift k)?



## Respostas
#
## respostas

# 1. letra maiuscula

# 2.

library(tidyverse)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)
filter(diamonds, carat >= 3)


# cap 3

library(tidyverse) 
library(nycflights13)

view(flights)

# 1. filter

# a. voos 2 h ou mais de atraso

(atraso_2h <- filter(flights, arr_delay >= 2))

# b. 

(houston <- filter(flights, dest == "IAH" | dest == "HOU"))

# c.

(operados <- filter(flights, 
                    carrier == "UA" |
                      carrier == "AA" |
                      carrier == "DL"))

# d. partiram julho, agosto, setembor

(jul_ago_set <- filter(flights, month >= 7 & month <= 9 ))

# e. sairam sem atraso, chegaram 3 horas atrasados


# arrange

1. 
(na_comeco <- arrange(flights, is.na(flight)))


