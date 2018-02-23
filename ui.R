#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(googleway)

linevec <- readRDS("linevec_int.rds") # reading in flight path data
airports<- linevec[!duplicated(linevec[,c(1,3,4)]),c(1,3,4)]

# Define UI for application that draws a histogram
shinyUI(
  navbarPage("Domestic flight path statistics - top routes",
             
             ################
             # Interactive Map
             ################
             tabPanel("Interactive map",
                      tags$head(
                        # Include our custom CSS
                        includeCSS("styles.css"),
                        includeScript("gomap.js")
                      ),
                      
                      google_mapOutput('mymap',  width="100%", height=900),
                      
                      
                      #Shiny versions prior to 0.11 should use class="modal" instead.
                      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                    draggable = TRUE, top = 80, left = "auto", right = 20, bottom = "auto",
                                    width = 300, height = "auto",
                                    h3("Select airport"),
                                    selectInput(inputId="airportname", label = NULL, choices=airports$Australian, selected = airports$Australian[1]),
                                    tags$div(id="cite",
                                             'Data sourced from: ', tags$em('https://bitre.gov.au')
                                    )
                      )
                      
             )
            
             #####################
                      ))
