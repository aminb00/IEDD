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
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FD_K_NH3_NOX", output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FM_B", NULL, output_dir)
process_profile(nc_file_path_daily_weekly, nc_file_path_monthly, "FW_B", NULL, output_dir)

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

source("Demo/ExtractTEMPO/ProfilesCreation.R")

start_year<-2000
end_year<-2020

#F profile
# Define the paths to the FM and FW profiles
FM_profile <- readRDS("Demo/Data/Processed/TEMPO_data/FM_F_monthly.rds")
FW_profile <- readRDS("Demo/Data/Processed/TEMPO_data/FW_F_weekly.rds")
#manca start e end year
DailyPRF_fromFMFW <- function(FM_profile, FW_profile, sector,start_year,end_year) 
  
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
start_year <- 2017
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


## 8.Agrimonia filtering

agrimonia <- read.csv("Demo/Data/Raw/Agrimonia/AGC_Dataset_v_3_0_0.csv")

# Filtra le colonne di interesse dai dati Agrimonia
agrimonia_nh3 <- data.frame(
  Latitude = agrimonia$Latitude,
  Longitude = agrimonia$Longitude,
  Time = agrimonia$Time,
  EM_nh3_livestock_mm = agrimonia$EM_nh3_livestock_mm,
  EM_nh3_agr_soils = agrimonia$EM_nh3_agr_soils,
  EM_nh3_agr_waste_burn = agrimonia$EM_nh3_agr_waste_burn,
  EM_nh3_sum = agrimonia$EM_nh3_sum
)

# Filtra i dati per l'anno 2020 e seleziona solo la colonna NH3_sum
agrimonia_2016_nh3_sum <- agrimonia_nh3 %>%
  filter(format(as.Date(Time), "%Y") == "2016") %>%
  select(Latitude, Longitude, Time, EM_nh3_sum)

# Visualizza le prime righe del dataframe filtrato per il 2020
head(agrimonia_2016_nh3_sum)

## 9. Define NH3 emissions in dataframe Daily_sum_2020_NH3


lon_values <- lon_lat_idx$lon[lon_lat_idx$lon_idx]
lat_values <- lon_lat_idx$lat[lon_lat_idx$lat_idx]
time_values <- seq.Date(as.Date("2020-01-01"), as.Date("2020-12-31"), by = "day")  # Sequenza di 366 giorni

df_sum_NH3_2020 <- expand.grid(lon = lon_values, lat = lat_values, time = time_values)

df_sum_NH3_2020$value <- as.vector(Daily_sum_2020_NH3)

# Filtra i dati per il Nord Italia
df_sum_NH3_2020_north <- df_sum_NH3_2020 %>%
  filter(lat >= 44 & lat <= 47 & lon >= 6.5 & lon <= 13.5)


library(sf)
library(ggplot2)
library(dplyr)

# Crea la cartella "AGRIMONIA" se non esiste
output_dir <- "Plots/AGRIMONIA"
if (!dir.exists(output_dir)) dir.create(output_dir)

# 1. Grafico Agrimonia
# Carica lo shapefile dei confini italiani
shapefile_path <- "C:/Users/aminb/Desktop/IEDD/Demo/Data/Raw/MAPS/ITA-Administrative-maps-2024/Reg01012024_g/Reg01012024_g_WGS84.shp"
italy_shapefile <- st_read(shapefile_path)

# Filtra la Lombardia
lombardy <- italy_shapefile[italy_shapefile$DEN_REG == "Lombardia", ]

# Calcola la media delle emissioni per latitudine e longitudine
average_2016 <- agrimonia_2016_nh3_sum %>%
  group_by(Latitude, Longitude) %>%
  summarise(Mean_Emission = mean(EM_nh3_sum, na.rm = TRUE)) %>%
  ungroup()

# Converti i dati in sf
sf_data_agrimonia <- st_as_sf(average_2016, coords = c("Longitude", "Latitude"), crs = 4326)
sf_data_agrimonia_utm<- st_transform(sf_data_agrimonia, 32632)
cord_df <- st_coordinates(sf_data_agrimonia_utm)
cord_df<-as.data.frame(cord_df)
cord_df<-cord_df[order(cord_df$Y,cord_df$X),]

