library(abind)

StackDailyData <- function(input_folder, sector, pollutant, start_year, end_year) {
  # Lista per contenere tutte le matrici giornaliere
  daily_data_list <- list()
  
  # Cicla su tutti gli anni forniti
  for (year in start_year:end_year) {
    # Costruisci il nome del file per l'anno e il pollutant
    daily_data_file <- file.path(input_folder, paste0("Daily_", sector, "_", year, "_", pollutant, ".rds"))
    
    # Verifica se il file esiste
    if (!file.exists(daily_data_file)) {
      stop(paste("Il file per l'anno", year, "non è stato trovato:", daily_data_file))
    }
    
    # Carica i dati giornalieri per l'anno
    daily_data <- readRDS(daily_data_file)
    
    # Aggiungi i dati giornalieri alla lista
    daily_data_list[[as.character(year)]] <- daily_data
  }
  
  # Combina tutte le matrici lungo la dimensione del tempo (giorni)
  stacked_daily_data <- abind(daily_data_list, along = 3)
  
  #Salva in memoria come rds
  saveRDS(stacked_daily_data, file.path(input_folder, paste0("StackedDaily_", sector, "_", start_year, "_", end_year, "_", pollutant, ".rds")))
  
}


