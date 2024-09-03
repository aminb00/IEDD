# Funzione per calcolare le matrici giornaliere
calculate_daily_matrices <- function(yearly_data_file, temporal_profile_folder, output_folder) {
  
  # Carica la matrice annuale 4D
  yearly_data <- readRDS(file.path(yearly_data_file))
  
  # Estrarre il numero di anni dalla dimensione della matrice annuale
  num_years <- dim(yearly_data)[4]
  
  # L'anno di partenza è il 2000
  start_year <- 2000
  
  for (y in 1:num_years) {
    
    # Calcola l'anno corrente
    current_year <- start_year + (y - 1)
    
    # Carica il profilo temporale corrispondente all'anno corrente
    profile_matrix <- readRDS(file.path(temporal_profile_folder, paste0("FD_C_", current_year, ".rds")))
    
    # Inizializza una matrice per i dati giornalieri
    num_days <- dim(profile_matrix)[3] # Numero di giorni (365 o 366)
    computed_data <- array(0, dim = c(dim(yearly_data)[1:2], num_days))
    
    # Estrai la matrice annuale per l'anno corrente
    year_data <- yearly_data[,,3,y]
    
    # Calcola i dati giornalieri moltiplicando per il profilo temporale
    for (i in 1:num_days) {
      computed_data[,,i] <- year_data * profile_matrix[,,i]
    }
    
    # Mantieni le dimensioni e i nomi originali
    dimnames(computed_data) <- dimnames(year_data)
    
    # Salva la matrice giornaliera calcolata in un file .rds
    output_file <- file.path(output_folder, paste0("NH3", "_sectorC", current_year,"_daily",".rds"))
    saveRDS(computed_data, file = output_file)
    
    cat("File salvato:", output_file, "\n")
  }
}

# Esempio di utilizzo della funzione
yearly_data_file <- "Demo/Data/Processed/ANT_data/REG_ANT_yearly_data.rds"
temporal_profile_folder <- "Demo/Data/Processed/TEMPO_data"
output_folder <- "Demo/Data/Processed/DAILY_data"

calculate_daily_matrices(yearly_data_file, temporal_profile_folder, output_folder)
