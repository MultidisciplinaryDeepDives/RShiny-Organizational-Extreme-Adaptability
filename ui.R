#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
fluidPage(theme = shinytheme("readable"),
   
  # Application title
  titlePanel("Industry-Wide Stock Performance During SARS-CoV-2 Pandemic: How Changes in Stock Prices Correlate with Net COVID Sentiment in Earnings Calls"),
  
  # Drop down menu to select an industry of interest
  sidebarLayout(
    sidebarPanel(
      selectInput("Industry", 
        label = h3("Select an Industry"),  # h3 is level 3 header
        choices = c("All", Company_Industry |> distinct(Industry) |>  pull() |> sort()), 
        selected = 1),
      width = 3
    ),
    
    # Main Panel's top portion has bar graph; bottom portion has table
    mainPanel(
      
      fluidRow(
        column( 
          width = 12, 
          div(class = "dynamic_height"),
          plotOutput("distPlot", height = "900px")
        )
      ),
      fluidRow(
        dataTableOutput("selecteddataTable")
      ),
      width = 9
    )
  )
)


