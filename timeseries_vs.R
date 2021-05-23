library(stringr)

timeseries_us <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv") %>% 
  filter(Country.Region == "US") %>% 
  pivot_longer(cols = starts_with("X"),
               names_to = "date",
               names_prefix = "X",
               values_to = "cases") %>%
  select(Country.Region, date, cases) %>% 
  rename(country = "Country.Region") %>% 
  mutate(date = as.Date(date, "%m.%d.%y"))

timeseries_vs <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv") %>% 
  filter(Country.Region == c("US", "India")) %>% 
  pivot_longer(cols = starts_with("X"),
               names_to = "date",
               names_prefix = "X",
               values_to = "cases") %>%
  select(Country.Region, date, cases) %>% 
  rename(country = "Country.Region") %>% 
  mutate(date = as.Date(date, "%m.%d.%y"))

ggplot(timeseries_vs, aes(x = date, y = cases, color = country)) +
  geom_point() +
  scale_x_date(date_labels = "%Y %b",
               date_breaks = "1 month") +
  scale_y_continuous(labels = addUnits,
                     breaks = scales::pretty_breaks(n = 20)) +
  theme(axis.text.x = element_text(angle = 60)) +
  labs(
    title = "Cumulative Covid-19 Cases (India vs. US)"
  )
