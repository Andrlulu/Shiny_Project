library(shinydashboard)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(tm)
library(wordcloud)
library(memoise)
choice = c('overall.ratings', 
           'work.balance.stars',
           'culture.values.stars',
           'carrer.opportunities.stars',
           'comp.benefit.stars',
           'senior.mangemnet.stars')

data = read.csv('review_data.csv')

companies = c('google','amazon','facebook','netflix','apple','microsoft')
  
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






