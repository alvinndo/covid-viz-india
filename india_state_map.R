library(leaflet) #leaflet map
library(leaflet.extras) #leaflet functionality
library(sf) #read geojson
library(tidyverse) #data manipulation

# India data
dat <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/05-21-2021.csv") %>% 
  filter(Country_Region == "India", Province_State != "Unknown") %>% 
  select(Province_State, Country_Region, Confirmed, Deaths, Recovered, Active, Incident_Rate, Case_Fatality_Ratio, Last_Update) 
  

# Reading India geojson
india_states <- st_read("https://github.com/geohacker/india/raw/master/state/india_telengana.geojson")

# COLORS!!
pal <- colorNumeric("viridis", NULL)

# Initializing leaflet map for states of India
m <- leaflet() %>%
  addResetMapButton() %>% 
  addSearchOSM(options = searchOptions(hideMarkerOnCollapse = T)) %>% 
  addLegend(title = "Confirmed Cases",
            position = "topright",
            pal = pal,
            values = dat$Confirmed,
            opacity = 1) %>% 
  addProviderTiles(provider = "CartoDB.Positron") %>% 
  addPolygons(data = india_states,
              color = "#444444",
              weight = 1,
              opacity = 1.0,
              smoothFactor = 0.5,
              fillOpacity = 0.75,
              dashArray = "1",
              fillColor = ~pal(dat$Confirmed),
              highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE),
              label = sprintf("<strong>%s</strong>
                                <hr>
                                <b>Current Cumulative Count: </b>%s
                                <br/>
                                <b>Average New Cases per 100,000: </b>%g",
                              india_states$NAME_1,
                              format(dat$Confirmed, scientific = FALSE),
                              dat$Incident_Rate) %>% lapply(htmltools::HTML),
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")) 
  
  
