library(abind)


#CAMS-REG-ANT

source("C:\\Users\\aminb\\Desktop\\IEDD\\Demo\\ANT\\Analysis.R")
all_data_list <- list()

nc_file_paths <- c(
    "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-REG-ANT\\CAMS-REG-ANT_EUR_0.05x0.1_anthro_nh3_v5.1_yearly.nc",
    "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-REG-ANT\\NH3\\CAMS-REG-ANT_EUR_0.05x0.1_anthro_nh3_v6.1_yearly.nc",
    "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-REG-ANT\\NH3\\CAMS-REG-ANT_EUR_0.05x0.1_anthro_nh3_v7.0_yearly.nc"
)

for (nc_file_path in nc_file_paths) {
    all_data_list <- add_new_years_data(nc_file_path, all_data_list)
}

#salviamo anno per anno i dati in una matrice

all_data_matrix<-NULL

for(year in 1:length(all_data_list)){
  
  year_matrix<-NULL
  
  for(sector in all_data_list[[year]])
  {
    
    year_matrix<-abind(year_matrix,  dcast(sector, x ~ y, value.var = "value") ,along=3)
  }
  
    all_data_matrix<-abind(all_data_matrix,year_matrix,along=4)
  
}

rm(all_data_list,sector,year_matrix,year,nc_file_path,nc_file_paths)
gc()


#time series extraction
time_series<-NULL
for(i in 1:dim(all_data_matrix)[4]){
  
  time_series<-c(time_series,all_data_matrix[30,30,3,i])
}

print(time_series)

time_series*10^12

#plot time_series
plot(time_series*10^12, type="l", col="blue", xlab="Time", ylab="NH3 (ppb)", main="NH3 Time Series")


#CAMS-REG-TEMPO

source("C:/Users/aminb/Desktop/TesiBorqal/Code/Demo/TEMPO-Profiles/ProfilesExtraction.R")

nc_file_path <- "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-TEMPO\\CAMS-REG-TEMPO_EUR_0.1x0.1_tmp_weights_v3.1_daily.nc"
FD_C <- extract_and_store_profiles_in_list(nc_file_path, "FD_C")


#Save CAMS-REG-TEMPO data in rds files by years

library(abind)
library(reshape2)

day<-1
indexFromYear<-1
leap_year<-FALSE
FD_C_matrix<-NULL

for(y in 1:21)
{
  if(y%%4==0 || y==1)
  {  
    for(day in 1:366){  
      leap_year<-TRUE
      FD_C_matrix<-abind(FD_C_matrix,dcast(FD_C[[day+indexFromYear]], x ~ y, value.var = "value"),along=3)
      FD_C[[day+indexFromYear]]<-NULL
    }
  }
  else
  {
    for(day in 1:365){  
      leap_year<-FALSE
      FD_C_matrix<-abind(FD_C_matrix,dcast(FD_C[[day+indexFromYear]], x ~ y, value.var = "value"),along=3)
      FD_C[[day+indexFromYear]]<-NULL
    }
  }
  if(leap_year)
  { indexFromYear<-indexFromYear+366 }
  else
  { indexFromYear<-indexFromYear+365 }
  
  #Save in rds file renamed with years starting from 2000
  saveRDS(FD_C_matrix, file = paste0("IEDD\\Demo\\Data\\FD_C_",1999+y,".rds"))
  FD_C_matrix<-NULL
}
