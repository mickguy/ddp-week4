# Sherlock Word Cloud ui.R
# Author: Mick Guy
# ui layout based on http://shiny.rstudio.com/gallery/bus-dashboard.html
# Minimum Frequency and Maximum number of words based on http://shiny.rstudio.com/gallery/word-cloud.html

source("miningsherlock.R")
library(stringr)
library(shiny)
library(shinydashboard)
library(leaflet)

header <- dashboardHeader(
  title = "Sherlock Word Cloud"
)

body <- dashboardBody(
  fluidRow(
    column(width = 8,
           box(width = NULL, solidHeader = TRUE,
               withTags({
                 div(class="header", checked=NA,
                    h3("Inspired by", a(href="http://sherlockholmes.io", "Sherlock Holmes and the Internet of Things"))
                )
               }),
               
               hr(),
               
               plotOutput("cloud")
           ),
           box(width=NULL,
               p(
                 "Right click or Ctrl click on word cloud to save image."
               )    
          ),          
           box(width = NULL,
               textInput("text", label = h3("Add Words separated by a comma and frequency as shown below:"), value = "AI Rotary Phone, 12,Voodoo Monkey, 14, Mask, 12, Maze, 14")
               
           )
    ),
    column(width = 4,
           box(width = NULL, title="Control Panel", status = "primary", solidHeader=TRUE,
               selectInput("selection", "Choose a book:", choices = sherlock.books, selected=sherlock.books[1], multiple=TRUE),
               p(
                 class = "text-muted",
                 "Click on the drop-down above to the right of the book name. Use the Ctrl key to select additional books. 
                       Remove a book by selecting it and pressing the delete key. Scroll to see the full list of books."
                ),
               hr(),
               sliderInput("min.freq",
                           "Minimum Word Frequency:",
                           min = 1,  max = 15, value = 7),
               p(
                 class = "text-muted",
                 "Decreasing the minimum word frequency increases the number of words visible in the word cloud. Too low a frequency may not fit into the available space. "
               ),
               hr(),
               sliderInput("max.words",
                           "Maximum Number of Words:",
                           min = 1,  max = 120,  value = 100),
              
               
               p(
                 class = "text-muted",
                 "The maximum number of words is dependent on the word frequency. A high frequency may not result in a sufficient number of available words."
               ),
               hr(),
               p(
                 a(href="https://github.com/mickguy/ddp-week4", "Fork on Github")
               )
               
            
           )
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)