addUnits <- function(n) {
  labels <- ifelse(n < 1000, n,  # less than thousands
                   ifelse(n < 1e6, paste0(round(n/1e3), 'k'),  # in thousands
                          ifelse(n < 1e9, paste0(round(n/1e6), 'M'),  # in millions
                                 ifelse(n < 1e12, paste0(round(n/1e9), 'B'), # in billions
                                        ifelse(n < 1e15, paste0(round(n/1e12), 'T'), # in trillions
                                               'too big!'
                                        )))))
  return(labels)
}

timeseries_india <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv") %>% 
  filter(Country.Region == "India") %>% 
  pivot_longer(cols = starts_with("X"),
               names_to = "date",
               names_prefix = "X",
               values_to = "cases") %>%
  select(Country.Region, date, cases) %>% 
  rename(country = "Country.Region") %>% 
  mutate(date = as.Date(date, "%m.%d.%y"))

ggplot(timeseries_india, aes(x = date, y = cases)) +
  geom_point() +
  scale_x_date(date_labels = "%Y %b",
               date_breaks = "1 month") +
  scale_y_continuous(labels = addUnits,
                     breaks = scales::pretty_breaks(n = 20)) +
  theme(axis.text.x = element_text(angle = 60)) +
  labs(
    title = "Cumulative Covid-19 Cases in India"
  )