df_lombardia<-st_intersection(sf_data_agrimonia, st_transform(lombardy, 4326))
ggplot()+
  geom_sf(data=df_lombardia_utm, aes(fill=Mean_Emission),color="black")

ggplot()+
  geom_sf(data=df_lombardia, aes(fill=Mean_Emission),color="black")
a<-as_Spatial(sf_data_agrimonia)
gridded(a)<-TRUE
(a)
st_as_sf(a)
plot(a)

sf_data_agrimonia_grid <- st_make_grid(sf_data_agrimonia)

ggplot()+
  geom_sf(data=sf_data_agrimonia_grid)

#Plot Agrimonia
p1 <- ggplot() +
  geom_sf(data = lombardy, fill = "gray50", color = "red", size = 4.5) + # Grigio scuro come riempimento
  geom_sf(data = sf_data_agrimonia, aes(color = Mean_Emission), size = 3.5) +
  scale_color_viridis_c(option = "viridis", name = "NH₃ Emission\nMean (2016)") +
  labs(title = "NH₃ Emissions in Lombardia (2016) - Agrimonia",
       x = "Longitude", y = "Latitude") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 18),
    legend.title = element_text(size = 20),
    legend.text = element_text(size = 16),
    axis.text = element_text(size = 16),
    axis.title = element_text(size = 18)
  )

# Salva il grafico Agrimonia
ggsave(file.path(output_dir, "AGRIMONIA_NH3_LOMBARDIA_2016.png"), plot = p1, dpi = 300, width = 10, height = 8)

# 2. Grafico IEDD
# Calcolo dei dati da REG_ANT_yearly_data_nh3
data_matrix <- REG_ANT_yearly_data_nh3[,,13,17] * 10^6 * 60 * 60 * 24

# Crea un dataframe con lon, lat e valori dalla matrice
df <- expand.grid(
  lon = lon_lat_idx$lon[lon_lat_idx$lon_idx],
  lat = lon_lat_idx$lat[lon_lat_idx$lat_idx]
)
df$value <- as.vector(data_matrix)  # Assegna i valori dalla matrice

# Filtra solo i dati con valori non NA o non infiniti
df <- df[is.finite(df$value), ]
df_filtered <- df[df$lat >= 44.5 & df$lat <= 47 & df$lon >= 8 & df$lon <= 12, ]

# Converti il dataframe in un oggetto sf
sf_data_iedd <- st_as_sf(df_filtered, coords = c("lon", "lat"), crs = 4326)

# Plot IEDD
p2 <- ggplot() +
  geom_sf(data = lombardy, fill = "gray50", color = "red", size = 4.5) + # Lombardia con stile
  geom_sf(data = sf_data_iedd, aes(color = value), size = 3.5) + # Celle colorate in base ai valori
  scale_color_viridis_c(option = "viridis", name = "NH₃ Emission\nMean (2016)") +
  labs(title = "NH₃ Emissions in Lombardia (2016) - IEDD",
       x = "Longitude", y = "Latitude") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 18),
    legend.title = element_text(size = 20),
    legend.text = element_text(size = 16),
    axis.text = element_text(size = 16),
    axis.title = element_text(size = 18)
  )


# Salva il grafico IEDD
ggsave(file.path(output_dir, "IEDD_NH3_LOMBARDIA_2016.png"), plot = p2, dpi = 300, width = 10, height = 8)

sum(df$value)


# Calcolo del totale delle emissioni per AGRIMONIA
total_agrimonia <- sum(df_lombardia$Mean_Emission, na.rm = TRUE)

# Calcolo del totale delle emissioni per IEDD
total_iedd <- sum(df_filtered$value, na.rm = TRUE)

# Stampa i risultati
cat("Totale emissioni AGRIMONIA:", total_agrimonia, "\n")
cat("Totale emissioni IEDD:", total_iedd, "\n")



## Flux ####

# Trasforma i dati in UTM per AGRIMONIA
sf_data_agrimonia_utm <- st_transform(sf_data_agrimonia, 32632)
cell_area_agrimonia <- st_area(sf_data_agrimonia_utm) # Area in m^2

# Trasforma i dati in UTM per IEDD
sf_data_iedd_utm <- st_transform(sf_data_iedd, 32632)
cell_area_iedd <- st_area(sf_data_iedd_utm) # Area in m^2

