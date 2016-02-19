library(plyr)
library(ggplot2)
library(OpenStreetMap)
library(rgdal)

ripdata <- read.csv("./riparian_survey.csv",header = TRUE, sep = ",")
#str(ripdata)
#summary(ripdata)

#Assign Project Codes given the Project IDs in ripdata to something easier to parse through
nID <- c("COSRP", "HEROW","NAPSO", "SACTO")
oID <- levels(ripdata$ProjectID)
ripdata$ProjCode <- as.factor(nID[match(ripdata$ProjectID, oID)])

rm (oID, nID)

#remove useless data
ripdata <- ripdata[!grepl("Not Recorded", ripdata$LocationName),]
ripdata <- ripdata[!grepl("Unknown", ripdata$SpeciesVarietalName),]
ripdata <- ripdata[!(ripdata$SpeciesVarietalCode %in% c("UNKOWN", "DEAD", "Not Recorded")),]
ripdata <- ripdata[ripdata$Woody_DBH_cm > 0, ]
ripdata <- ripdata[ripdata$Woody_Height_m > 0, ]

#ripdata <- droplevel s(ripdata)

ProjLoc <- aggregate(cbind(Longitude,Latitude) ~ ProjCode,data=ripdata, mean)
MeasData <- aggregate(cbind(Woody_DBH_cm,Woody_Height_m) ~ ProjCode,data=ripdata, mean)

#Split SpeciesVarietalName column as a string and extract just the first word. Save to a new column 
ripdata$Genus = sapply(strsplit(as.character(ripdata$SpeciesVarietalName), " "), "[[", 1)

#After installing the "plyr" package, we can use "count" to create a dataframe with our frequency data
x <- count(ripdata, 'Genus')
gfreq <- x[order(-x[2]),]
rm(x)
#We can now display 'gfreq' as the frequency table

#Remove all but the first five rows of 'gfreq'
ssgfreq <- head(gfreq,5)

#Step 3 - Test for Independence
#Frequency as a function of Genus and Location
ssripdata<-ripdata[ripdata$Genus %in% ssgfreq$Genus,]
twrip <- table(ssripdata$Genus,ssripdata$ProjCode)

crripdata <- chisq.test(twrip)

platlon <- subset(ProjLoc, select = c("Latitude","Longitude"))
#plot(platlon,col=0)
#points(platlon, pch=c(5,2,4,3))

#I tried getting the State map to work, but to no avail
#map <- openmap(c(max(ProjLoc$Latitude)+1,min(ProjLoc$Longitude)-1), c(min(ProjLoc$Latitude)-1,max(ProjLoc$Longitude)+1))
#plot(map)
#x <- SpatialPoints(platlon)
#x.wgs84 <-spTransform(x, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
#osm <- openmap (c(bbox(x.wgs84)[2,2] + 1, bbox(x.wgs84)[1,1] - 1), c(bbox(x.wgs84)[2,1] - 1, bbox(x.wgs84)[1,2] + 1))
#osm.euref <- openproj (osm, proj4string(x))
#plot(osm.euref)
#plot(x,add=T,pch=20)

#Use the write.csv function to save my new dataframe with only
#the five most frequent genera
write.csv(ssripdata,file = "newripdata_survey.csv")
