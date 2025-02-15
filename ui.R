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
fluidPage(
  theme = shinytheme("readable"),
  
  tags$style(HTML("
    .tabbable > .nav > li > a                  {background-color: lightcyan;  color:blue4}
    .tabbable > .nav > li[class=active]    > a {background-color: dodgerblue; color:white}
  ")),
  
  # Application title
  titlePanel("US Firms' Stock Performance During SARS-CoV-2 Pandemic: 
  How Changes in Stock Prices Correlate with Net COVID Sentiment in Earnings Calls"),
  
  # Drop down menu to select an industry of interest
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "Industry", 
        label = "Select an Industry",  # h3 is level 3 header
        choices = c("All", Company_Industry |> distinct(Industry) |>  pull() |> sort()), 
        selected = 1
      ),
      checkboxGroupInput(
        inputId = "Statistical_Significance",
        label = "Statistically Significant?",
        choices = c("Yes", "No"),
        selected = c("Yes", "No")
      ),
      selectizeInput(
        'Chosen_Firm', 
        'Enter Firm Name for Firm vs. Industry Stock Performance Comparison', 
        choices = NULL, 
        selected = NULL, 
        multiple = FALSE,
        options = NULL
      ),
      width = 3),
    # Main Panel's top portion has bar graph; bottom portion has table
    mainPanel(
      tabsetPanel(
        tabPanel(h4('Distribution of Correlations Across an Industry'), 
                 fluidRow(
                   column( 
                     width = 12, 
                     div(class = "dynamic_height"),
                     plotOutput("distPlot_Industry", height = "900px")
                   )
                 ),
                 fluidRow(
                   dataTableOutput("selecteddataTable")
                 )
        ),
        tabPanel(h4('Correlation: Net COVID Sentiment & Stock Price Changes'),  
                 fluidRow(
                   column( 
                     width = 12, 
                     div(class = "dynamic_height"),
                     plotOutput("distPlot_Firm", height = "900px")
                   )
                 )
        ),
        tabPanel(h4('Net COVID Sentiment & Stock Price Changes over Time'),  
                 fluidRow(
                   column( 
                     width = 12, 
                     div(class = "dynamic_height"),
                     plotOutput("distPlot_Time", height = "900px")
                   )
                 )
        )
      ),
      width = 9
    )
  )
) 
