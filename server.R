#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(rgeos)
library(geosphere)
 library(sf)
  library(googleway)
  
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  linevec <- readRDS("linevec_int.rds") # reading in flight path data
  airports<- linevec[!duplicated(linevec[,c(1,3,4)]),c(1,3,4)]
 
 
flightpaths <-reactive({  # A reactive function to 

  p <-linevec[linevec$Australian==input$airportname,]
  p1<-as.matrix(p[,c(4,3)])
  
  p2<-as.matrix(p[,c(5,6)])
  
  df <-gcIntermediate(p1, p2, breakAtDateLine=F, # So cool!
                   n=1000, 
                   addStartEnd=TRUE,
                   sp=TRUE)
  
  df<-sf::st_as_sf(df)
  
  return(df)
})

observe({
  
  print(input$airportname)
  
  # proxy %>% clearShapes()
  # 
  # proxy %>%  addCircleMarkers(airports, lng = airports$Australian_lon, lat = airports$Australian_lat, radius = 2, label = paste(airports$Australian, "Airport"))%>% 
  # addPolylines(data = flightpaths(), weight = 1)
  # 
  set_key("AIzaSyC32aX3MW41mEBS2invj_0t-i6EHEUmJAk")
  
  
  
  airportmap<- google_map() %>%
    add_polylines(data = flightpaths(), stroke_weight = 0.5)
  
  output$mymap <- renderGoogle_map({airportmap}) # render the base map
})





#####
})
