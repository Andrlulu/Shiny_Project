
  

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
      selectizeInput(inputId = "c_select",
                     label = "Choose a company",
                     choices = companies),
      actionButton("update", "Change"),
      hr(),
      sliderInput(inputId = "freq",
                  "Minimum Frequency:",
                  min = 1, max = 50, value = 15),
      sliderInput(inputId = "max",
                  label = "Maximum Number of Words:",
                  min = 1, max = 300, value = 100),
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
              box(plotOutput("wcplot_sum")),
              box(plotOutput('wcplot_pro')),
              box(plotOutput('wcplot_con')),
              box(plotOutput('wcplot_advice'))
              )
    )
  )
)
)