# Calcolo totale per AGRIMONIA
sf_data_agrimonia_utm$Total_Emission <- sf_data_agrimonia_utm$Mean_Emission * cell_area_agrimonia
total_agrimonia <- sum(sf_data_agrimonia_utm$Total_Emission, na.rm = TRUE)

# Calcolo totale per IEDD
sf_data_iedd_utm$Total_Emission <- sf_data_iedd_utm$value * cell_area_iedd
total_iedd <- sum(sf_data_iedd_utm$Total_Emission, na.rm = TRUE)

# Stampa i risultati
cat("Totale emissioni AGRIMONIA (mg/day):", total_agrimonia, "\n")
cat("Totale emissioni IEDD (mg/day):", total_iedd, "\n")

##################
# Costante per conversione gradi a metri
lat_m <- 111320 # Lunghezza di 1 grado di latitudine in metri

# Calcolo delle aree per AGRIMONIA (0.1 x 0.1 gradi)
calculate_cell_area <- function(latitude, delta_lat, delta_lon) {
  lon_m <- lat_m * cos(latitude * pi / 180) # Lunghezza di 1 grado di longitudine
  area <- delta_lat * lat_m * delta_lon * lon_m
  return(area)
}

# Aree per AGRIMONIA
sf_data_agrimonia$Area_m2 <- sapply(st_coordinates(sf_data_agrimonia)[, 2], function(lat) {
  calculate_cell_area(lat, delta_lat = 0.1, delta_lon = 0.1)
})

# Aree per IEDD (0.05 x 0.1 gradi)
sf_data_iedd$Area_m2 <- sapply(st_coordinates(sf_data_iedd)[, 2], function(lat) {
  calculate_cell_area(lat, delta_lat = 0.05, delta_lon = 0.1)
})

# Calcolo totale emissioni per AGRIMONIA
sf_data_agrimonia$Total_Emission <- sf_data_agrimonia$Mean_Emission * sf_data_agrimonia$Area_m2
total_agrimonia <- sum(sf_data_agrimonia$Total_Emission, na.rm = TRUE)

# Calcolo totale emissioni per IEDD
sf_data_iedd$Total_Emission <- sf_data_iedd$value * sf_data_iedd$Area_m2
total_iedd <- sum(sf_data_iedd$Total_Emission, na.rm = TRUE)

# Conversione dei totali in Kton/year
convert_to_kton_year <- function(total_emissions_mg_day) {
  total_ton_year <- (total_emissions_mg_day / 1e9) * 365 # Converti a ton/year
  total_kton_year <- total_ton_year / 1e3                # Converti a Kton/year
  return(total_kton_year)
}

# Calcola emissioni totali in Kton/year per AGRIMONIA
total_agrimonia_kton <- convert_to_kton_year(total_agrimonia)

# Calcola emissioni totali in Kton/year per IEDD
total_iedd_kton <- convert_to_kton_year(total_iedd)

# Stampa i risultati
cat("Totale emissioni AGRIMONIA (Kton/year):", total_agrimonia_kton, "\n")
cat("Totale emissioni IEDD (Kton/year):", total_iedd_kton, "\n")




## INEMAR ####

# Carica i dati INEMAR

# Carica i dati utilizzando read.csv
inemar_data <- read.csv(file="Demo\\Data\\Raw\\INEMAR\\Dati_INEMAR_2021_richiesti_il_06-Nov-2024_11.49.35.csv", 
                        header = TRUE,    # Il file ha intestazioni nelle colonne
                        sep = ",",        # Separatore del file CSV
                        stringsAsFactors = FALSE)  # Per evitare di convertire stringhe in fattori

# Controlla le prime righe del dataset
head(inemar_data)

# Verifica struttura del dataset
str(inemar_data)


# Rimuovi la prima riga che contiene valori non numerici (sembra essere un errore)
inemar_data <- inemar_data[-1, ]

# Converte i valori numerici in formato corretto
inemar_data$PM10 <- as.numeric(inemar_data$PM10)
inemar_data$NH3 <- as.numeric(inemar_data$NH3)
inemar_data$NOx <- as.numeric(inemar_data$NOx)
inemar_data$PM2.5 <- as.numeric(inemar_data$PM2.5)

