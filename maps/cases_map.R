library(leaflet) #leaflet map
library(leaflet.extras) #leaflet functionality
library(sf) #read geojson
library(tidyverse) #data manipulation

# Getting India GEOJSON data
source("https://raw.githubusercontent.com/alvinndo/covid-viz-india/main/functions/get_geojson.R")

# COLORS!!
pal <- colorNumeric("YlOrRd", NULL)

# Initializing leaflet map for states of India
m <- leaflet() %>%
  addResetMapButton() %>% 
  addSearchOSM(options = searchOptions(hideMarkerOnCollapse = T)) %>% 
  addLegend(title = paste0("Confirmed Cases<br>Updated: ", today),
            position = "topright",
            pal = pal,
            values = india_states$cases,
            opacity = 1) %>% 
  addProviderTiles(provider = "CartoDB.Positron") %>% 
  addPolygons(data = india_states,
              color = "#444444",
              weight = 1,
              opacity = 1.0,
              smoothFactor = 0.5,
              fillOpacity = 0.75,
              dashArray = "1",
              fillColor = ~pal(india_states$cases),
              highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE),
              label = sprintf("<strong>%s</strong>
                                <hr>
                                <b>Current Cumulative Cases: </b>%s
                                <br/>
                                <b>Deaths: </b>%s
                                <br/>
                                <b>Average New Cases per 100,000: </b>%g",
                              india_states$state,
                              format(india_states$cases, scientific = FALSE),
                              format(india_states$deaths, scientific = FALSE),
                              india_states$incident_rate) %>% lapply(htmltools::HTML),
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto"))

# Clean-up
rm(dat, india_states, repo_url, today, pal)
