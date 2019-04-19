library(dplyr)
library(ggplot2)
library(tidyverse)
source('helper.R')

review = read.csv("employee_reviews.csv", stringsAsFactors = FALSE)

# seperate job.title column in to several column since there is many information contained in this column.
review1 = separate(review, job.title, c('employee.status', 'position'), sep = '-')
head(review1)

# create boolean for if the response is from anonymous employee or not
review2 = 
  review1 %>% 
    mutate(., position = trimws(position, which = c('both'))) %>% 
    mutate(is.anonymous = ifelse(position == "Anonymous Employee", TRUE, FALSE))

# change the dates column to dates formate
review3 = review2 %>% 
    mutate(., dates = trimws(dates, which = c('both'))) %>% 
    mutate(., dates = as.Date(as.character(dates), '%b %d, %Y'))

# write cleaned dataframe into csv file
write.csv(review3, file='review_data.csv', row.names=F)

review3 %>% group_by(., company) %>% summarise(n = n())

