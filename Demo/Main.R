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
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FW_F", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FW_H", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FD_C", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FD_L_nh3", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FD_K_NH3_NOX", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FM_B", NULL, output_dir)

## 4. SIMPLIFIED-CAMS-REG-TEMPO PROFILE EXTRACTION ####
source("Demo/ExtractTEMPO/SimpleProfilesCreation.R")

#Extract Data from CSV Files
Path_MonthlySimplified <- "C:/Users/aminb/Desktop/IEDD/Demo/Data/Raw/CAMS-REG-TEMPO/Simplified/CAMS_TEMPO_v4_1_simplified_Monthly_Factors_climatology.csv"
Path_WeeklySimplified <- "Demo/Data/Raw/CAMS-REG-TEMPO/Simplified/CAMS_TEMPO_v4_1_simplified_Weekly_Factors.csv"

Path_simplifiedProfilesCSV<-c(Path_MonthlySimplified,Path_WeeklySimplified)

pollutants <- c("CO", "NH3", "NMVOC", "NOx", "PM10", "PM2.5", "SOx")

for(poll in pollutants){
  SimpleProfilesCreation(Path_simplifiedProfilesCSV,poll)
}

SimpleProfilesCreation(Path_simplifiedProfilesCSV,"NH3")
SimpleProfilesCreation(Path_simplifiedProfilesCSV,"CO2")

## 5. CAMS-REG-TEMPO PROFILE CREATION using FM and FW ####

source("Demo/Computation/CreateDailyProfile.R")

# Define profiles and parameters
F_profiles <- list(FM_F_monthly, FW_F_weekly, "F")
start_year <- 2000
end_year <- 2020
output_folder <- "Demo/Data/Processed/TEMPO_data/Daily_profiles"

# Generate and save daily profiles for the specified years
create_DailyProfile(F_profiles, start_year, end_year, output_folder)

#Create Simplified Daily Profile 
source("Demo/Computation/CreateSIMPLEdailyProfile.R")

# Define interval and profiles for simplified profile creation
years_interval <- c(2000, 2020)
output_folder <- "Demo/Data/Processed/TEMPO_data/SimplifiedDailyProfiles"
PollutantSimpleProfile <- list(nh3_monthly, nh3_weekly, "NH3")

# Create simplified profiles for the specified years
create_multidimensional_profile_for_years(years_interval[1], years_interval[2], 
                                          PollutantSimpleProfile[[1]], 
                                          PollutantSimpleProfile[[2]], 
                                          output_folder, 
                                          PollutantSimpleProfile[3])

## 6. COMPUTE DAILY DATA WITH FD profiles ####
source("Demo/Computation/Compute.R")

# Example of using the compute function
yearly_data_file <- "Demo/Data/Processed/ANT_data/REG_ANT_yearly_data.rds"
temporal_profile_folder <- "Demo/Data/Processed/TEMPO_data"
output_folder <- "Demo/Data/Processed/DAILY_data"
PollutantName <- "NH3"
profile <- "FD_C"

# Calculate daily matrices
calculate_from_FD(PollutantName, profile, yearly_data_file, temporal_profile_folder, output_folder)

## 7. COMPUTE DAILY DATA WITH SIMPLIFIED PROFILES####
source("Demo/Computation/ComputeSimple.R")

# Define the range of years
start_year <- 2018
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

#SO2
yearlyData <- readRDS("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data_so2.rds")
DailyDataFromSimplified(yearlyData, start_year, end_year, "SOx")


## 8. TESTING EXTRACTED DAILY DATA ####
mapdata<-D_K_2016[,,1]

df <- melt(mapdata)
lon_lat_idx <- readRDS("Demo/Data/Processed/ANT_data/lon_lat_idx.rds")
df <- expand.grid(lon = lon_lat_idx$lon[lon_lat_idx$lon_idx], lat = lon_lat_idx$lat[lon_lat_idx$lat_idx])
df$value <- as.vector(mapdata)

