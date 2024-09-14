# Function to check if a year is a leap year
is_leap_year <- function(year) {
  return((year %% 4 == 0 & year %% 100 != 0) | (year %% 400 == 0))
}

# Function to get the number of days in each month, given a year
get_days_in_month <- function(year) {
  if (is_leap_year(year)) {
    return(c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))  # Leap year
  } else {
    return(c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))  # Non-leap year
  }
}

# Function to get the first day of the year
get_first_day_of_year <- function(year) {
  return(as.POSIXlt(paste0(year, "-01-01"))$wday)  # Returns 0 for Sunday, 1 for Monday, ..., 6 for Saturday
}

# Function to create the daily profile for a given year
create_profile_for_year <- function(year, x_csm, y_csw) {
  # Get the number of days in each month for the specified year
  nmj <- get_days_in_month(year)
  
  # Get the first day of the year (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
  first_day_of_year <- get_first_day_of_year(year)
  
  # Normalize the monthly weights
  x_csm_norm <- x_csm / sum(x_csm)
  
  # Normalize the weekly weights
  y_csw_norm <- y_csw / sum(y_csw)
  
  # Create a vector to store the daily profile
  daily_profile <- c()
  
  # Variable to track the current day of the week
  current_weekday <- first_day_of_year + 1  # +1 to shift from [0,6] to [1,7]
  
  # Loop through each month
  for (m in 1:12) {
    days_in_month <- nmj[m]
    week_factor <- 7 / days_in_month
    
    for (d in 1:days_in_month) {
      # Apply the formula, considering the day of the week
      daily_profile_d <- x_csm_norm[m] * week_factor * y_csw_norm[current_weekday]
      
      # Append to the daily profile vector
      daily_profile <- c(daily_profile, daily_profile_d)
      
      # Update the weekday (1 = Monday, 7 = Sunday)
      current_weekday <- (current_weekday %% 7) + 1
    }
  }
  
  return(daily_profile)
}

# Function to create the multidimensional profile matrix for all GNFR sectors
create_multidimensional_profile <- function(year, nh3_monthly, nh3_weekly) {
  # Get the list of all GNFR sectors in the data
  GNFR_sectors <- unique(nh3_monthly$GNFR)
  
  # Number of days in the year
  days_in_year <- ifelse(is_leap_year(year), 366, 365)
  
  # Create an empty matrix where each row is a day and each column is a GNFR sector
  profile_matrix <- matrix(NA, nrow = days_in_year, ncol = length(GNFR_sectors))
  colnames(profile_matrix) <- GNFR_sectors  # Assign column names
  
  # Loop through each GNFR sector
  for (i in 1:length(GNFR_sectors)) {
    sector <- GNFR_sectors[i]
    
    # Extract monthly and weekly weights for the current sector
    x_csm <- nh3_monthly[nh3_monthly$GNFR == sector, c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")]
    x_csm <- as.numeric(x_csm)
    
    y_csw <- nh3_weekly[nh3_weekly$GNFR == sector, c("Mo", "Tu", "We", "Th", "Fr", "Sa", "Su")]
    y_csw <- as.numeric(y_csw)
    
    # Create the daily profile for the year and the current sector
    daily_profile <- create_profile_for_year(year, x_csm, y_csw)
    
    # Insert the profile into the matrix
    profile_matrix[, i] <- daily_profile
  }
  
  return(profile_matrix)
}

# Example usage with year 2000
year <- 2000

# Create the multidimensional profile matrix for the year 2000
profile_matrix_2000 <- create_multidimensional_profile(year, nh3_monthly, nh3_weekly)

# Print the first 10 rows of the matrix (first 10 days)
print(profile_matrix_2000[1:10, ])

# Save the profile matrix to an .rds file in the folder Data/Processed
saveRDS(profile_matrix_2000, file = "Data/Processed/profile_matrix_2000.rds")

# To load the matrix in the future, use:
# loaded_matrix <- readRDS("Data/Processed/profile_matrix_2000.rds")

