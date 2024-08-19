
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

nc_file_path <- "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-TEMPO\\CAMS-REG-TEMPO_EUR_0.1x0.1_tmp_weights_v3.1_monthly.nc"
FM_B <- extract_and_store_profiles_in_list(nc_file_path, "FM_B")

df <- FD_C[[120]]  # Accesso al 120° giorno


