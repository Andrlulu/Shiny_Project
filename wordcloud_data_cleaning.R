library(tm)
library(wordcloud)
library(dplyr)

data = read.csv("review_data.csv", header = TRUE)

google_summary = 
  data %>% 
    select(company,summary) %>% 
    filter(company == "google")

corpus_google_summary =
  Corpus(VectorSource(google_summary$summary))

corpus_google_summary[[1]][1]

# Text Cleaning

#convert the text to lower case
corpus_google_summary = 
  tm_map(corpus_google_summary, content_transformer(tolower))
#remove numbers
corpus_google_summary = 
  tm_map(corpus_google_summary, removeNumbers)
#remove english commom stopwords
corpus_google_summary = 
  tm_map(corpus_google_summary, removeWords,stopwords("english"))
# remove punctuations
corpus_google_summary = 
  tm_map(corpus_google_summary, removePunctuation)
# eliminate extra white spaces
corpus_google_summary = 
  tm_map(corpus_google_summary, stripWhitespace)
#Stemming Texts
#corpus_google_summary = 
#  tm_map(corpus_google_summary, stemDocument)

#remove additional stopwords
corpus_google_summary = tm_map(corpus_google_summary, 
                               removeWords, 
                               c("get","told","gave","took","can", "could"))
corpus_google_summary[[1]][1]

#Create TDM
tdm_google_summary = TermDocumentMatrix(corpus_google_summary)
m_google_summary = as.matrix(tdm_google_summary)
v_google_summary = sort(rowSums(m_google_summary), decreasing = TRUE)
d_google_summary = data.frame(word = names(v_google_summary), freq=v_google_summary)


#wordcloud
wordcloud(d_google_summary$word, d_google_summary$freq, random.order = FALSE, rot.per = 0.3, scale = c(4,0.5), max.words = Inf, colors = brewer.pal(8,"Dark2"))

