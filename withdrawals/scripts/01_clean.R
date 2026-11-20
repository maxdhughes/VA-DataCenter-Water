# 01_clean.R
# purpose: clean DEQ water withdrawals data
# units: million gallons per month (MGM)

library(tidyverse)
library(lubridate)

# load data
withdrawals <- read_csv("data/03_Withdrawals.csv") |> 

# standardize column names
# replacing spaces and dots with underscores
  rename_with(~ str_replace_all(.x, " ", "_")) |> 

# 1. remove power generation records
  filter(!Use_Type %in% c("Hydroelectric Power", "Fossil Power", "Nuclear Power") |
         is.na(Use_Type)) |> 
  
# 2. label missing use types
  mutate(Use_Type = replace_na(Use_Type, "Unknown")) |> 

# 3. drop duplicate CEDS ID
# portsmouth appears 2x
  filter(CEDS_Facility_Id != 200000066629) |> 

# 4. reshape from wide to long
  pivot_longer(cols = matches("^[A-Z][a-z]{2}_[0-9]{4}$"),
               names_to = "Month_Year",
               values_to = "MGM") |>
  mutate(Date = my(str_replace(Month_Year, "_", " ")),
         Year = year(Date),
         Month = month(Date)) |>
  select(-Month_Year)
  
# check: # of facilities
nrow(withdrawals) / 528

# save cleaned data
write_csv(withdrawals, "data/withdrawals_clean.csv")
