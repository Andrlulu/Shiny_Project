library(shinydashboard)
library(shinythemes)
library(ggplot2)
library(dplyr)

data = read.csv('review_data.csv')
choice = c('overall.ratings', 
           'work.balance.stars',
           'culture.values.stars',
           'carrer.opportunities.stars',
           'comp.benefit.stars',
           'senior.mangemnet.stars')