# Define an extended color palette
extended_colors <- c("darkblue", "blue", "cyan", "green", "yellow", "orange", "red", "darkred", "purple")

# Plot using ggplot
ggplot(df, aes(x = lon, y = lat, fill = value)) +
  geom_tile(color = "black",size=0.01) +  # Thin black borders
  scale_fill_gradientn(
    colors = extended_colors,
    values = rescale(c(0, 0.1, 0.2, 0.35, 0.5, 0.65, 0.8, 0.9, 1)),  # Custom color scaling
    name = "Emissions (mg/m² * Day)",
    trans = "log10"
  ) +
  coord_fixed(1.3) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  labs(
    title = "2020 NH3 Emissions in Italy",
    x = "Longitude",
    y = "Latitude"
  )



## 9. PLOT TIME SERIES AND MAPS ####

# Load processed data matrix
all_data_matrix <- readRDS("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data.rds")

# Extract time series data
time_series <- sapply(1:dim(all_data_matrix)[4], function(i) {
  all_data_matrix[35, 200, 3, i]  # Example indices
})

# Convert values to milligrams per square meter per day
time_series <- time_series * 10^6 * 60 * 60 * 24

# Plot the time series
plot(time_series, type="l", col="blue", xlab="Time", ylab="NH3 (mg/m^2/day)", main="NH3 Time Series")

#Map Plotting
# Extract map data of a specific sector and year
mapdata <- all_data_matrix[,,3,21]

# Convert values to milligrams per square meter per day
mapdata <- mapdata * 10^6 * 60 * 60 * 24

# Crop data for Lombardy region
mapdata <- mapdata[10:82, 125:222]

# Create a data frame for plotting
df <- melt(mapdata)
lon_lat_idx <- readRDS("Demo/Data/Processed/ANT_data/lon_lat_idx.rds")
df <- expand.grid(x = lon_lat_idx$lon[lon_lat_idx$lon_idx], y = lon_lat_idx$lat[lon_lat_idx$lat_idx])
df$value <- as.vector(mapdata)

# Define an extended color palette
extended_colors <- c("darkblue", "blue", "cyan", "green", "yellow", "orange", "red", "darkred", "purple")

# Plot using ggplot
ggplot(df, aes(x = lon, y = lat, fill = value)) +
  geom_tile(color = "black", size = 0.01) +  # Thin black borders
  scale_fill_gradientn(
    colors = extended_colors,
    values = rescale(c(0, 0.1, 0.2, 0.35, 0.5, 0.65, 0.8, 0.9, 1)),  # Custom color scaling
    name = "Emissions (mg/m² * Day)",
    trans = "log10"
  ) +
  coord_fixed(1.3) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  labs(
    title = "2020 NH3 Emissions in Italy",
    x = "Longitude",
    y = "Latitude"
  )

# Save high-resolution plot
ggsave("NH3_Emissions_Italy_HighRes.png", dpi = 300, width = 10, height = 8)

## 10. DATA DESCRIPTION AND VALIDATION ####

#Compare Data Frames
# Checking if df and df2 are identical in values
df2 <- all_data_list$`Year 2000`$C
identical(df$value, df2$value)  # Check if values match
identical(df, df2)              # Check if entire data frames match

#Summary of Yearly Data 

# Summary statistics for each sector
for (i in 1:13) {
  print(paste("Sector:", i))
  print(summary(REG_ANT_yearly_data[,,i,]))
}

## 11. AGRIMONIA DATASET ####

# Load Agrimonia dataset
agrimonia_data <- read.csv("Demo/Data/Raw/AGRIMONIA/AGC_Dataset_v_3_0_0.csv")

# Display the structure of the dataset
str(agrimonia_data)

#Want just colums latitude longitude

agrimonia<-agrimonia_data[agrimonia_data$Latitude,agrimonia_data$Longitude]
agrimonia_data$EM_nh3_agr_soils

