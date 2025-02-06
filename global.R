library(shiny)
library(tidyverse)
library(glue)
library(DT)
library(ggplot2)
library(dplyr)
library(lubridate)
library(corrr)
library(haven)
library(lme4) 
library(broom.mixed) 
library(ggrepel)
library(ggpubr)
library(ggpmisc)




MixedEffects_HierarchicalModel <- read_rds('./data/MixedEffects_HierarchicalModel.RDS')


Closing_Share_Price_Across_Time <- read_csv('./data/Descending_Ticker_Industry_SharePrice.csv')
 

FixedEffects_IndustryCoefficients <- tidy(MixedEffects_HierarchicalModel) |> 
  filter(effect == "fixed") 





Random_Effect_Coeff_Desc <- tidy(MixedEffects_HierarchicalModel, effects = "ran_vals", conf.int = TRUE) |> arrange(desc(estimate))


Company_Industry  <- Closing_Share_Price_Across_Time |> 
  select(company_name, Industry) |> 
  unique()


Firm_Industry_Random_Effect_Coeff_Desc <- Random_Effect_Coeff_Desc  |> 
  inner_join(Company_Industry, by = join_by(level == company_name)) |> 
  select(level, estimate, conf.low, conf.high, Industry)  


Firm_Industry_Random_Effect_Coeff_Desc_StatSig <- Random_Effect_Coeff_Desc  |> 
  inner_join(Company_Industry, by = join_by(level == company_name)) |> 
  filter(conf.high < 0 | conf.low > 0) |> 
  mutate(`Statistically Significant?` = "Yes") |> 
  select(level, estimate, conf.low, conf.high, `Statistically Significant?`, Industry)  


Firm_Industry_Random_Effect_Coeff_Desc_StatInsig <- Random_Effect_Coeff_Desc  |> 
  inner_join(Company_Industry, by = join_by(level == company_name)) |> 
  select(level, estimate, conf.low, conf.high, Industry) |> 
  filter(conf.high > 0 & conf.low < 0) |> 
  mutate(`Statistically Significant?` = "No") |> 
  select(level, estimate, conf.low, conf.high, `Statistically Significant?`, Industry)  


Firm_Industry_Random_Effect_Coeff_Desc_StatSig_y_StatInsig <- bind_rows(Firm_Industry_Random_Effect_Coeff_Desc_StatSig, Firm_Industry_Random_Effect_Coeff_Desc_StatInsig)





# Plotting out data points of a selected firm with the background of all the firms in its industry:


Closing_Share_Price_Across_Time_DropNA <- Closing_Share_Price_Across_Time |> 
                                            drop_na(`Percent_Change_bt_DayBefore_y_DayAfter`, `Industry`, `Day_of_EarningsCall`, `company_name`, `Covid_Net_Sentiment`)





# select_company = c("Carmax Inc")
# 
# Closing_Share_Price_Across_Time_DropNA_highlight <- Closing_Share_Price_Across_Time_DropNA |> 
#   mutate(highlight = case_when(company_name %in% select_company ~ TRUE,
#                                .default = FALSE))
# 
# Closing_Share_Price_Across_Time_DropNA_highlight |> 
#   filter(Industry == Industry[(Closing_Share_Price_Across_Time_DropNA_highlight$company_name=="Carmax Inc")]) |> 
#   ggplot(aes(x = Day_of_EarningsCall, y = Percent_Change_bt_DayBefore_y_DayAfter)) +
#   geom_point(aes(size = Covid_Net_Sentiment, color = highlight), alpha = 0.7, show.legend = FALSE) +
#   geom_smooth(method = lm, formula = y ~ x) + 
#   scale_color_manual(values = c("orange", "black")) +
#   # scale_size_manual(values = c(1, 3)) +
#   # geom_label_repel(data = Closing_Share_Price_Across_Time_DropNA_highlight |> filter(highlight == TRUE), aes(label = company_name)) +
#   stat_poly_eq(use_label(c("eq", "adj.R2", "f", "p", "n")), vstep = 22, size=3.8) 
# 


