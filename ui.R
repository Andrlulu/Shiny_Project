
  

ui= shinyUI(dashboardPage(
  
  dashboardHeader(title = "Reviews Exploration"),

  dashboardSidebar(
    sidebarMenu(
      sidebarMenu(
        menuItem("General_Review", tabName = "General_Review", icon = icon("hist")),
        menuItem("Wordcloud", tabName = "wordcloud", icon = icon("wordcloud"))
      ),
      # selectizeInput("selected",
      #                "Select Company to Display",
      #                data$company),
      sidebarMenu(
        menuItem("Source code", icon = icon("file-code-o"),href = "https://github.com/Andrlulu/Shiny_Project")
      )
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "General_Review",
              fluidRow(
                box(plotOutput("hist"))
              )
      ),
      tabItem(tabName = "wordcloud",
              "to be replaced with wordcloud")
    )
  )
)
)

