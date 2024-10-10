# Funzione per creare i dati giornalieri dai profili temporali
calculate_daily_matrices <- function(yearly_data_file, temporal_profile_file, output_folder, sector) {
  
  # Carica la matrice annuale 4D
  yearly_data <- readRDS(yearly_data_file)
  
  # Carica il profilo temporale giornaliero
  profile_matrix <- readRDS(temporal_profile_file)
  
  # Estrarre il numero di anni dalla dimensione della matrice annuale
  num_years <- dim(yearly_data)[4]
  
  sector_index<-3
  
  #if (is.na(sector_index) || sector_index > dim(yearly_data)[3]) {
  #  stop("Il settore selezionato non esiste nei dati.")
  #}
  
  # Loop attraverso gli anni
  start_year <- 2000
  for (y in 1:num_years) {
    current_year <- start_year + (y - 1)
    
    # Inizializza una matrice per i dati giornalieri
    num_days <- nrow(profile_matrix) # Numero di giorni (365 o 366)
    computed_data <- array(0, dim = c(dim(yearly_data)[1:2], num_days))
    
    # Estrai i dati annuali per il settore e l'anno corrente
    year_data <- yearly_data[,,sector_index,y]
    
    # Moltiplica i dati annuali per il profilo giornaliero
    for (i in 1:num_days) {
      computed_data[,,i] <- year_data * profile_matrix[i, sector_index]
    }
    
    # Salva la matrice giornaliera in un file .rds
    output_file <- file.path(output_folder, paste0("NH3_sector_", sector, "_", current_year, "_daily.rds"))
    saveRDS(computed_data, file = output_file)
    
    cat("File salvato:", output_file, "\n")
  }
}

# Esempio di utilizzo:
yearly_data_file <- "Demo/Data/Processed/ANT_data/REG_ANT_yearly_data.rds"
temporal_profile_file <- "Demo/Data/Processed/TEMPO_data/FD_C2000.rds"
output_folder <- "Demo/Data/Processed/DAILY_data"
sector <- "C"
calculate_daily_matrices(yearly_data_file, temporal_profile_file, output_folder, sector)
