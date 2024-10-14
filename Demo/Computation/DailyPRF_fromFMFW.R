# Funzioni di utilità fornite
is_leap_year <- function(year) {
  return((year %% 4 == 0 & year %% 100 != 0) | (year %% 400 == 0))
}

get_days_in_month <- function(year) {
  if (is_leap_year(year)) {
    return(c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))  # Anno bisestile
  } else {
    return(c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))  # Anno non bisestile
  }
}

get_first_day_of_year <- function(year) {
  # Ottiene il giorno della settimana, con Domenica come 0
  day_of_week <- as.POSIXlt(paste0(year, "-01-01"))$wday
  
  # Converte 0 (Domenica) in 7 e lascia gli altri giorni invariati
  return(ifelse(day_of_week == 0, 7, day_of_week))
}

get_days_in_year <- function(year) {
  return(ifelse(is_leap_year(year), 366, 365))
}

# Funzione principale aggiornata
DailyPRF_fromFMFW <- function(FM_profile, FW_profile, sector) {
  
  start_year <- 2000
  end_year <- 2020
  
  # Crea una cartella per il settore se non esiste già
  sector_folder <- file.path("Demo/Data/Processed/TEMPO_data/DailyProfiles", sector)
  if (!dir.exists(sector_folder)) {
    dir.create(sector_folder, recursive = TRUE)
  }
  
  for (year in start_year:end_year) {
    print(paste("Processing year:", year))
    
    days_in_month <- get_days_in_month(year)
    total_days <- get_days_in_year(year)
    
    # Ottieni il giorno della settimana del primo giorno dell'anno
    current_weekday <- get_first_day_of_year(year)  # 1=Lunedì, ..., 7=Domenica
    
    # Inizializza l'array per il profilo giornaliero
    # Assumendo che FM_profile abbia dimensioni [x, y, 12] e FW_profile abbia dimensioni [x, y, 7]
    x_dim <- dim(FM_profile)[1]
    y_dim <- dim(FM_profile)[2]
    daily_profile <- array(0, dim = c(x_dim, y_dim, total_days))
    
    current_day_of_year <- 1  # Contatore per il giorno dell'anno
    
    for (month in 1:12) {
      print(paste("Processing month:", month))
      
      days_in_current_month <- days_in_month[month]
      
      for (day_in_month in 1:days_in_current_month) {
        # Calcola il profilo giornaliero per il giorno corrente
        daily_profile[,,current_day_of_year] <- FM_profile[,,month] * FW_profile[,,current_weekday]
        
        # Aggiorna i contatori
        current_day_of_year <- current_day_of_year + 1
        current_weekday <- ifelse(current_weekday == 7, 1, current_weekday + 1)
      }
    }
    
    # Salva il profilo giornaliero per l'anno corrente
    output_file <- file.path(sector_folder, paste0("DailyProfile_", year, "_", sector, ".rds"))
    saveRDS(daily_profile, output_file)
    rm(daily_profile)
  }
}

                         
  
  
  
  
    