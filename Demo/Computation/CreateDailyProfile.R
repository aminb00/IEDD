library(lubridate)

create_DailyProfile <- function(profilescouple, start_year, end_year, sector_letter, output_folder) {
  # Estrazione dei profili mensile e settimanale dalla coppia
  monthly_profile <- profilescouple[[1]]
  weekly_profile <- profilescouple[[2]]
  sector_letter <- profilescouple[[3]]
  
  # Itera su ciascun anno nell'intervallo specificato
  for (year in start_year:end_year) {
    # Definisce le date di inizio e fine per l'anno corrente
    startdate <- as.Date(paste0(year, "-01-01"))
    enddate <- as.Date(paste0(year, "-12-31"))
    
    # Creazione del vettore di date dal 1 gennaio dell'anno corrente alla fine dell'anno indicato
    all_dates <- seq(startdate, enddate, by = "day")
    
    # Creazione della matrice giornaliera multidimensionale
    # La dimensione sarà la combinazione delle dimensioni dei profili + dimensione temporale
    daily_profile <- array(0, dim = c(dim(weekly_profile[,,1]), length(all_dates)))
    
    # Itera su ciascun giorno per calcolare il peso giornaliero
    for (day in 1:length(all_dates)) {
      current_date <- all_dates[day]
      current_month <- month(current_date) # Mese corrente
      current_weekday <- wday(current_date, week_start = 1) # Giorno della settimana (1 = Lunedì)
      days_in_month <- days_in_month(current_date) # Numero di giorni nel mese corrente
      
      # Calcolo del peso giornaliero seguendo la formula
      monthly_share <- monthly_profile[,,current_month] / 12
      daily_share <- (7 / days_in_month) * (weekly_profile[,,current_weekday] / 7)
      
      # Calcolo del peso totale per il giorno corrente
      total_daily_weight <- monthly_share * daily_share
      
      # Assegna il peso giornaliero alla matrice multidimensionale
      daily_profile[,, day] <- total_daily_weight
    }
    
    # Costruisce il nome del file seguendo il formato D_X_yyyy.rds
    file_name <- paste0("D_", sector_letter, "_", year, ".rds")
    
    # Percorso completo per il salvataggio del file
    output_path <- file.path(output_folder, file_name)
    
    # Salva il profilo giornaliero in formato RDS
    saveRDS(daily_profile, output_path)
    
    message("Profilo giornaliero per l'anno ", year, " salvato in: ", output_path)
  }
}


