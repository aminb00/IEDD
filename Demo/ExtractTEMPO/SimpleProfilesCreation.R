SimpleProfilesCreation <- function(files_path=Path_simplifiedProfilesCSV, poll) {
  list_profiles <- SimpleProfilesExtraction(files_path, poll)
  
  monthly_profile <- list_profiles[[1]]
  weekly_profile <- list_profiles[[2]]
  
  start_year <- 2000
  end_year <- 2020
  
  # Create a folder for the pollutant if it doesn't already exist
  pollutant_folder <- file.path("Demo/Data/Processed/TEMPO_data/DailySimplifiedProfiles", poll)
  if (!dir.exists(pollutant_folder)) {
    dir.create(pollutant_folder, recursive = TRUE)
  }
  
  for (year in start_year:end_year) {
    print(year)
    
    days_in_month <- get_days_in_month(year)
    current_weekday <- get_first_day_of_year(year)  # Day 1 of the year
    
    # Create the matrix for daily profiles
    sector_profile <- array(0, dim = c(get_days_in_year(year), length(monthly_profile$GNFR)))
    
    sectors <- monthly_profile$GNFR  # Assuming GNFR is a vector of sector names
    
    # Use a numeric index to assign data to the sector_profile array
    for (sector_idx in seq_along(sectors)) {
      sector <- sectors[sector_idx]
      print(sector)
      
      # Get the row for the sector
      monthlyForSector <- monthly_profile[monthly_profile$GNFR == sector, ][, 4:15]
      weeklyForSector <- weekly_profile[weekly_profile$GNFR == sector, ][, 4:10]
      
      daily_profile <- c()
      
      for (month in 1:12) {
        week_factor <- 7 / days_in_month[month]
        
        for (day in 1:days_in_month[month]) {
          day_weight <- monthlyForSector[[month]] * weeklyForSector[[current_weekday]]
          daily_profile <- c(daily_profile, day_weight)
          
          # Update current_weekday, reset to 1 after Sunday (7)
          current_weekday <- ifelse(current_weekday == 7, 1, current_weekday + 1)
        }
      }
      
      # Assign the daily profile to the corresponding sector
      sector_profile[, sector_idx] <- daily_profile
    }
    
    dimnames(sector_profile)[[2]] <- sectors
    # Save the daily profile in the folder created for the pollutant
    output_file <- file.path(pollutant_folder, paste0("S_D_all_", year, "_", poll, ".rds"))
    saveRDS(sector_profile, output_file)
    rm(sector_profile)
  }
}

# Function to check if a year is a leap year
is_leap_year <- function(year) {
  return((year %% 4 == 0 & year %% 100 != 0) | (year %% 400 == 0))
}

# Function to get the number of days in each month for a given year
get_days_in_month <- function(year) {
  if (is_leap_year(year)) {
    return(c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))  # Leap year
  } else {
    return(c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))  # Non-leap year
  }
}

# Function to get the first day of the year
get_first_day_of_year <- function(year) {
  # Get the day of the week, with Sunday as 0
  day_of_week <- as.POSIXlt(paste0(year, "-01-01"))$wday
  
  # Convert 0 (Sunday) to 7 and leave other days unchanged
  return(ifelse(day_of_week == 0, 7, day_of_week))
}

# Function to get the total number of days in a year
get_days_in_year <- function(year) {
  return(ifelse(is_leap_year(year), 366, 365))
}

# Function to extract pollutant profiles from CSV files
SimpleProfilesExtraction <- function(files_path, poll) {
  Monthly_profiles <- ExtractPollutantCSV(files_path[1], poll)
  Weekly_profiles <- ExtractPollutantCSV(files_path[2], poll)
  
  return(list(Monthly_profiles, Weekly_profiles))
}

# Function to read and filter pollutant data from a CSV file
ExtractPollutantCSV <- function(file_path, poll) {
  # Read the CSV file
  data <- read.csv(file_path, header = TRUE, sep = ",")
  
  country <- "ITA"
  # Extract the pollutant data for the specified pollutant and country
  pollutant_data <- data[data$POLL == poll & data$ISO3 == country, ]
  
  return(pollutant_data)
}


