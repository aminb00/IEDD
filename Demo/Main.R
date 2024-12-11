# Main Script: main.R ####

## 1. PACKAGES ####
library(ncdf4)
library(abind)
library(ggplot2)
library(reshape2)
library(scales)  # For color scaling in ggplot

## 2. SOURCE UTILS AND CONFIGURATION ####
source("Demo/Utils.R")
source("Demo/Config.R")

## 3. NEW CAMS-REG-ANT YEARLY DATA EXTRACTION ####

#Source Data Extraction Script
source("Demo/ExtractANT/DataExtraction.R")

# Directory containing NetCDF files
nc_directory <- "Demo/Data/Raw/CAMS-REG-ANT/"

#List of pollutant names to search for
pollutant_names <- c("nh3", "ch4", "co", "co2_bf", "co2_ff", "nmvoc", "nox", "pm2_5", "pm10", "so2")

# Load the lon_lat_idx file required for data extraction
lon_lat_idx <- readRDS("Demo/Data/Processed/lon_lat_idx.rds")

#Loop Through Each Pollutant and Extract Data
for (pollutant_name in pollutant_names) {
  
  #Search for files containing the pollutant name 
  nc_file_paths <- list.files(nc_directory, pattern = pollutant_name, full.names = TRUE)
  
  #Order the file paths by version number extracted from filenames
  nc_file_paths <- nc_file_paths[order(as.numeric(gsub(".*_v([0-9.]+)_.*", "\\1", nc_file_paths)))]
  
  #Initialize a list to store data for the current pollutant
  all_data_list <- list()
  
  #Loop through the NetCDF files and add data to all_data_list
  for (nc_file_path in nc_file_paths) {
    all_data_list <- add_new_years_data(nc_file_path, all_data_list)
  }
  
  #Build the 4D matrix from the extracted data
  all_data_matrix <- build_yearly_matrix(all_data_list, lon_lat_idx)
  
  #Define the save path with the pollutant name in the filename
  save_path <- paste0("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data_",pollutant_name, ".rds")
  
  #Save the matrix to an RDS file
  save_data(all_data_matrix, save_path)
  
  #Clean up memory
  rm(all_data_matrix, all_data_list)
  gc()
}

cat("All RDS files have been saved with the specified pollutant names.\n")


## 4. CAMS-REG-TEMPO PROFILE EXTRACTION ####
source("Demo/ExtractTEMPO/ProfilesExtraction.R")

#Define Paths
nc_file_path_daily_weekly <- "Demo/Data/Raw/CAMS-REG-TEMPO/CAMS-REG-TEMPO_EUR_0.1x0.1_tmp_weights_v3.1_daily.nc"
nc_file_path_monthly <- "Demo/Data/Raw/CAMS-REG-TEMPO/CAMS-REG-TEMPO_EUR_0.1x0.1_tmp_weights_v3.1_monthly.nc"
output_dir <- "Demo/Data/Processed/TEMPO_data"

#Process Profiles
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FM_F", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FW_F", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FW_H", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FD_C", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FD_L_nh3", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FD_K_nh3_nox", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FM_B", NULL, output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FW_B", NULL, output_dir)

## 4. SIMPLIFIED-CAMS-REG-TEMPO PROFILE EXTRACTION ####
source("Demo/ExtractTEMPO/ProfilesCreation.R")

#Extract Data from CSV Files
Path_MonthlySimplified <- "Demo/Data/Raw/CAMS-REG-TEMPO/Simplified/CAMS_TEMPO_v4_1_simplified_Monthly_Factors_climatology.csv"
Path_WeeklySimplified <- "Demo/Data/Raw/CAMS-REG-TEMPO/Simplified/CAMS_TEMPO_v4_1_simplified_Weekly_Factors.csv"

Path_simplifiedProfilesCSV<-c(Path_MonthlySimplified,Path_WeeklySimplified)

pollutants <- c("CO", "NH3", "NMVOC", "NOx", "PM10", "PM2.5", "SOx")

for(poll in pollutants){
  SimpleProfilesCreation(Path_simplifiedProfilesCSV,poll)
}

#SimpleProfilesCreation(Path_simplifiedProfilesCSV,"NH3")
#SimpleProfilesCreation(Path_simplifiedProfilesCSV,"CO2")

## 5. CAMS-REG-TEMPO PROFILE CREATION using FM and FW ####

source("Demo/Computation/DailyPRF_fromFMFW.R")


FM_profile <- readRDS("Demo/Data/Processed/TEMPO_data/FM_F_monthly.rds")
FW_profile <- readRDS("Demo/Data/Processed/TEMPO_data/FW_F_weekly.rds")

DailyPRF_fromFMFW(FM_profile, FW_profile, "F")


#Create Simplified Daily Profile #sto punto non serve!
source("Demo/Computation/CreateSIMPLEdailyProfile.R")

