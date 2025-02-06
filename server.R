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
    
    plot_data <- Firm_Industry_Random_Effect_Coeff_Desc_StatSig_y_StatInsig |>  
      select(Company = level, "% Change in Excess of Industry" = estimate, "Lower Bound of 95% Confidence Interval" = conf.low, "Higher Bound of 95% Confidence Interval" = conf.high, `Statistically Significant?`, Industry) |> 
      filter(`Statistically Significant?` %in% input$Statistical_Significance)
    
    if (input$Industry != "All"){
      plot_data <- plot_data |> 
        filter(Industry == input$Industry)
    }
    
    return(plot_data)    
  })
  
  
  output$distPlot_Industry <- renderPlot({
    
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
      theme(axis.text.y=element_text(size=67/sqrt(max(1, nrow(plot_data_func())))), 
            axis.text.x=element_text(size=22), 
            axis.title.x=element_text(size=26), 
            axis.title.y=element_text(size=79/sqrt(max(1, nrow(plot_data_func())))), 
            plot.title = element_text(size=18), 
            face = "bold")
    
  })
  
  output$selecteddataTable <- renderDataTable(plot_data_func())
  
  output$distPlot_Firm <- renderPlot({
    

    title2 <- glue("Changes in Stock Price of {input$Chosen_Firm} vs. Industry Peers as a Function of Net COVID Sentiment over Time")
    
    select_company = c(input$Chosen_Firm)

    Closing_Share_Price_Across_Time_DropNA_highlight <- Closing_Share_Price_Across_Time_DropNA |> 
      mutate(highlight = case_when(company_name %in% select_company ~ TRUE,
                                   .default = FALSE))
    
    formula <- y ~ poly(x, 6, raw = TRUE) 
    
    Closing_Share_Price_Across_Time_DropNA_highlight |> 
      filter(Industry == Industry[(Closing_Share_Price_Across_Time_DropNA_highlight$company_name==input$Chosen_Firm)]) |> 
      ggplot(aes(x = Day_of_EarningsCall, y = Percent_Change_bt_DayBefore_y_DayAfter)) +
      geom_point(aes(size = Covid_Net_Sentiment*100, color = highlight), alpha = 0.7, show.legend = FALSE) +
      geom_smooth(method = "lm", formula = formula) + 
      scale_color_manual(values = c("orange", "black")) +
      # scale_size_manual(values = c(1, 3)) +
      # geom_label_repel(data = Closing_Share_Price_Across_Time_DropNA_highlight |> filter(highlight == TRUE), aes(label = company_name)) +
      stat_poly_eq(formula = formula, parse = TRUE, use_label(c("eq", "R2" ,"adj.R2", "p", "n")), vstep = 22, size=6) +
      theme(axis.text.y=element_text(size=20), 
            axis.text.x=element_text(size=20), 
            axis.title.x=element_text(size=22), 
            axis.title.y=element_text(size=22), 
            plot.title = element_text(size=24), 
            face = "bold") +
      labs(
        x = "Date of Earnings Call",
        y = "% Change in Stock Price from the Day Before Earnings Call to the Day After",
        title = title2,
        face = "bold"
      ) +
      scale_x_date(breaks = as.Date(c("2020-01-01", "2020-07-01", "2021-01-01", "2021-07-01", "2022-01-01", "2022-07-01")),
                   date_minor_breaks = "1 month")
  })
}


