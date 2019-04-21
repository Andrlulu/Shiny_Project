

shinyServer(
  
  function(input,output, session){
    r_time_rating <- reactive(
      data %>% 
        mutate(work.balance.stars = as.numeric(work.balance.stars),
               culture.values.stars = as.numeric(culture.values.stars),
               carrer.opportunities.stars = as.numeric(carrer.opportunities.stars),
               comp.benefit.stars = as.numeric(comp.benefit.stars),
               senior.mangemnet.stars = as.numeric(comp.benefit.stars)) %>% 
        filter(work.balance.stars %in% c(0,0.5,1,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5)) %>%
        filter(culture.values.stars %in% c(0,0.5,1,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5)) %>% 
        filter(carrer.opportunities.stars %in% c(0,0.5,1,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5)) %>% 
        filter(comp.benefit.stars %in% c(0,0.5,1,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5)) %>% 
        filter(senior.mangemnet.stars %in% c(0,0.5,1,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5))
    )
      
    wc_data_sum = reactive({
      input$update
      isolate({
        withProgress({
          setProgress(message = "Processing corpus...")
          getTermMatrix_sum(input$c_select)
        })
      })
    })
    
    wc_data_pro = reactive({
      input$update
      isolate({
        withProgress({
          setProgress(message = "Processing corpus...")
          getTermMatrix_pro(input$c_select)
        })
      })
    })

    wc_data_con = reactive({
      input$update
      isolate({
        withProgress({
          setProgress(message = "Processing corpus...")
          getTermMatrix_con(input$c_select)
        })
      })
    })

    wc_data_advice = reactive({
      input$update
      isolate({
        withProgress({
          setProgress(message = "Processing corpus...")
          getTermMatrix_advice(input$c_select)
        })
      })
    })
    
# Make the wordcloud drawing predictable during a session
    wordcloud_rep = repeatable(wordcloud)
    output$wcplot_sum = renderPlot({

      v1 = wc_data_sum()
      wordcloud_rep(names(v1), v1, rot.per = 0.3,min.freq = input$freq, max.words = input$max, colors = brewer.pal(8,"Dark2"))
    })
    output$wcplot_pro = renderPlot({
      v2 = wc_data_pro()
      wordcloud_rep(names(v2), v2, rot.per = 0.3, min.freq = input$freq, max.words = input$max, colors = brewer.pal(8,"Dark2"))
    })
    output$wcplot_con = renderPlot({
      v3 = wc_data_con()
      wordcloud_rep(names(v3), v3, rot.per = 0.3, min.freq = input$freq, max.words = input$max, colors = brewer.pal(8,"Dark2"))
    })
    output$wcplot_advice = renderPlot({
      v4 = wc_data_advice()
      wordcloud_rep(names(v4), v4, rot.per = 0.3, min.freq = input$freq, max.words = input$max, colors = brewer.pal(8,"Dark2"))
    })
    
    output$hist_rating <- renderPlot(
      r_time_rating() %>%
        filter(company == input$c_select) %>% 
        ggplot(aes(x = get(input$Selection))) +
        geom_histogram(binwidth = 0.5, bins = 10)
      )
    
    output$time_rating <- renderPlot(
      r_time_rating() %>%
        group_by(year, company) %>% 
        summarise(avg = mean(get(input$Selection))) %>% 
        ggplot(., aes(x = year, y = avg)) +
        geom_line(aes(color = company))
    )
    
    
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
