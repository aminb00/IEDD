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

# Funzione per ottenere il primo giorno dell'anno
get_first_day_of_year <- function(year) {
  return(as.POSIXlt(paste0(year, "-01-01"))$wday)  # Restituisce 0 per domenica, 1 per lunedì, ..., 6 per sabato
}

# Funzione per creare il profilo giornaliero per un dato anno
create_profile_for_year <- function(year, monthly_profile, weekly_profile) {
  nmj <- get_days_in_month(year)
  
  # Normalizza i pesi mensili e settimanali
  monthly_norm <- monthly_profile / sum(monthly_profile)
  weekly_norm <- weekly_profile / sum(weekly_profile)
  
  # Profilo giornaliero
  daily_profile <- c()
  current_weekday <- get_first_day_of_year(year) + 1
  
  for (m in 1:12) {
    days_in_month <- nmj[m]
    week_factor <- 7 / days_in_month
    
    for (d in 1:days_in_month) {
      daily_value <- monthly_norm[m] * week_factor * weekly_norm[current_weekday]
      daily_profile <- c(daily_profile, daily_value)
      
      current_weekday <- (current_weekday %% 7) + 1
    }
  }
  return(daily_profile)
}

# Funzione per creare una matrice tridimensionale di profili giornalieri per un intervallo di anni
create_multidimensional_profile_for_years <- function(startYear, endYear, monthly_data, weekly_data, output_folder, pollutant_name) {
  # Elenco dei settori GNFR
  GNFR_sectors <- unique(monthly_data$GNFR)
  
  # Determina il numero massimo di giorni (366 per includere anni bisestili)
  max_days_in_year <- 366
  total_years <- endYear - startYear + 1
  
  # Creazione della matrice tridimensionale (giorni, settori GNFR, anni)
  profile_array <- array(NA, dim = c(max_days_in_year, length(GNFR_sectors), total_years))
  dimnames(profile_array) <- list(
    Days = 1:max_days_in_year,
    GNFR = GNFR_sectors,
    Years = startYear:endYear
  )
  
  # Ciclo sugli anni
  for (year in startYear:endYear) {
    # Numero di giorni nell'anno corrente
    days_in_year <- ifelse(is_leap_year(year), 366, 365)
    
    for (sector in GNFR_sectors) {
      monthly_profile <- as.numeric(monthly_data[monthly_data$GNFR == sector, c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")])
      weekly_profile <- as.numeric(weekly_data[weekly_data$GNFR == sector, c("Mo", "Tu", "We", "Th", "Fr", "Sa", "Su")])
      
      # Calcola il profilo giornaliero per l'anno e il settore corrente
      daily_profile <- create_profile_for_year(year, monthly_profile, weekly_profile)
      
      # Inserisci il profilo giornaliero nella matrice tridimensionale
      profile_array[1:days_in_year, sector, year - startYear + 1] <- daily_profile
    }
  }
  
  # Salva la matrice del profilo giornaliero con il nome dell'inquinante
  saveRDS(profile_array, file = file.path(output_folder, paste0(pollutant_name, "_SimpleProfile_", startYear, "_", endYear, ".rds")))
}



#Create Simplified Daily Profile #sto punto non serve!
source("Demo/Computation/CreateSIMPLEdailyProfile.R")

# Define interval and profiles for simplified profile creation
years_interval <- c(2000, 2020)
output_folder <- "Demo/Data/Processed/TEMPO_data/SimplifiedDailyProfiles"
nh3_monthly <- readRDS("Demo/Data/Processed/TEMPO_data/.rds")
PollutantSimpleProfile <- list(nh3_monthly, nh3_weekly, "NH3")

# Create simplified profiles for the specified years
create_multidimensional_profile_for_years(years_interval[1], years_interval[2], 
                                          PollutantSimpleProfile[[1]], 
                                          PollutantSimpleProfile[[2]], 
                                          output_folder, 
                                          PollutantSimpleProfile[3])