# Rimuovi colonne non necessarie (ad esempio 'X', che sembra vuota)
#inemar_data <- inemar_data[, -ncol(inemar_data)] # Elimina ultima colonna

# Raggruppa i dati per inquinante
library(dplyr)

# Aggrega i dati per PM10
pm10_data <- inemar_data %>%
  select(Nome.comune, PM10) %>%
  filter(!is.na(PM10))  # Escludi i valori NA

# Aggrega i dati per NH3
nh3_data <- inemar_data %>%
  select(Nome.comune, NH3) %>%
  filter(!is.na(NH3))

# Aggrega i dati per NOx
nox_data <- inemar_data %>%
  select(Nome.comune, NOx) %>%
  filter(!is.na(NOx))

# Aggrega i dati per PM2.5
pm25_data <- inemar_data %>%
  select(Nome.comune, PM2.5) %>%
  filter(!is.na(PM2.5))

# Visualizza i primi risultati per ogni inquinante
head(pm10_data)
head(nh3_data)
head(nox_data)
head(pm25_data)

# Carica le librerie necessarie
library(ggplot2)
library(sf)
library(dplyr)
library(viridis)

# Funzione per generare e salvare i plot
# Funzione per generare e salvare i plot con scala logaritmica
generate_and_save_plots <- function(shapefile_path, pollutants_data, output_dir) {
  # Crea la directory di output se non esiste
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Lista dei pollutant
  pollutants <- list(
    PM10 = "PM10",
    NH3 = "NH3",
    NOx = "NOx",
    PM2.5 = "PM2.5"
  )
  
  # Loop su ogni inquinante per generare e salvare i plot
  for (pollutant_name in names(pollutants)) {
    pollutant_column <- pollutants[[pollutant_name]]
    pollutant_data <- pollutants_data[[pollutant_name]]
    
    # Carica il file shapefile
    all_comuni_map <- st_read(shapefile_path, quiet = TRUE)
    
    # Filtra i comuni della Lombardia (COD_REG = 3)
    lombardia_map <- all_comuni_map %>% filter(COD_REG == 3)
    
    # Rinomina la colonna 'COMUNE' dello shapefile per corrispondere ai dati di inquinanti
    lombardia_map <- lombardia_map %>%
      rename(Nome.comune = COMUNE)
    
    # Normalizza i nomi dei comuni in entrambi i dataset
    pollutant_data <- pollutant_data %>%
      mutate(Nome.comune = toupper(trimws(Nome.comune)))
    
    lombardia_map <- lombardia_map %>%
      mutate(Nome.comune = toupper(trimws(Nome.comune)))
    
    # Unisci i dati dei comuni con i valori dell'inquinante
    lombardia_data <- lombardia_map %>%
      left_join(pollutant_data, by = "Nome.comune")
    
    # Identifica comuni senza valori associati
    missing_values <- lombardia_data %>% filter(is.na(!!sym(pollutant_column)))
    if (nrow(missing_values) > 0) {
      cat("Attenzione: ", nrow(missing_values), " comuni non hanno valori per ", pollutant_name, ".\n")
      print(missing_values$Nome.comune) # Stampa i comuni senza dati
    }
    
    # Plotta la mappa con scala log10
    plot <- ggplot(data = lombardia_data) +
      geom_sf(aes_string(fill = pollutant_column), color = "black", size = 0.2) +
      scale_fill_viridis_c(
        option = "viridis",
        trans = "log10",  # Scala logaritmica
        name = paste0(pollutant_name, " (kton)")
      ) +
      labs(title = paste("Distribuzione di", pollutant_name, "nei Comuni della Lombardia"),
           subtitle = "Scala logaritmica - Dati INEMAR 2021",
           caption = "Fonte: INEMAR e shapefile ITA-Administrative-maps-2024",
           x = NULL, y = NULL) +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5, size = 18),
        legend.title = element_text(size = 20),
        legend.text = element_text(size = 16),
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 18)
      )

    
    # Salva il plot
    output_file <- file.path(output_dir, paste0(pollutant_name, "_plot.png"))
    ggsave(output_file, plot, width = 10, height = 7)
    cat("Plot salvato per", pollutant_name, "in:", output_file, "\n")
  }
}

