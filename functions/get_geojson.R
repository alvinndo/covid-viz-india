# Get current date
today <- format(Sys.Date()-1 , "%m-%d-%Y")

# Get repo URL
repo_url <- paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/", today, ".csv")

# India data
dat <- read.csv(repo_url) %>% 
  filter(Country_Region == "India", Province_State != "Unknown") %>% 
  select(Province_State, Country_Region, Confirmed, Deaths, Recovered, Active, Incident_Rate, Case_Fatality_Ratio, Last_Update) 

# Reading India geojson
india_states <- st_read("https://github.com/geohacker/india/raw/master/state/india_telengana.geojson") %>% 
  arrange(ID_1) %>% 
  mutate(cases = dat$Confirmed,
         deaths = dat$Deaths,
         recovered = dat$Recovered,
         active = dat$Active,
         incident_rate = dat$Incident_Rate,
         case_fatality_ratio = dat$Case_Fatality_Ratio) %>% 
  select(ID_1, NAME_1, cases, deaths, recovered, active, incident_rate, case_fatality_ratio, geometry) %>% 
  rename(state = "NAME_1")