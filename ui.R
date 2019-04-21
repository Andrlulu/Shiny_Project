
  

shinyUI(dashboardPage(skin = "green",
  
  dashboardHeader(title = "FAANG Reviews Exploration", titleWidth = 350),

  dashboardSidebar(
    width = 350,
    sidebarMenu(
      sidebarMenu(
        menuItem("General_Review", tabName = "General_Review", icon = icon("file-export")),
        menuItem("Rating_Review", tabName = "Selection", icon = icon("bar-chart-o")),
        selectizeInput(inputId = "Selection", label = "Select item to Display", choices = choice),
        hr(),
        menuItem("Wordcloud", tabName = "wordcloud", icon = icon("cloud-download-alt")),
        selectizeInput(inputId = "c_select", label = "Choose a company",choices = companies),
        actionButton("update", "Change"),
        sliderInput(inputId = "freq", "Minimum Frequency:",min = 1, max = 50, value = 30),
        sliderInput(inputId = "max", label = "Maximum Number of Words:",min = 1, max = 300, value = 250)
      ),
      hr(),
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
              box(plotOutput("boxplot")),
              box(plotOutput('time_rating')),
              box(plotOutput('hist_rating'))
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

