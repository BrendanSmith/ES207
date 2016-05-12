#### FUNCTION TO PULL DATA FROM USGS STATIONS
#### BRENDAN SMITH, 2016

get.dailyUSGS<-function(station,sensor,start,end){
  
  ## EXAMPLE URL:  
  # http://waterdata.usgs.gov/nwis/dv?cb_00060=on&format=rdb&site_no=11335000&referred_module=sw&period=&begin_date=1907-10-01&end_date=2015-09-30
  
  data <- read.table(paste("http://waterdata.usgs.gov/nwis/dv?cb_",sensor,"=on&format=rdb&site_no=",station,"&referred_module=sw&period=&begin_date=", start, "&end_date=",end, sep=""))
  
  data<- droplevels(data[-c(1,2),]) # remove top two lines of useless information
  
  assign("usgs.dat",data,envir = .GlobalEnv) # print to workspace
  }