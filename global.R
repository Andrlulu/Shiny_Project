library(shinydashboard)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(tm)
library(wordcloud)
library(memoise)
library(corrplot)
library(stringr)
library(countrycode)
library(DT)
library(googleVis)



#read data set
data = read.csv('review_data.csv',stringsAsFactors=FALSE)

#input option:
choice = c('overall.ratings', 
           'work.balance.stars',
           'culture.values.stars',
           'carrer.opportunities.stars',
           'comp.benefit.stars',
           'senior.mangemnet.stars')

companies = c('google','amazon','facebook','netflix','apple','microsoft')

# data set for corr plot
corr_p = data %>%
  mutate(work.balance.stars = as.numeric(work.balance.stars),
         culture.values.stars = as.numeric(culture.values.stars),
         carrer.opportunities.stars = as.numeric(carrer.opportunities.stars),
         comp.benefit.stars = as.numeric(comp.benefit.stars),
         senior.mangemnet.stars = as.numeric(senior.mangemnet.stars)) %>%
  filter(work.balance.stars %in% c(0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0)) %>%
  filter(culture.values.stars %in% c(0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0)) %>%
  filter(carrer.opportunities.stars %in% c(0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0)) %>%
  filter(comp.benefit.stars %in% c(0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0)) %>%
  filter(senior.mangemnet.stars %in% c(0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0)) %>% 
  select(one_of(choice))

colnames(corr_p) <- c('overall','work.balance','culture.values',
                      'carrer.oppo','comp.benefit','senior.mange')
# cleaned a data set for mapping:
data_map = 
  data %>% 
    filter(., location != 'none') %>% 
    mutate(country = ifelse(str_detect(location, regex("\\)")) == FALSE, 
                            'United States of America', 
                            gsub(".*[(]([^.]+)[)].*","\\1",location))) %>% 
    mutate(country_code = countrycode(country,'country.name','iso2c')) %>% 
    mutate(city = ifelse(country_code=='US',gsub("([^.]+)[,].*",'\\1',location),NA)) %>% 
    mutate(state = ifelse(country_code == 'US', gsub(' ', '', paste('US-', gsub(".*[,]([^.]+).*", "\\1",location))), NA)) %>% 
    select(company,dates,country_code,city,state,choice)
  

# wordcloud:
getTermMatrix_sum = memoise(function(comp){
  
  summary = data %>% select(company,summary) %>% filter(company == comp)
  corpus_sum = Corpus(VectorSource(summary$summary))
  corpus_sum = tm_map(corpus_sum, content_transformer(tolower))
  corpus_sum = tm_map(corpus_sum, removeNumbers)
  corpus_sum = tm_map(corpus_sum, removeWords ,stopwords('english'))
  corpus_sum = tm_map(corpus_sum, removePunctuation)
  corpus_sum = tm_map(corpus_sum, stripWhitespace)
  corpus_sum = tm_map(corpus_sum, removeWords,c("get","told","gave","took","can", "could"))
  tdm_sum= TermDocumentMatrix(corpus_sum,control = list(minWordLength = 1))
  m_sum= as.matrix(tdm_sum)
  sort(rowSums(m_sum), decreasing = TRUE)
})

getTermMatrix_pro = memoise(function(comp){
  
  pro = data %>% select(company,pros) %>% filter(company == comp)
  corpus_pro = Corpus(VectorSource(pro$pros))
  corpus_pro = tm_map(corpus_pro, content_transformer(tolower))
  corpus_pro = tm_map(corpus_pro, removeNumbers)
  corpus_pro = tm_map(corpus_pro, removeWords ,stopwords('english'))
  corpus_pro = tm_map(corpus_pro, removePunctuation)
  corpus_pro = tm_map(corpus_pro, stripWhitespace)
  corpus_pro = tm_map(corpus_pro, removeWords,c("get","told","gave","took","can", "could"))
  tdm_pro = TermDocumentMatrix(corpus_pro,control = list(minWordLength = 1))
  m_pro = as.matrix(tdm_pro)
  sort(rowSums(m_pro), decreasing = TRUE)
})

getTermMatrix_con = memoise(function(comp){
  
  con = data %>% select(company,cons) %>% filter(company == comp)
  corpus_con = Corpus(VectorSource(con$cons))
  corpus_con = tm_map(corpus_con, content_transformer(tolower))
  corpus_con = tm_map(corpus_con, removeNumbers)
  corpus_con = tm_map(corpus_con, removeWords ,stopwords('english'))
  corpus_con = tm_map(corpus_con, removePunctuation)
  corpus_con = tm_map(corpus_con, stripWhitespace)
  corpus_con = tm_map(corpus_con, removeWords,c("get","told","gave","took","can", "could"))
  tdm_con = TermDocumentMatrix(corpus_con,control = list(minWordLength = 1))
  m_con = as.matrix(tdm_con)
  sort(rowSums(m_con), decreasing = TRUE)
})

getTermMatrix_advice = memoise(function(comp){
  
  advice.to.mgmt = data %>% select(company,advice.to.mgmt) %>% filter(advice.to.mgmt != 'none', company == comp)
  corpus_advice = Corpus(VectorSource(advice.to.mgmt$advice.to.mgmt))
  corpus_advice = tm_map(corpus_advice, content_transformer(tolower))
  corpus_advice = tm_map(corpus_advice, removeNumbers)
  corpus_advice = tm_map(corpus_advice, removeWords ,stopwords('english'))
  corpus_advice = tm_map(corpus_advice, removePunctuation)
  corpus_advice = tm_map(corpus_advice, stripWhitespace)
  corpus_advice = tm_map(corpus_advice, removeWords,c("get","told","gave","took","can", "could"))
  tdm_advice = TermDocumentMatrix(corpus_advice, control = list(minWordLength = 1))
  m_advice = as.matrix(tdm_advice)
  sort(rowSums(m_advice), decreasing = TRUE)
})






