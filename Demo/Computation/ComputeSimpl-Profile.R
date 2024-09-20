# Funzione per verificare se un anno è bisestile
is_leap_year <- function(year) {
  return((year %% 4 == 0 & year %% 100 != 0) | (year %% 400 == 0))
}

# Funzione per ottenere il numero di giorni in ogni mese, dato un anno
get_days_in_month <- function(year) {
  if (is_leap_year(year)) {
    return(c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))  # Anno bisestile
  } else {
    return(c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))  # Anno non bisestile
  }
}

# Funzione per creare il profilo giornaliero per un dato anno
create_profile_for_year <- function(year, x_csm, y_csw) {
  # Ottiene il numero di giorni in ogni mese
  nmj <- get_days_in_month(year)
  
  # Normalizza i pesi mensili e settimanali
  x_csm_norm <- x_csm / sum(x_csm)
  y_csw_norm <- y_csw / sum(y_csw)
  
  # Profilo giornaliero
  daily_profile <- c()
  current_weekday <- get_first_day_of_year(year) + 1  # Calcola il primo giorno dell'anno
  
  # Loop su ciascun mese
  for (m in 1:12) {
    days_in_month <- nmj[m]
    week_factor <- 7 / days_in_month
    
    for (d in 1:days_in_month) {
      # Calcola il valore del profilo giornaliero
      daily_profile_d <- x_csm_norm[m] * week_factor * y_csw_norm[current_weekday]
      daily_profile <- c(daily_profile, daily_profile_d)
      
      # Aggiorna il giorno della settimana
      current_weekday <- (current_weekday %% 7) + 1
    }
  }
  return(daily_profile)
}

# Funzione per creare la matrice multidimensionale dei profili giornalieri per tutti i settori GNFR
create_multidimensional_profile <- function(year, nh3_monthly, nh3_weekly, output_folder) {
  # Elenco dei settori GNFR
  GNFR_sectors <- unique(nh3_monthly$GNFR)
  
  # Numero di giorni nell'anno
  days_in_year <- ifelse(is_leap_year(year), 366, 365)
  
  # Creazione della matrice multidimensionale dei profili giornalieri
  profile_matrix <- matrix(NA, nrow = days_in_year, ncol = length(GNFR_sectors))
  colnames(profile_matrix) <- GNFR_sectors
  
  # Creazione del profilo giornaliero per ciascun settore GNFR
  for (sector in GNFR_sectors) {
    # Estrai i profili mensili e settimanali
    x_csm <- as.numeric(nh3_monthly[nh3_monthly$GNFR == sector, c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")])
    y_csw <- as.numeric(nh3_weekly[nh3_weekly$GNFR == sector, c("Mo", "Tu", "We", "Th", "Fr", "Sa", "Su")])
    
    # Crea il profilo giornaliero
    daily_profile <- create_profile_for_year(year, x_csm, y_csw)
    
    # Inserisci il profilo nella matrice
    profile_matrix[, sector] <- daily_profile
  }
  
  # Salva la matrice del profilo giornaliero
  saveRDS(profile_matrix, file = file.path(output_folder, paste0("profile_matrix_", year, ".rds")))
}

# Esempio di utilizzo:
year <- 2000
output_folder <- "Demo/Data/Processed"
create_multidimensional_profile(year, nh3_monthly, nh3_weekly, output_folder)

