
  

ui= shinyUI(dashboardPage(
  
  dashboardHeader(title = "Reviews Exploration"),

  dashboardSidebar(
    sidebarMenu(
      sidebarMenu(
        menuItem("General_Review", tabName = "General_Review", icon = icon("hist")),
        menuItem("Rating_Review", tabName = "Selection", icon = icon("hist")),
        menuItem("Wordcloud", tabName = "wordcloud", icon = icon("wordcloud"))
      ),
      selectizeInput(inputId = "Selection",
                     label = "Select item to Display",
                     choices = choice),
      sidebarMenu(
        menuItem("Source code", icon = icon("file-code-o"),href = "https://github.com/Andrlulu/Shiny_Project")
      )
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "General_Review",
              box(plotOutput("hist"))
      ),
      
      tabItem(tabName = "Selection",
              box(plotOutput("boxplot"))
      ),
      
      tabItem(tabName = "wordcloud",
              "to be replaced with wordcloud")
    )
  )
)
)

