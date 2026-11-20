# 02_explore.R
# purpose: find data centers in the withdrawals data & summarize their water use
# output: folder w/ tables & figures

library(tidyverse)
library(lubridate)

withdrawals <- read_csv("data/withdrawals_clean.csv")

# 1 row per facility (for name searches)
facilities <- withdrawals |> 
  distinct(Facility, CEDS_Facility_Id, Use_Type, Locality)

# -------------------------------------------------------------
# 1. keyword search on facility names (generic list)
keywords <- c("data", "amazon", "aws", "microsoft", "google", "meta",
              "qts", "equinix", "digital realty", "cyrusone", "iron mountain",
              "vantage", "stack", "aligned", "copt", "server", "cloud",
              "tech", "power")

pattern <- regex(str_c("\\b(", str_c(keywords, collapse = "|"), ")\\b"),
                 ignore_case = TRUE)

facilities |> 
  filter(str_detect(Facility, pattern))
# result: only Power Loft @ Innovation Data Center is a real data center


# 2. scan all facilities in major data center counties
dc_counties <- c("Loudoun", "Prince William", "Fairfax", "Stafford",
                 "Culpeper", "Henrico")

county_scan <- facilities |> 
  filter(Locality %in% dc_counties) |> 
  arrange(Locality, Facility)

write_csv(county_scan, "output/dc_county_facilities.csv")
# result: no other data centers; mostly golf, utilities, subdivisions.
#         data centers likely buy water from public utilities

# 3. power loft water use
power_loft <- withdrawals |> 
  filter(CEDS_Facility_Id == 200000899636, Year >= 2012)

# annual totals & months reported
power_loft_annual <- power_loft |> 
  group_by(Year) |>
  summarize(Total_MG = sum(MGM, na.rm = TRUE),
            Months = sum(!is.na(MGM)))

power_loft_annual
write_csv(power_loft_annual, "output/powerloft_annual.csv")

# monthly time series (shows the 2018 zeros & step up)
ggplot(power_loft, aes(x = Date, y = MGM)) +
  geom_line() +
  labs(title = "Power Loft @ Innovation: monthly groundwater withdrawals",
       x = NULL, y = "Million gallons per month") +
  theme_minimal()

ggsave("output/powerloft_monthly.png", width = 7, height = 4)

# annual totals
ggplot(power_loft_annual, aes(x = Year, y = Total_MG)) +
  geom_line() +
  geom_point() +
  labs(title = "Power Loft @ Innovation: annual groundwater withdrawals",
       x = "Year", y = "Million gallons per year") +
  theme_minimal()

ggsave("output/powerloft_annual.png", width = 7, height = 4)

# average by month (seasonal pattern), 2018-2025
power_loft_season <- power_loft |>
  filter(Year >= 2018) |>
  mutate(Month_Label = month(Date, label = TRUE)) |>
  group_by(Month_Label) |>
  summarize(Mean_MGM = mean(MGM, na.rm = TRUE)) |>
  ggplot(aes(Month_Label, Mean_MGM)) +
  geom_col() +
  labs(title = "Power Loft @ Innovation: average monthly withdrawal (2018-2025)",
       x = NULL, y = "Million gallons per month") +
  theme_minimal()

ggsave("output/powerloft_seasonal.png",
       width = 7, height = 4, units = "in", dpi = 300)