# Define interval and profiles for simplified profile creation
years_interval <- c(2000, 2020)
output_folder <- "Demo/Data/Processed/TEMPO_data/SimplifiedDailyProfiles"
nh3_monthly <- readRDS("Demo/Data/Processed/TEMPO_data/.rds")
PollutantSimpleProfile <- list(nh3_monthly, nh3_weekly, "NH3")

# Create simplified profiles for the specified years
create_multidimensional_profile_for_years(years_interval[1], years_interval[2], 
                                          PollutantSimpleProfile[[1]], 
                                          PollutantSimpleProfile[[2]], 
                                          output_folder, 
                                          PollutantSimpleProfile[3])

## 6. COMPUTE DAILY DATA WITH FD profiles ####
source("Demo/Computation/Compute.R")

# Esempio di utilizzo della funzione aggiornata
temporal_profile_folder <- "Demo/Data/Processed/TEMPO_data"
output_folder <- "Demo/Data/Processed/DAILY_data"
PollutantName <- "nh3"
sector <- "F"  
calculate_from_FD(PollutantName, yearly_data_file, temporal_profile_folder, output_folder, sector)

PollutantName <- "nox"
sector <- "F"  
calculate_from_FD(PollutantName, yearly_data_file, temporal_profile_folder, output_folder, sector)

PollutantName <- "so2"
sector <- "F"  
calculate_from_FD(PollutantName, yearly_data_file, temporal_profile_folder, output_folder, sector)

PollutantName <- "pm10"
sector <- "F"  
calculate_from_FD(PollutantName, yearly_data_file, temporal_profile_folder, output_folder, sector)

PollutantName <- "pm2.5"
sector <- "F"  
calculate_from_FD(PollutantName, yearly_data_file, temporal_profile_folder, output_folder, sector)

PollutantName <- "nmvoc"
sector <- "F"  
calculate_from_FD(PollutantName, yearly_data_file, temporal_profile_folder, output_folder, sector)

PollutantName <- "co"
sector <- "F"  
calculate_from_FD(PollutantName, yearly_data_file, temporal_profile_folder, output_folder, sector)

PollutantName <- "ch4"
sector <- "F"  
calculate_from_FD(PollutantName, yearly_data_file, temporal_profile_folder, output_folder, sector)

PollutantName <- "co2_ff"
sector <- "F"  
calculate_from_FD(PollutantName, yearly_data_file, temporal_profile_folder, output_folder, sector)

PollutantName <- "co2_bf"
sector <- "F"  
calculate_from_FD(PollutantName, yearly_data_file, temporal_profile_folder, output_folder, sector)


## 7. COMPUTE DAILY DATA WITH SIMPLIFIED PROFILES####
source("Demo/Computation/ComputeSimple.R")

# Define the range of years
start_year <- 2000
end_year <- 2020

#NH3
yearly_data <- readRDS("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data_nh3.rds")
DailyDataFromSimplified(yearly_data, start_year, end_year, "NH3")

#PM10
yearly_data <- readRDS("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data_pm10.rds")
DailyDataFromSimplified(yearly_data, start_year, end_year, "PM10")

#PM2.5
yearly_data <- readRDS("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data_pm2_5.rds")
DailyDataFromSimplified(yearly_data, start_year, end_year, "PM2.5")

#NOx
yearly_data <- readRDS("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data_nox.rds")
DailyDataFromSimplified(yearly_data, start_year, end_year, "NOx")

#NMVOC
yearly_data <- readRDS("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data_nmvoc.rds")
DailyDataFromSimplified(yearly_data, start_year, end_year, "NMVOC")

#SOx
yearlyData <- readRDS("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data_so2.rds")
DailyDataFromSimplified(yearlyData, start_year, end_year, "SOx")

#CO
yearlyData <- readRDS("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data_co.rds")
DailyDataFromSimplified(yearlyData, start_year, end_year, "CO")


##8. STACK DAILY DATA ALONG YEARS ####
source("Demo/Computation/StackDailyData.R")

# Set the input folder
input_folder <- "Demo/Data/Processed/DAILY_data"

# Set the start and end years
start_year <- 2000
end_year <- 2020

# Stack daily data for all sectors and pollutants
sectors <- LETTERS[1:12]
pollutants <- c("PM10", "PM2.5", "NOx","NH3","SO2","CO","NMVOC")

for (sector in sectors) {
  for (pollutant in pollutants) {
    StackDailyData(input_folder, sector, pollutant, start_year, end_year)
  }
}

# Sum all sectors into one for each pollutant
for (pollutant in pollutants) {
  output_file <- file.path(input_folder, paste0("Daily_AllSectors_", start_year, "_", end_year, "_", pollutant, ".rds"))
  SumAllSectorsIntoOne(input_folder, output_file, pollutant, start_year, end_year)
}

cat("Stacking and summing of daily data completed.\n")