

server = shinyServer(
  function(input,output){
    
    r_data = reactive({
      data %>% 
        select(company,input$Selection) %>% 
        group_by(company)
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
