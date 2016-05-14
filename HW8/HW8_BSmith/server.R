#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(maptools)
library(akima)
pt.shp = readShapePoints("../allobs.shp")

# Define server logic required to draw a histogram
shinyServer(
  function(input, output) {
    # Code placed here will run whenever a user opens
    # your shiny app or refreshes the page
    output$map <- renderPlot({
      pt <- switch(input$var,
                   "Feb 16, 2005" = pt.shp[pt.shp$DateTime_ == "2005-02-16",],
                   "Feb 17, 2005" = pt.shp[pt.shp$DateTime_ == "2005-02-17",],
                   "Feb 18, 2005" = pt.shp[pt.shp$DateTime_ == "2005-02-18",],
                   "Feb 23, 2005" = pt.shp[pt.shp$DateTime_ == "2005-02-23",],
                   "Feb 28, 2005" = pt.shp[pt.shp$DateTime_ == "2005-02-28",])
      pt.filled <- switch(input$var.var,
                          "Temperature" = interp(pt$X,pt$Y,pt$Temp,duplicate='mean'),
                          "Chlorophyl" = interp(pt$X,pt$Y,pt$Chlorophyl,duplicate='mean'),
                          "Dissolved Oxygen" = interp(pt$X,pt$Y,pt$DO__,duplicate='mean'))
      
      image(pt.filled,col=cm.colors(24), xlab="UTM X (m)", ylab="UTM Y (m)", main=paste(input$var,input$var.var,sep = " - "))
      
      # If the checkbox is ticked, it adds the contour map
      if(input$cntchk){contour(pt.filled,add=T)}
      
    })
    
    output$perspective <- renderPlot({
      if(input$prspchck){
      pt <- switch(input$var,
                   "Feb 16, 2005" = pt.shp[pt.shp$DateTime_ == "2005-02-16",],
                   "Feb 17, 2005" = pt.shp[pt.shp$DateTime_ == "2005-02-17",],
                   "Feb 18, 2005" = pt.shp[pt.shp$DateTime_ == "2005-02-18",],
                   "Feb 23, 2005" = pt.shp[pt.shp$DateTime_ == "2005-02-23",],
                   "Feb 28, 2005" = pt.shp[pt.shp$DateTime_ == "2005-02-28",])
      pt.filled <- switch(input$var.var,
                          "Temperature" = interp(pt$X,pt$Y,pt$Temp,duplicate='mean'),
                          "Chlorophyl" = interp(pt$X,pt$Y,pt$Chlorophyl,duplicate='mean'),
                          "Dissolved Oxygen" = interp(pt$X,pt$Y,pt$DO__,duplicate='mean'))

      persp(pt.filled,theta=input$theta, phi=input$phi,col=cm.colors(24), xlab="UTM X (m)", ylab="UTM Y (m)")
      }
    })
  
})
