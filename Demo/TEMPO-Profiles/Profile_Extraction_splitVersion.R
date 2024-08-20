library(ncdf4)
library(reshape2)

# Funzione per estrarre e salvare i profili temporali in file separati per anno
extract_and_save_profiles_by_year <- function(nc_file_path, profile_name, start_year, end_year, output_dir) {
  nc <- nc_open(nc_file_path)
  
  # Ottenere lon, lat dal file netCDF
  lon <- ncvar_get(nc, "longitude")
  lat <- ncvar_get(nc, "latitude")
  
  # Bounding box index
  lon_idx <- which(lon >= boundary[1] & lon <= boundary[2])
  lat_idx <- which(lat >= boundary[3] & lat <= boundary[4])
  
  profile_info <- list(
    FD_C = list(var_name = "FD_C", temporal_dim = "daily")
    # Aggiungi altri profili se necessario
  )
  
  if (!(profile_name %in% names(profile_info))) {
    stop("Invalid profile name")
  }
  
  # Calcolare il numero totale di periodi (giorni)
  num_periods <- nc$dim$time$len
  
  # Iterare per ogni anno
  indexFromYear <- 1
  for (year in start_year:end_year) {
    # Determinare se l'anno è bisestile
    if (year %% 4 == 0) {
      days_in_year <- 366
    } else {
      days_in_year <- 365
    }
    
    # Preparare la lista di data frame per l'anno corrente
    list_of_dfs <- vector("list", days_in_year)
    
    for (day in 1:days_in_year) {
      start_idx <- c(min(lon_idx), min(lat_idx), indexFromYear + day - 1)
      count_idx <- c(length(lon_idx), length(lat_idx), 1)
      
      profile_data <- ncvar_get(nc, profile_info[[profile_name]]$var_name, start = start_idx, count = count_idx)
      
      # Creare il dataframe per il giorno corrente
      df <- expand.grid(x = lon[lon_idx], y = lat[lat_idx])
      df$value <- as.vector(profile_data)
      
      # Aggiungere il dataframe alla lista
      list_of_dfs[[day]] <- df
    }
    
    # Salvare la lista di data frame in un file RDS per l'anno corrente
    saveRDS(list_of_dfs, file = file.path(output_dir, paste0(profile_name, "_", year, ".rds")))
    
    # Liberare memoria
    rm(list_of_dfs)
    gc()
    
    # Aggiornare l'indice di inizio per l'anno successivo
    indexFromYear <- indexFromYear + days_in_year
  }
  
  # Chiudere il file netCDF
  nc_close(nc)
}

# Esempio di utilizzo della funzione
nc_file_path <- "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-TEMPO\\CAMS-REG-TEMPO_EUR_0.1x0.1_tmp_weights_v3.1_daily.nc"
output_dir <- "C:\\Users\\aminb\\Desktop\\IEDD\\Demo\\Data"
extract_and_save_profiles_by_year(nc_file_path, "FD_C", 2000, 2020, output_dir)



