calculate_using_simplified <- function(matrixprofile, yearly_data, output_folder) {
  
  num_years <- dim(yearly_data)[4]  # Numero di anni
  num_days <- dim(matrixprofile)[1]  # Numero di giorni (365 o 366)
  
  start_year <- 2006  # Anno di inizio
  
  # Estrai i nomi dei settori dai dataset
  sectors_profile <- colnames(matrixprofile[, , 1])
  sectors_yearly <- colnames(yearly_data[1, 1, , 1])
  
  # Assegna i nomi se mancanti in yearly_data
  if (is.null(sectors_yearly)) {
    sectors_yearly <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "S")
    dimnames(yearly_data)[[3]] <- sectors_yearly
  }
  
  # Trova i settori comuni tra yearly_data e matrixprofile
  common_sectors <- intersect(sectors_yearly, sectors_profile)
  
  # Itera sugli anni e sui settori comuni
  for (y in 1:num_years) {
    current_year <- start_year + (y - 1)
    
    for (sector in common_sectors) {
      # Trova gli indici dei settori corrispondenti nei dataset
      index_yearly <- match(sector, sectors_yearly)
      index_profile <- match(sector, sectors_profile)
      
      # Estrai i dati spaziali e il profilo giornaliero per il settore e l'anno corrente
      spatial_data <- yearly_data[,,index_yearly,y]
      sector_profile <- matrixprofile[,index_profile,y]
      
      # Inizializza una matrice per i dati giornalieri
      computed_data <- array(0, dim = c(dim(yearly_data)[1:2], num_days))
      
      # Moltiplicazione giornaliera
      for (i in 1:num_days) {
        computed_data[,,i] <- spatial_data * sector_profile[i]
      }
      
      # Salva i dati calcolati per ogni settore e anno
      saveRDS(computed_data, file.path(output_folder, paste0("computed_sector_", sector, "_", current_year, ".rds")))
    }
  }
}


 calculate_using_simplified(NH3_SimpleProfile_2000_2020, REG_ANT_yearly_data, "Demo/Data/Processed/DAILY_data/Simplified")


