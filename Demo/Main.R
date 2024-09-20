# main.R #### 

## packages ####

library(ncdf4)
library(abind)

# Source Utils and Config
source("Demo/Utils.R")
source("Demo/Config.R")


## CAMS-REG-ANT DataExtraction  ####
source("Demo/ExtractANT/DataExtraction.R")

# Initialize a list to store all data
all_data_list <- list()

# Define the paths to the NetCDF files
nc_file_paths <- c(
  "Demo\\Data\\Raw\\CAMS-REG-ANT\\NH3\\CAMS-REG-ANT_EUR_0.05x0.1_anthro_nh3_v5.1_yearly.nc",
  "Demo\\Data\\Raw\\CAMS-REG-ANT\\NH3\\CAMS-REG-ANT_EUR_0.05x0.1_anthro_nh3_v6.1_yearly.nc",
  "Demo\\Data\\Raw\\CAMS-REG-ANT\\NH3\\CAMS-REG-ANT_EUR_0.05x0.1_anthro_nh3_v7.0_yearly.nc"
)

# Loop through the NetCDF files and add the data to the all_data_list
for (nc_file_path in nc_file_paths) {
  all_data_list <- add_new_years_data(nc_file_path, all_data_list)
}

# Build the 4D matrix from the extracted data
all_data_matrix <- build_yearly_matrix(all_data_list)

# Save the matrix to an RDS file and clean up the environment
save_data(all_data_matrix, "Demo\\Data\\Processed\\ANT_data\\REG_ANT_yearly_data.rds")

#Free up memory
rm(all_data_matrix, all_data_list)
gc()

#Plot matrix with geom_tile
library(ggplot2)
library(reshape2)

# Load the processed data matrix
all_data_matrix <- readRDS("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data.rds")

#time series plot

time_series <- NULL
for (i in 1:dim(all_data_matrix)[4]) {
  time_series <- c(time_series, all_data_matrix[35, 200, 3, i])
}

# Convertire i valori in milligrammi/m^2 * day
time_series <- time_series * 10^6 * 60 * 60 * 24

plot(time_series, type="l", col="blue", xlab="Time", ylab="NH3 (mg/m^2/day)", main="NH3 Time Series")




## CAMS-REG-TEMPO ####

source("Demo/ExtractTEMPO/ProfilesExtraction.R")


# Esempio di utilizzo
# Definire i percorsi dei file .nc se non vengono forniti dall'utente
nc_file_path_daily_weekly <- "Demo\\Data\\Raw\\CAMS-REG-TEMPO\\CAMS-REG-TEMPO_EUR_0.1x0.1_tmp_weights_v3.1_daily.nc"
nc_file_path_monthly <-"Demo\\Data\\Raw\\CAMS-REG-TEMPO\\CAMS-REG-TEMPO_EUR_0.1x0.1_tmp_weights_v3.1_monthly.nc"
output_dir <- "Demo\\Data\\Processed\\TEMPO_data"

# Gestire il profilo selezionato
process_profile(nc_file_path_daily_weekly,nc_file_path_monthly, "FW_F", output_dir)
process_profile(nc_file_path_daily_weekly,nc_file_path_monthly, "FW_H", output_dir)
process_profile(nc_file_path_daily_weekly,nc_file_path_monthly, "FD_C", output_dir)
process_profile(nc_file_path_daily_weekly,nc_file_path_monthly, "FD_L_nh3", output_dir)
process_profile(nc_file_path_daily_weekly,nc_file_path_monthly, "FD_K_nh3_nox", output_dir)
process_profile(nc_file_path_daily_weekly,nc_file_path_monthly, "FM_F", output_dir)



#extract all monthly sectors from csv file

csvPath_MonthlySimplified <- "C:\\Users\\aminb\\Desktop\\IEDD\\Demo\\Data\\Raw\\CAMS-REG-TEMPO\\Simplified\\CAMS_TEMPO_v4_1_simplified_Monthly_Factors_climatology.csv"
csvPath_WeeklySimplified <- "Demo/Data/Raw/CAMS-REG-TEMPO/Simplified/CAMS_TEMPO_v4_1_simplified_Weekly_Factors.csv"