# Percorso del file shapefile
shapefile_path <- "Demo\\Data\\Raw\\MAPS\\Com2021\\Com2021.shp"

# Directory di output per i plot
output_dir <- "Plots/INEMAR"

# Lista dei dataset per ciascun pollutant
pollutants_data <- list(
  PM10 = pm10_data,
  NH3 = nh3_data,
  NOx = nox_data,
  PM2.5 = pm25_data
)

# Genera e salva i plot
generate_and_save_plots(shapefile_path, pollutants_data, output_dir)



# Calcola la somma totale delle emissioni
total_emissions <- calculate_total_emissions(pollutants_data)

# Stampa i risultati
print(total_emissions)

# Salva i risultati in un file CSV
write.csv(total_emissions, file = "Plots/INEMAR/total_emissions_lombardia.csv", row.names = FALSE)
cat("Somma totale delle emissioni salvata in: Plots/INEMAR/total_emissions_lombardia.csv\n")

## Totali INEMAR nazionali ####
# Carica le librerie necessarie
library(readxl)
library(ggplot2)
library(dplyr)

# Leggi i dati dal file Excel
file_path <- "Demo/Data/Raw/INEMAR/Totali-Italia-2000-2020.xlsx"
inemar_nazionale <- read_excel(file_path)

# Mostra le prime righe per verificare il contenuto
head(inemar_nazionale)

# Rimuovi righe vuote o con valori NA
inemar_nazionale <- inemar_nazionale %>%
  filter(!is.na(YEAR))

# Rinomina le colonne per renderle più facili da usare
colnames(inemar_nazionale) <- c("YEAR", "NOx", "NMVOC", "SOx", "NH3", "PM2.5", "PM10", "CO")

# Funzione per plottare le serie temporali
plot_time_series <- function(data, column, pollutant_name) {
  ggplot(data, aes(x = YEAR, y = !!sym(column))) +
    geom_line(color = "blue", size = 1) +
    geom_point(color = "red", size = 2) +
    labs(
      title = paste("Emissioni annuali di", pollutant_name, "in Italia"),
      x = "Anno",
      y = paste(pollutant_name, "(kton)")
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 16, hjust = 0.5),
      axis.title = element_text(size = 14),
      axis.text = element_text(size = 12)
    )
}

# Elenco degli inquinanti da plottare
pollutants <- c("NOx", "NMVOC", "SOx", "NH3", "PM2.5", "PM10", "CO")

# Crea una directory per salvare i grafici
output_dir <- "Plots/INEMAR"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# Genera i grafici per ogni inquinante
for (pollutant in pollutants) {
  plot <- plot_time_series(inemar_nazionale, pollutant, pollutant)
  output_file <- file.path(output_dir, paste0(pollutant, "_time_series.png"))
  ggsave(output_file, plot, dpi = 300, width = 10, height = 6)
  cat("Plot salvato in:", output_file, "\n")
}

# Calcola i totali per ogni inquinante
totals <- inemar_nazionale %>%
  summarise(across(everything(), sum, na.rm = TRUE)) %>%
  select(-YEAR)

# Mostra i totali
print(totals)

# Salva i totali in un file CSV
write.csv(totals, file = file.path(output_dir, "Totali_Emissioni_Italia.csv"), row.names = FALSE)
cat("Totali salvati in: Totali_Emissioni_Italia.csv\n")

## TOTALI IEDD ####

# Carica le librerie necessarie
library(sf)
library(dplyr)
library(ggplot2)

# Percorso del file shapefile
shapefile_path <- "C:/Users/aminb/Desktop/IEDD/Demo/Data/Raw/MAPS/ITA-Administrative-maps-2024/RipGeo01012024_g/RipGeo01012024_g_WGS84.shp"

# Leggi lo shapefile delle ripartizioni
ripartizioni_shapefile <- st_read(shapefile_path)
ripartizioni_shapefile <- st_make_valid(ripartizioni_shapefile) # Correggi le geometrie
ripartizioni_shapefile <- st_transform(ripartizioni_shapefile, 4326) # Assicurati che sia in EPSG 4326

