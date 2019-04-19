

server = shinyServer(
  function(input,output){
    
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