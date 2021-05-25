library(tidyverse)

# Function to add units on Y-axis labels
source("https://raw.githubusercontent.com/alvinndo/covid-viz-india/main/functions/addUnits.R")

# Time series data from India. Starting from 1-22-20
timeseries_india <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv") %>% 
  filter(Country.Region == "India") %>% 
  pivot_longer(cols = starts_with("X"),
               names_to = "date",
               names_prefix = "X",
               values_to = "cases") %>%
  select(Country.Region, date, cases) %>% 
  rename(country = "Country.Region") %>% 
  mutate(date = as.Date(date, "%m.%d.%y"))

# Creating plot
ggplot(timeseries_india, aes(x = date, y = cases)) +
  geom_point() +
  scale_x_date(date_labels = "%Y %b",
               date_breaks = "1 month") +
  scale_y_continuous(labels = addUnits,
                     breaks = scales::pretty_breaks(n = 20)) +
  theme(axis.text.x = element_text(angle = 60)) +
  labs(title = "Cumulative Covid-19 Cases in India")

# Clean-up
rm(timeseries_india, addUnits)