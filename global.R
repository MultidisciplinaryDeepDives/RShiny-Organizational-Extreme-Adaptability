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



MixedEffects_HierarchicalModel <- read_rds('./data/MixedEffects_HierarchicalModel.RDS')


Closing_Share_Price_Across_Time <- read_csv('./data/Descending_Ticker_Industry_SharePrice.csv')
 

FixedEffects_IndustryCoefficients <- tidy(MixedEffects_HierarchicalModel) |> 
  filter(effect == "fixed") 





Random_Effect_Coeff_Desc <- tidy(MixedEffects_HierarchicalModel, effects = "ran_vals") |> arrange(desc(estimate))


Company_Industry  <- Closing_Share_Price_Across_Time |> 
  select(company_name, Industry) |> 
  unique()


Firm_Industry_Random_Effect_Coeff_Desc <- Random_Effect_Coeff_Desc  |> 
  inner_join(Company_Industry, by = join_by(level == company_name)) |> 
  select(level, estimate, std.error, Industry)





