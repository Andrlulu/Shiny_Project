

shinyServer(
  
  function(input,output, session){
    
    r_time_rating <- reactive(
      data %>% 
        mutate(work.balance.stars = as.numeric(work.balance.stars),
               culture.values.stars = as.numeric(culture.values.stars),
               carrer.opportunities.stars = as.numeric(carrer.opportunities.stars),
               comp.benefit.stars = as.numeric(comp.benefit.stars),
               senior.mangemnet.stars = as.numeric(senior.mangemnet.stars)) %>% 
        filter(work.balance.stars %in% c(0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0)) %>%
        filter(culture.values.stars %in% c(0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0)) %>% 
        filter(carrer.opportunities.stars %in% c(0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0)) %>% 
        filter(comp.benefit.stars %in% c(0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0)) %>% 
        filter(senior.mangemnet.stars %in% c(0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0))
    )
      
    wc_data_sum = reactive({
      input$update
      isolate({
        withProgress({
          setProgress(message = "Processing corpus....
                      ")
          getTermMatrix_sum(input$c_select)
        })
      })
    })
    
    wc_data_pro = reactive({
      input$update
      
      isolate({
        withProgress({
          setProgress(message = "Processing corpus....
                      ")
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
      wordcloud_rep(names(v1), v1, rot.per = 0.3,
                    min.freq = input$freq,
                    max.words = input$max,
                    colors = brewer.pal(8,"Dark2"))
      title(main="Word Cloud - Column Summary")
    })
    
    output$wcplot_pro = renderPlot({
      v2 = wc_data_pro()
      wordcloud_rep(names(v2), v2, rot.per = 0.3, 
                    min.freq = input$freq, max.words = input$max, 
                    colors = brewer.pal(8,"Dark2"),
                    main = "Title")
      title(main="Word Cloud - Column Pros")
    })
    
    output$wcplot_con = renderPlot({
      v3 = wc_data_con()
      wordcloud_rep(names(v3), v3, rot.per = 0.3,
                    min.freq = input$freq, max.words = input$max,
                    colors = brewer.pal(8,"Dark2"))
      title(main="Word Cloud - Column Cons")
    })

    output$wcplot_advice = renderPlot({
      v4 = wc_data_advice()
      wordcloud_rep(names(v4), v4, rot.per = 0.3,
                    min.freq = input$freq, max.words = input$max,
                    colors = brewer.pal(8,"Dark2"))
      title(main="Word Cloud - Column Advice to Management")
    })
    
# geo map us plot
    output$us_map <- renderGvis({
      data_map %>% filter(country_code == 'US', company %in% input$checkCompany1) %>% 
        group_by(state) %>% 
        summarise(number_review = n()) %>% 
        gvisGeoChart(., 'state', 'number_review',
                   options=list(region="US", 
                                displayMode="regions",
                                resolution="provinces",
                                width="auto", height="auto"))
    })
    
# geo map world
    output$world_map <- renderGvis({
      data_map %>% 
        filter(company %in% input$checkCompany1) %>% 
        group_by(country_code) %>% 
        summarise(number_review = n()) %>% 
        gvisGeoChart(., 'country_code', 'number_review')
    })
    
    output$current_former <- renderPlotly(
      data %>% 
        filter(is.anonymous == input$checkAnonymous) %>% 
        group_by(company, employee.status) %>% 
        summarise(n = n()) %>% 
        mutate(ratio = n/sum(n)) %>% 
        filter(company %in%  input$checkCompany) %>% 
        ungroup(company) %>% 
        ggplot(., aes(x = employee.status, y = ratio, group = company)) +
        geom_col(position = 'dodge', aes(fill = company)) +
        labs(title = "Ratio comparsion between current and former employee",
             x = '',
             y = 'Ratio')+
        theme_bw()+
        theme(legend.key = element_blank())
    )
    
    output$time_rating <- renderPlotly(
      r_time_rating() %>%
        group_by(year, company) %>% 
        summarise(avg = mean(get(input$Selection))) %>% 
        ungroup(company) %>% 
        ggplot(., aes(x = year, y = avg)) +
        geom_line(aes(color = company), size = 2) +
        labs(title = "Averge rating over time",
             x = 'Year',
             y = 'Average Rating') +
        theme_bw()
    )
    
    output$avg_rating <- renderPlotly(
      r_time_rating() %>% 
        group_by(company) %>% 
        summarise(avg = mean(get(input$Selection))) %>% 
        ungroup(company) %>% 
        ggplot(., aes(x = reorder(company, + avg), avg)) +
        geom_bar(stat = 'identity', colour = 'black', aes(fill = company))+
        coord_flip()+
        geom_text(aes(label = round(avg,2), y = avg/2), size = 4.5) +
        labs(title = "Overall Rating Comparison",
             x = 'Average Score',
             y = 'Company') +
        theme_bw()
    )
    
    
    output$boxplot <- renderPlotly(
      data %>% 
        filter(get(input$Selection) != 'none') %>% 
        group_by(company) %>% 
        ungroup(company) %>% 
        ggplot(aes(x = company, y = get(input$Selection))) +
        geom_boxplot(aes(group = company, fill = company)) +
        coord_flip() +
        labs(title = "Box plot for rating",
             x = 'Rating',
             y = 'Company') +
        theme_bw()
    )
    
    output$hist <- renderPlotly(
      data %>% 
        group_by(., company) %>% 
        summarise(., count = n() ) %>% 
        ungroup(company) %>% 
        ggplot(aes(x = reorder(company, -count), y = count)) + 
        geom_col(aes(fill = company)) +
        labs(title = "Review count by company",
             x = 'Company',
             y = 'Count') +
        theme_bw()
    )
    
    
    output$corr <- renderPlot(

      corrplot(cor(corr_p),method = "color", type = "upper",
               tl.col = 'black', tl.srt=45, addCoef.col = 'gray8', 
               diag =T, title = "Correlation between different ratings",
               mar= c(0,0,2,0))
 
    )
    
    # show statistics using infoBox
    output$Anonymous_Response_Ratio <- renderInfoBox({
      a_ratio = data %>% group_by(is.anonymous) %>% 
        summarise(n = n()) %>% 
        mutate(ratio = n/sum(n))
        infoBox('Anonymous Response Ratio', round(a_ratio$ratio[2],2) , icon = icon("hand-o-up"))
    })
    
    output$Total_Response <- renderInfoBox({
      total_row = data %>% summarise(n())
      infoBox('Total_Response', total_row[1], icon = icon("hand-o-down"))
    })
    
    output$Top_Correlation <- renderInfoBox(
      infoBox('Top Correlation: Overall & culture.value',
              0.76, 
              icon = icon("calculator")))
    
  }
)