# Funzione per calcolare l'area della cella in m^2
lat_m <- 111320 # Lunghezza di 1 grado di latitudine in metri
calculate_cell_area <- function(latitude, delta_lat, delta_lon) {
  lon_m <- lat_m * cos(latitude * pi / 180) # Lunghezza di 1 grado di longitudine
  area <- delta_lat * lat_m * delta_lon * lon_m
  return(area)
}

# Funzione per calcolare emissioni totali
process_emissions <- function(data_matrix, pollutant_name, year) {
  # Crea un dataframe con latitudine, longitudine e valori dalla matrice
  df <- expand.grid(
    lon = lon_lat_idx$lon[lon_lat_idx$lon_idx],
    lat = lon_lat_idx$lat[lon_lat_idx$lat_idx]
  )
  df$value <- as.vector(data_matrix) # Assegna i valori dalla matrice
  
  # Rimuovi NA e infiniti
  df <- df[is.finite(df$value), ]
  
  # Convertilo in oggetto sf
  sf_data <- st_as_sf(df, coords = c("lon", "lat"), crs = 4326)
  
  # Aggiungi l'area delle celle in m^2
  sf_data$Area_m2 <- sapply(st_coordinates(sf_data)[, 2], function(lat) {
    calculate_cell_area(lat, delta_lat = 0.05, delta_lon = 0.1)
  })
  
  # Calcola le emissioni totali per cella
  sf_data$Total_Emission <- sf_data$value * sf_data$Area_m2
  
  # Intersezione con le ripartizioni
  sf_data_ripartizioni <- st_intersection(sf_data, ripartizioni_shapefile)
  
  # Raggruppa per ripartizione e somma le emissioni totali
  totali_ripartizioni <- sf_data_ripartizioni %>%
    group_by(DEN_RIP) %>%
    summarise(Total_Emission_mg_day = sum(Total_Emission, na.rm = TRUE))
  
  # Conversione delle emissioni in Kton/year
  totali_ripartizioni <- totali_ripartizioni %>%
    mutate(
      Pollutant = pollutant_name,
      Year = year,
      Total_Emission_Kton_year = (Total_Emission_mg_day / 1e9) * 365 / 1e3
    )
  
  return(totali_ripartizioni)
}

# Lista dei pollutant e delle relative matrici
pollutants <- list(
  #NH3 = REG_ANT_yearly_data_nh3,
  #NOx = REG_ANT_yearly_data_nox,
  #NMVOC = REG_ANT_yearly_data_nmvoc,
  #PM10 = REG_ANT_yearly_data_pm10,
  #PM2.5 = REG_ANT_yearly_data_pm2.5,
  CO = REG_ANT_yearly_data_co,
  #SOx = REG_ANT_yearly_data_so2
)

# Lista degli anni
years <- 2000:2020

# Dataframe finale per i risultati
all_results <- data.frame()

# Itera su ogni inquinante e anno
for (pollutant_name in names(pollutants)) {
  pollutant_matrix <- pollutants[[pollutant_name]]
  
  for (year in years) {
    cat("Processing", pollutant_name, "for year", year, "\n")
    
    # Estrai i dati dalla matrice per l'anno corrente
    data_matrix <- pollutant_matrix[,,13,year - 1999]
    
    # Calcola le emissioni totali
    results <- process_emissions(data_matrix, pollutant_name, year)
    
    # Rimuovi le colonne geometriche prima di combinare (se presente)
    results_df <- results %>%
      st_drop_geometry() %>% # Rimuove le geometrie
      select(DEN_RIP, Pollutant, Year, Total_Emission_Kton_year) # Standardizza le colonne
    
    # Aggiungi i risultati al dataframe finale
    all_results <- bind_rows(all_results, results_df)
  }
}

all_results <- all_results$Total_Emission_Kton_year*10^6*60*60*24


# Salva i risultati in un file CSV
write.csv(all_results, file = "Emissions_Totals_Ripartizioni.csv", row.names = FALSE)

# Visualizza i risultati
print(all_results)

# Visualizza i risultati
print(all_results)

all_results<-read.csv("Emissions_Totals_Ripartizioni.csv")

# Calcolo dei totali nazionali
national_totals <- all_results %>%
  group_by(Pollutant, Year) %>%
  summarise(Total_Emission_Kton_year = sum(Total_Emission_Kton_year, na.rm = TRUE), .groups = "drop")

