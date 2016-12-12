library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(
  
  # Application title
  dashboardHeader(title="Cubs or Indians?"),
  
  # Sidebar with a selection input for types of plot
  dashboardSidebar(
    
      sidebarMenu( 
        menuItem("Introduction", tabName = "Introduction", icon = icon("dashboard")),
        menuItem("Sentiment Analysis", tabName = "figs", icon = icon("th"))      
      )
  ),
    
  # Body
  dashboardBody(
    # Intro
    tabItems(
      tabItem(tabName = "Introduction",
        h4("This shiny app shows the results of a sentiment analysis on 30,000 tweets (10,000 tweets from each location)
          collected from New York, Tornoto and California talking about their opinions on the 2016 MLB World Series."
        ),
        br(),
        h4("Below is the map of the three locations we extract tweets from:"),
        plotOutput("map")
      ),
      
      tabItem(tabName = "figs",
        h4(strong("Data collection:")),
        h4("Among 10,000 tweets, 5,000 of them contain the keyword #cubs and another 5,000 contains #indians.
           The sentiment word reference used here is obtained from bing."
        ),
        br(),
        h4("A typical sentiment analysis extracts the difference between number of positive words used and
           number of negative words used in a piece of information. Here you can choose to view the distribution
           of sentiment of all tweets or to view the individual tweet sentiment."),
        br(),
        h4(strong("Which team do you think got support more from people living in New York, Tornoto and California?")),
        br(),
        
        # Selection
        selectInput("plot_type",
                    h4(strong("Select a type of plot to figure out the answer!")),
                    list("Sentiment by team" = "total",
                         "Sentiment by tweeterID" = "sep",
                         "Sentiment by tweeterID & location" = "loc")
        ),
        br(),
        # Plot   
        plotOutput("Plot"),
        br(),
        
        # Print explanations
        h4(strong("Here's my opinion:")),
        textOutput("Text")
        
      )
      
      # Description of plot
    )
  )
  
))
