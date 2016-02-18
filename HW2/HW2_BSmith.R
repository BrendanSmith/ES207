
ripdata <- read.csv("./riparian_survey.csv",header = TRUE, sep = ",")
str(ripdata)
summary(ripdata)

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

#ripdata <- droplevels(ripdata)

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