national_totals$Total_Emission_Kton_year<-national_totals$Total_Emission_Kton_year*10^6*60*60*24
# Salva i risultati in un file CSV
write.csv(national_totals, file = "IEDD_Totals_Italy_Test.csv", row.names = FALSE)


# Plot delle emissioni totali per ripartizione, inquinante e anno
ggplot(all_results, aes(x = Year, y = Total_Emission_Kton_year, color = DEN_RIP)) +
  geom_line(size = 1) +
  facet_wrap(~Pollutant, scales = "free_y") +
  labs(
    title = "Emissioni Totali per Ripartizione e Inquinante",
    x = "Anno",
    y = "Emissioni Totali (Kton/year)"
  ) +
  theme_minimal()


library(ggplot2)
library(dplyr)

# Carica i dati (adatta il percorso del file CSV)
data <- read.csv("IEDD_Totals_Italy_Test.csv")

# Converte la colonna "Year" in numerico
data$Year <- as.numeric(data$Year)

# Crea una directory per salvare i grafici
output_dir <- "Pollutant_Timeseries_Plots"
if (!dir.exists(output_dir)) dir.create(output_dir)

# Estrai l'elenco dei pollutanti
pollutants <- unique(data$Pollutant)

# Itera su ciascun pollutante per creare e salvare i grafici
for (pollutant in pollutants) {
  # Filtra i dati per il pollutante corrente
  pollutant_data <- data %>% filter(Pollutant == pollutant)
  
  # Crea il grafico
  p <- ggplot(pollutant_data, aes(x = Year, y = Total_Emission_Kton_year)) +
    geom_line(color = "blue", size = 1) +
    geom_point(color = "red", size = 2) +
    labs(
      title = paste("Trend of", pollutant, "Emissions in Italy (2000-2020)"),
      x = "Year",
      y = "Total Emissions (Kton/year)"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
      axis.title = element_text(size = 14),
      axis.text = element_text(size = 12)
    )
  
  # Salva il grafico
  ggsave(filename = paste0(output_dir, "/", pollutant, "_timeseries.png"), plot = p, width = 10, height = 6, dpi = 300)
}

for(y in 1:21){
  print(sum(REG_ANT_yearly_data_co[,,13,y]*10^6*60*60*24))
}



library(ggplot2)
library(dplyr)

# Carica i dati INEMAR
inemar_nazionale <- read.csv("inemar_nazionale.csv")  # Cambia con il percorso corretto

# Carica i dati IEDD
iedd_totals_italy <- read.csv("IEDD_Totals_Italy_Test.csv")  # Cambia con il percorso corretto

inemar_nazionale$
library(dplyr)

# Rinomina le colonne del dataset INEMAR per un confronto chiaro
inemar_nazionale_clean <- inemar_nazionale %>%
  rename(
    INEMAR_NOx = NOx,
    INEMAR_NMVOC = NMVOC,
    INEMAR_SOx = SOx,
    INEMAR_NH3 = NH3,
    INEMAR_PM2.5 = PM2.5,
    INEMAR_PM10 = PM10,
    INEMAR_CO = CO
  ) %>%
  select(YEAR, INEMAR_NOx, INEMAR_NMVOC, INEMAR_SOx, INEMAR_NH3, INEMAR_PM2.5, INEMAR_PM10, INEMAR_CO)

iedd_totals_italy_wide <- iedd_totals_italy %>%
  pivot_wider(names_from = Pollutant, values_from = Total_Emission_Kton_year, names_prefix = "IEDD_") %>%
  rename(
    Year = Year, 
    IEDD_NOx = IEDD_NOx,
    IEDD_NMVOC = IEDD_NMVOC,
    IEDD_SOx = IEDD_SOx,
    IEDD_NH3 = IEDD_NH3,
    IEDD_PM2.5 = IEDD_PM2.5,
    IEDD_PM10 = IEDD_PM10,
    IEDD_CO = IEDD_CO
  )
# Unisci i due dataset
comparison_table <- inemar_nazionale_clean %>%
  left_join(iedd_totals_italy_clean, by = c("YEAR" = "Year"))

# Visualizza i primi dati per verificare il risultato
print(head(comparison_table))

