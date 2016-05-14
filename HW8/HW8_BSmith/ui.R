#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(maptools)
pt.shp = readShapePoints("../allobs.shp")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Add a title panel
  titlePanel("Triangle Floodplain"),
  # Add a side-panel and add some elements to it
  sidebarLayout(
    sidebarPanel(
      helpText("Visualize different dates and you can add more text
               here."),
      # As written, the selection of this input will be passed # to server.R as the variable 'var' with a default
      # value of 'Feb 18, 2005'
      selectInput("var",
                  label = "Choose a date to display",
                  choices = c("Feb 16, 2005","Feb 17, 2005","Feb 18, 2005","Feb 23, 2005","Feb 28, 2005"),
                  selected = "Feb 18, 2005"),
      selectInput("var.var",
                  label = "Choose a variable to display",
                  choices = c("Temperature","Chlorophyl","Dissolved Oxygen"), selected = "Temperature"),
      checkboxInput("cntchk",
                    "Contour",
                    value = FALSE,
                    width = NULL),
      checkboxInput("prspchck",
                    "Perspective",
                    value = FALSE,
                    width = NULL),
      sliderInput("theta", "Theta:", 
                  min=-180, max=180, value=30),
      sliderInput("phi", "Phi:", 
                  min=-180, max=180, value=45)
      ),
    mainPanel(
      tabsetPanel(
      tabPanel("Map", plotOutput("map")),
      tabPanel("Perspective", plotOutput("perspective"))
    ))
  )
))