agrimonia_data$time <- as.Date(agrimonia_data$time, format="%d/%m/%Y")  # Modifica il formato se necessario

agrimonia_filtered <- agrimonia_data[
  agrimonia_data$Latitude >= 45.10 &
    agrimonia_data$Latitude <= 45.50 &
    agrimonia_data$Longitude >= 10.25 &
    agrimonia_data$Longitude <=10.40  &
    agrimonia_data$Time == "2016-01-01", #& agrimonia_data$Time <= "2016-12-31",
  c("Latitude", "Longitude", "Time", "EM_nh3_sum", "EM_nh3_livestock_mm", "EM_nh3_agr_soils", "EM_nh3_agr_waste_burn")
]



## 12. OpenStreetMap ####

#apriamo mappa geojson

library(sf)
library(dplyr)

# Crea un oggetto sf per le emissioni
emissioni_sf <- st_as_sf(emissioni_df, coords = c("lon", "lat"), crs = 4326)

emissioni_matrix<-Daily_K_2016_NH3[,,1]*10^6*60*60*24
# Estrai i nomi di riga e colonna (coordinate lat/lon)
longitudes <- as.numeric(rownames(emissioni_matrix))
latitudes <- as.numeric(colnames(emissioni_matrix))

# Crea un dataframe con le emissioni e le coordinate
emissioni_df <- expand.grid(lat = latitudes, lon = longitudes)
emissioni_df$emissioni <- as.vector(emissioni_matrix)

# Crea un oggetto sf dalle coordinate
emissioni_sf <- st_as_sf(emissioni_df, coords = c("lon", "lat"), crs = 4326)

# Carica i dati dei confini comunali (supponendo che siano in un file GeoJSON)
comuni <- st_read("C:\\Users\\aminb\\Desktop\\comuniOSM")

# Effettua la join spaziale
emissioni_comuni <- st_join(emissioni_sf, comuni)

# Aggrega le emissioni per comune
emissioni_per_comune <- emissioni_comuni %>%
  group_by(name) %>%
  summarise(emissioni_totali = sum(emissioni, na.rm = TRUE))

library(ggplot2)
# Visualizza le emissioni su una mappa
ggplot(emissioni_per_comune) +
  geom_sf(aes(fill = emissioni_totali)) +
  scale_fill_viridis_c() +
  theme_minimal() +
  labs(title = "Emissioni per Comune in Italia", fill = "Emissioni Totali")

library(tmap)

tmap_mode("view")

tm_shape(comuni) +
  tm_polygons() +
  tm_shape(emissioni_per_comune) +
  tm_bubbles(size = "emissioni_totali", col = "emissioni_totali", palette = "viridis")



## 13. Plot Time series ####

#Plotting ####

# Plot delle emissioni giornaliere
plot(sumNH3Converted[37,197,], type = "l", main = "Emissioni Giornaliere NH3", 
     xlab = "Giorno dell'anno", ylab = "Emissioni NH3", col = "blue")

# Boxplot delle emissioni
boxplot(sumNH3Converted[37,197,], main = "Distribuzione delle Emissioni NH3", 
        ylab = "Emissioni NH3", col = "lightblue")

# Istogramma delle emissioni
hist(sumNH3Converted[37,197,], breaks = 20, main = "Istogramma delle Emissioni NH3", 
     xlab = "Emissioni NH3", col = "lightgreen")

# Descrizione Statistica
summary_stats <- summary(sumNH3Converted[37,197,])
std_dev <- sd(sumNH3Converted[37,197,])

# Stampa dei risultati
print(summary_stats)
print(paste("Deviazione standard: ", std_dev))

mean_from_daily<-mean(sumNH3Converted[37,197,])
yearly_data<-REG_ANT_yearly_data_nh3[37,197,13,17]*converting
comparison_df <- data.frame(
  mean_from_daily = mean_from_daily,
  yearly_data=yearly_data  # Assicurati che sia un vettore
)