# Salva la tabella di confronto in un file CSV per analisi futura
write.csv(comparison_table, "comparison_inemar_iedd.csv", row.names = FALSE)
cat("Tabella di confronto salvata in: comparison_inemar_iedd.csv\n")


# Salva la tabella in un CSV
write.csv(comparison_table, "Comparison_INEMAR_IEDD.csv", row.names = FALSE)

# Plottare i grafici per ciascun pollutante
pollutants <- c("NOx", "NMVOC", "SOx", "NH3", "PM2.5", "PM10", "CO")

output_dir <- "Plots/Comparison"
if (!dir.exists(output_dir)) dir.create(output_dir)

for (pollutant in pollutants) {
  # Estrai i dati per il pollutante corrente
  plot_data <- comparison_table %>%
    select(YEAR, starts_with(paste0("INEMAR_", pollutant)), starts_with(paste0("IEDD_", pollutant))) %>%
    rename(
      ISPRA = starts_with("INEMAR"),
      IEDD = starts_with("IEDD")
    )
  
  # Crea il grafico
  p <- ggplot(plot_data, aes(x = YEAR)) +
    geom_line(aes(y = ISPRA, color = "ISPRA"), size = 1) +
    geom_line(aes(y = IEDD, color = "IEDD"), size = 1, linetype = "dashed") +
    labs(
      title = paste("Comparison of", pollutant, "Emissions in Italy"),
      x = "Year",
      y = paste(pollutant, "Emissions (Kton/year)"),
      color = "Dataset"
    ) +
    scale_color_manual(values = c("ISPRA" = "blue", "IEDD" = "red")) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
      legend.title = element_text(size = 14),
      legend.text = element_text(size = 12),
      axis.title = element_text(size = 14),
      axis.text = element_text(size = 12)
    )
  
  # Salva il grafico
  ggsave(filename = paste0(output_dir, "/", pollutant, "_Comparison.png"), plot = p, width = 10, height = 6, dpi = 300)
}


library(ggplot2)
library(dplyr)

# Prepara i dati per il confronto
comparison_table_co <- comparison_table %>%
  filter(Pollutant == "CO") %>%
  mutate(
    IEDD_Camouflaged = ifelse(Year > 2017, NA, Total_Emission_Kton_year) # Camuffa dati >2017
  )

# Genera il grafico
plot_co_comparison <- ggplot(data = comparison_table_co, aes(x = Year)) +
  # Dati INEMAR
  geom_line(aes(y = INEMAR_CO, color = "INEMAR"), size = 1.2) +
  geom_point(aes(y = INEMAR_CO, color = "INEMAR"), size = 3) +
  # Dati IEDD (camuffati dopo il 2017)
  geom_line(aes(y = IEDD_Camouflaged, color = "IEDD"), size = 1.2) +
  geom_point(aes(y = IEDD_Camouflaged, color = "IEDD"), size = 3) +
  # Etichette e legenda
  labs(
    title = "Comparison of CO Emissions in Italy (2000-2020)",
    x = "Year",
    y = "Total Emissions (Kton/year)",
    color = "Dataset"
  ) +
  scale_color_manual(values = c("National Inven" = "red", "IEDD" = "blue")) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12),
    panel.grid.minor = element_blank()
  )

# Visualizza il grafico
print(plot_co_comparison)

# Salva il grafico in un file
ggsave("Comparison_CO_Emissions_2000_2020_Camouflaged.png", plot = plot_co_comparison, dpi = 300, width = 10, height = 6)




# Installa ggmap se non è già installato
if (!require(ggmap)) install.packages("ggmap")
library(ggmap)

# Definire i limiti geografici della Po Valley
po_valley_bounds <- c(left = 7.5, bottom = 44, right = 12.5, top = 46)

# Ottenere la mappa satellitare utilizzando OpenStreetMap come provider
po_valley_map <- get_stadiamap(
  bbox = po_valley_bounds, 
  maptype = "terrain", # Cambia con "satellite" se hai accesso alle API di Google Maps
  zoom = 8             # Livello di dettaglio
)

# Creare la mappa
ggmap(po_valley_map) +
  labs(
    title = "Satellitare della Pianura Padana",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 14)
  )

