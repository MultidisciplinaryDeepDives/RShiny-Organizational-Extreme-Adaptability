#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {
  
  plot_data_func <- reactive({
    
    plot_data <- Firm_Industry_Random_Effect_Coeff_Desc |>  select(Company = level, "% Change in Excess of Industry" = estimate, "Standard Error" = std.error, Industry)
    
    if (input$Industry != "All"){
      plot_data <- plot_data |> 
        filter(Industry == input$Industry)
    }
    
    return(plot_data)    
  })
  
  
  output$distPlot <- renderPlot({
    
    title <- glue("Further Changes in Stock Prices Among {input$Industry} Firms in Relation to Industry, as Distilled by Mixed-Effect Hierarchical Model Linear Regression Analysis")
    
    if (input$Industry != "All"){
      title <- glue("Further Changes in Stock Prices Among {input$Industry} Firms in Relation to Industry, as Distilled by Mixed-Effect Hierarchical Model Linear Regression Analysis")
    }
    
    plot_data_func() |> 
      ggplot(aes(x=reorder(Company, `% Change in Excess of Industry`), y = `% Change in Excess of Industry`, fontface = "bold")) +  
      geom_bar(stat="identity", fill = 'steelblue') + 
      coord_flip() +
      theme_minimal() +
      labs(
        x = "Companies",
        y = "Additional % of Change in Stock Price from Industry Average",
        title = title,
        face = "bold"
      ) +
      theme(axis.text.y=element_text(size=67/sqrt(nrow(plot_data_func()))), axis.text.x=element_text(size=22), axis.title.x=element_text(size=26), axis.title.y=element_text(size=79/sqrt(nrow(plot_data_func()))), plot.title = element_text(size=18), face = "bold")
    
  })
  
  output$selecteddataTable <- renderDataTable(plot_data_func())
  
}


 