nh3_monthly<-extractAllSectorsCSV(csvPath_MonthlySimplified,"NH3","ITA")
nh3_weekly<-extractAllSectorsCSV(csvPath_WeeklySimplified,"NH3","ITA")

extractAllSectorsCSV<-function(csv_file_path,poll,country){
  # Read the CSV file
  data <- read.csv(csv_file_path, header = TRUE)
  
  # Filter the data based on the species and country
  data <- data[data$POLL == poll & data$ISO3 == country, ]
  
  # Remove the Species and Country columns
  data <- data[, -c(1, 2)]
  
  return(data)
}

## Computation ####

### dailyProfile ####

source("Demo/Computation/CreateDailyProfile.R")
# Specifica i profili mensile e settimanale
F_profiles <- list(FM_F_monthly, FW_F_weekly,"F")

start_year <- 2000
end_year <- 2020
output_folder <- "Demo/Data/Processed/TEMPO_data/Daily_profiles"

# Genera e salva i profili giornalieri per l'intervallo di anni
create_DailyProfile(F_profiles, start_year, end_year, output_folder)


### Daily DATA ####
#Compute daily profile with Yearly to get Daily_DATA

source("Demo/Computation/Compute.R")

# Esempio di utilizzo della funzione
yearly_data_file <- "Demo/Data/Processed/ANT_data/REG_ANT_yearly_data.rds"
temporal_profile_folder <- "Demo/Data/Processed/TEMPO_data"
output_folder <- "Demo/Data/Processed/DAILY_data"

profile<- "FD_C"
calculate_daily_matrices(profile,yearly_data_file, temporal_profile_folder, output_folder)




## map plotting ####

library(ggplot2)
library(reshape2)

# Load the processed data matrix
all_data_matrix <- readRDS("Demo/Data/Processed/ANT_data/REG_ANT_yearly_data.rds")

# Extract data of a sector and a year

mapdata <- all_data_matrix[,,3,21]

# Convertire i valori in milligrammi/m^2 * day
mapdata <- mapdata * 10^6 * 60 * 60 * 24

#ritaglia mapdata per la lombardia
mapdata<-mapdata[10:82,125:222]

# Create a data frame for plotting
df <- melt(mapdata)

#bring lon,lat,lon_idx,lat_idx from rds file
lon_lat_idx<-readRDS("Demo/Data/Processed/ANT_data/lon_lat_idx.rds")

df <- expand.grid(x = lon_lat_idx$lon[lon_lat_idx$lon_idx], y = lon_lat_idx$lat[lon_lat_idx$lat_idx])
df$value <- as.vector(mapdata)

df2<-all_data_list$`Year 2000`$C
names(df) <- c("lon", "lat", "value")


library(ggplot2)
library(scales)  # Assicurati di avere questa libreria per la funzione 'rescale'

# Definisci una palette di colori più estesa
extended_colors <- c("darkblue", "blue", "cyan", "green", "yellow", "orange", "red", "darkred", "purple")

ggplot(df, aes(x = lon, y = lat, fill = value)) +
  geom_tile(color = "black", size = 0.01) +  # Bordi neri estremamente sottili
  scale_fill_gradientn(
    colors = extended_colors,  # Utilizza la palette di colori estesa
    values = rescale(c(0, 0.1, 0.2, 0.35, 0.5, 0.65, 0.8, 0.9, 1)),  # Scala più graduata per i colori
    name = "Emissions (mg/m² * Day)",
    trans = "log10"
  ) +
  coord_fixed(1.3) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  labs(
    title = "2020 NH3 emissions in Italy",
    x = "Longitudine",
    y = "Latitudine"
  )

# Salvare l'immagine ad alta risoluzione
ggsave("NH3_Emissions_Italy_HighRes.png", dpi = 300, width = 10, height = 8)

#voglio controllare se df2 e df sono uguali in value
identical(df$value,df2$value)
identical(df,df2)
df$lon==df2$lon
df$lat==df2$lat
identical(df,df2)
class(df$lon)
class(df2$lon)


