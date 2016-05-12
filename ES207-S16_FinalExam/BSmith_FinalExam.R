library(plyr)
library(rgdal)
library(HH)
library(reshape2)
library(stats)
library(raster)

data1<-read.csv("plasPCObs2014.csv")

summary(data1)

data2<-read.csv("plasSampleUnits2014.csv")

summary(data2)

# Transect in data1 corresponds to short.Name in data2
# data2 contains lon-lat information
# need to combine lon-lat information from data2 into data1

cntsp = count(data1$ScientificName)
cntsp <- cntsp[order(-cntsp$freq),]

# The 3 most elusive species are the Sialia, Strix occidentalis, Thryomanes bewickii
plot(data1$ScientificName)

# subset top 5 species
tpspecies <- data1[which(data1$ScientificName==cntsp$x[1:5]),]
tpspecies = droplevels(tpspecies)
plot(tpspecies$ScientificName,xlab = 'Species',ylab = 'Frequency',main = 'Top 5 Species')

# Plot the observed distance as a function of Scientific Name
plot(as.numeric(tpspecies$Distance.Bin)~tpspecies$ScientificName,ylab = 'Distance Observed (m)',xlab = 'Species')

# Plot Detection Cue Frequency
plot(tpspecies$Detection.Cue,ylab = 'Frequency',xlab = 'Detection Cue')


# Load the DEM
gdal_grid = readGDAL("DEM.tif")
dem = raster(gdal_grid) #use data as a projected raster
plot(dem)

points(data2$Longitude,data2$Latitude)

xy = cbind(data2$Longitude,data2$Latitude)

# extract the values from the dem dataset
evals = extract(dem,xy)
data2$Elevation <- evals

# With Lat, Lon and Elevation Data from 2, compare Short.Name to Point and inject matching values
tpspecies <- tpspecies[match(tpspecies$Point,data2$Short.Name),]
tpspecies$Latitude <- data2$Latitude[match(tpspecies$Point,data2$Short.Name)]
tpspecies$Longitude <- data2$Longitude[match(tpspecies$Point,data2$Short.Name)]
tpspecies$Elevation <- data2$Elevation[match(tpspecies$Point,data2$Short.Name)]
tpspecies<-droplevels(tpspecies)
plot(tpspecies$ScientificName,tpspecies$Elevation, ylab = 'Elevation (m AMSL)',xlab = 'Species')

hist(tpspecies$Elevation,xlab='Elevation',main = 'Histogram of Top Species Elevation')

summary(lm(as.numeric(tpspecies$Distance.Bin)~tpspecies$Elevation))
plot(as.numeric(tpspecies$Distance.Bin),tpspecies$Elevation,ylab='Elevation (m)',xlab='Distance Observed (m)')

# combdata <- 
