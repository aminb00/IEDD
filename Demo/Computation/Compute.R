calculate_daily_matrices <- function(profile, yearly_data_file, temporal_profile_folder, output_folder) {
  
  # Controlla se il profilo è giornaliero basandosi sul prefisso "FD"
  if (startsWith(profile, "FD")) {
    message("Calcolo del profilo giornaliero per: ", profile)
    
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
      profile_matrix <- readRDS(file.path(temporal_profile_folder, paste0(profile, current_year, ".rds")))
      
      # Inizializza una matrice per i dati giornalieri
      num_days <- dim(profile_matrix)[3] # Numero di giorni (365 o 366)
      computed_data <- array(0, dim = c(dim(yearly_data)[1:2], num_days))
      
      # Estrai la matrice annuale per l'anno corrente
      year_data <- yearly_data[,,3,y]
      
      # Calcolo dei dati giornalieri
      # Aggiungi qui il calcolo specifico che viene fatto per ogni giorno usando year_data e profile_matrix
      
      # Salva i dati calcolati nel folder di output
      saveRDS(computed_data, file.path(output_folder, paste0("computed_", profile, "_", current_year, ".rds")))
    }
    
  } else {
    message("Profilo non riconosciuto come giornaliero: ", profile)
    # Qui puoi gestire altri tipi di profili se necessario
  }
}

