

server = shinyServer(
  
  function(input,output, session){
    
    wc_data_sum = reactive({
      input$update
      
      isolate({
        
        withProgress({
          setProgress(message = "Processing corpus...")
        })
        
      })
      summary = data %>% select(company,summary) %>% filter(company == input$c_select)
      corpus_sum = Corpus(VectorSource(summary$summary))
      corpus_sum = tm_map(corpus_sum, content_transformer(tolower))
      corpus_sum = tm_map(corpus_sum, removeNumbers)
      corpus_sum = tm_map(corpus_sum, removeWords ,stopwords('english'))
      corpus_sum = tm_map(corpus_sum, removePunctuation)
      corpus_sum = tm_map(corpus_sum, stripWhitespace)
      corpus_sum = tm_map(corpus_sum, removeWords,c("get","told","gave","took","can", "could"))
      tdm_sum= TermDocumentMatrix(corpus_sum,control = list(minWordLength = 1))
      m_sum= as.matrix(tdm_sum)
      v_sum = sort(rowSums(m_sum), decreasing = TRUE)
      d_sum = data.frame(word = names(v_sum), freq=v_sum)
    })
    
    wc_data_pro = reactive({
      input$update
      
      isolate({
        
        withProgress({
          setProgress(message = "Processing corpus...")
        })
        
      })
      
      pro = data %>% select(company,pros) %>% filter(company == input$c_select)
      corpus_pro = Corpus(VectorSource(pro$pros))
      corpus_pro = tm_map(corpus_pro, content_transformer(tolower))
      corpus_pro = tm_map(corpus_pro, removeNumbers)
      corpus_pro = tm_map(corpus_pro, removeWords ,stopwords('english'))
      corpus_pro = tm_map(corpus_pro, removePunctuation)
      corpus_pro = tm_map(corpus_pro, stripWhitespace)
      corpus_pro = tm_map(corpus_pro, removeWords,c("get","told","gave","took","can", "could"))
      tdm_pro = TermDocumentMatrix(corpus_pro,control = list(minWordLength = 1))
      m_pro = as.matrix(tdm_pro)
      v_pro = sort(rowSums(m_pro), decreasing = TRUE)
      d_pro = data.frame(word = names(v_pro), freq=v_pro)
      
    })
    
    wc_data_con = reactive({
      input$update
      
      isolate({
        
        withProgress({
          setProgress(message = "Processing corpus...")
        })
        
      })

      
      con = data %>% select(company,cons) %>% filter(company == input$c_select)
      corpus_con = Corpus(VectorSource(con$cons))
      corpus_con = tm_map(corpus_con, content_transformer(tolower))
      corpus_con = tm_map(corpus_con, removeNumbers)
      corpus_con = tm_map(corpus_con, removeWords ,stopwords('english'))
      corpus_con = tm_map(corpus_con, removePunctuation)
      corpus_con = tm_map(corpus_con, stripWhitespace)
      corpus_con = tm_map(corpus_con, removeWords,c("get","told","gave","took","can", "could"))
      tdm_con = TermDocumentMatrix(corpus_con,control = list(minWordLength = 1))
      m_con = as.matrix(tdm_con)
      v_con = sort(rowSums(m_con), decreasing = TRUE)
      d_con = data.frame(word = names(v_con), freq=v_con)

    })
    
    wc_data_advice = reactive({
      input$update
      
      isolate({
        
        withProgress({
          setProgress(message = "Processing corpus...")
        })
        
      })
      
      advice.to.mgmt = data %>% select(company,advice.to.mgmt) %>% filter(company == input$c_select)
      corpus_advice = Corpus(VectorSource(advice.to.mgmt$advice.to.mgmt))
      corpus_advice = tm_map(corpus_advice, content_transformer(tolower))
      corpus_advice = tm_map(corpus_advice, removeNumbers)
      corpus_advice = tm_map(corpus_advice, removeWords ,stopwords('english'))
      corpus_advice = tm_map(corpus_advice, removePunctuation)
      corpus_advice = tm_map(corpus_advice, stripWhitespace)
      corpus_advice = tm_map(corpus_advice, removeWords,c("get","told","gave","took","can", "could"))
      tdm_advice = TermDocumentMatrix(corpus_advice, control = list(minWordLength = 1))
      m_advice = as.matrix(tdm_advice)
      v_advice = sort(rowSums(m_advice), decreasing = TRUE)
      d_advice = data.frame(word = names(v_advice), freq=v_advice)
    })
    
# Make the wordcloud drawing predictable during a session
    wordcloud_rep = repeatable(wordcloud)
    
    output$wcplot_sum = renderPlot({
      withProgress({
        setProgress(message = "Creating Wordcloud...")
        
      v1 = wc_data_sum()
      wordcloud_rep(v1$word, v1$freq, rot.per = 0.3, min.freq = input$freq, max.words = input$max, colors = brewer.pal(8,"Dark2"))
        
      })
    })
    
    output$wcplot_pro = renderPlot({

      v2 = wc_data_pro()
      wordcloud_rep(v2$word, v2$freq, rot.per = 0.3, min.freq = input$freq, max.words = input$max, colors = brewer.pal(8,"Dark2"))
      
    })

    output$wcplot_con = renderPlot({

      v3 = wc_data_con()
      wordcloud_rep(v3$word, v3$freq, rot.per = 0.3, min.freq = input$freq, max.words = input$max, colors = brewer.pal(8,"Dark2"))
      
    })

    output$wcplot_advice = renderPlot({

      v4 = wc_data_advice()
      wordcloud_rep(v4$word, v4$freq, rot.per = 0.3, min.freq = input$freq, max.words = input$max, colors = brewer.pal(8,"Dark2"))
    })
    
    
    
    
    
    
    output$boxplot <- renderPlot(
      data %>% 
        filter(get(input$Selection) != 'none') %>% 
        group_by(company) %>% 
        ggplot(aes(x = company, y = get(input$Selection))) +
        geom_boxplot(aes(group = company, fill = company)) +
        coord_flip()
    )
    
    output$hist <- renderPlot(
      data %>% 
        group_by(., company) %>% 
        summarise(., count = n() ) %>% 
        ggplot(aes(x = reorder(company, -count), y = count)) + 
        geom_col(aes(fill = company)) +
        ggtitle("Review count by company")
    )  
    

    
  }
)
