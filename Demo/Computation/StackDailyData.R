# Load necessary library
library(abind)

# Function to stack daily data across years
StackDailyData <- function(input_folder, sector, pollutant, start_year, end_year) {
  # List to store daily matrices
  daily_data_list <- list()
  
  # Loop over the years
  for (year in start_year:end_year) {
    # Construct the file name
    daily_data_file <- file.path(input_folder, paste0("Daily_", sector, "_", year, "_", pollutant, ".rds"))
    
    # Check if the file exists; if not, look in SimplifiedDailyData/pollutant
    if (!file.exists(daily_data_file)) {
      simplified_data_file <- file.path(input_folder, "SimplifiedDailyData", pollutant, paste0("D_", sector, "_", year, ".rds"))
      
      # If the file doesn't exist in SimplifiedDailyData, throw an error
      if (!file.exists(simplified_data_file)) {
        stop(paste("File for year", year, "not found in DAILY_data or SimplifiedDailyData:", simplified_data_file))
      } else {
        daily_data_file <- simplified_data_file
      }
    }
    
    # Load the daily data for the year
    daily_data <- readRDS(daily_data_file)
    
    # Add the daily data to the list
    daily_data_list[[as.character(year)]] <- daily_data
  }
  
  # Combine all matrices along the time dimension (days)
  stacked_daily_data <- abind(daily_data_list, along = 3)
  
  # Create time labels in dd/mm/yyyy format
  total_days <- dim(stacked_daily_data)[3]
  start_date <- as.Date(paste0(start_year, "-01-01"))
  date_sequence <- seq.Date(from = start_date, by = "day", length.out = total_days)
  formatted_dates <- format(date_sequence, "%d%m%Y")
  
  # Load longitude and latitude indices
  lon_lat_idx <- readRDS("Demo/Data/Processed/lon_lat_idx.rds")
  # Use lon_idx and lat_idx to get coordinates and round to 2 decimals
  lon_rounded <- round(lon_lat_idx$lon[lon_lat_idx$lon_idx], 2)
  lat_rounded <- round(lon_lat_idx$lat[lon_lat_idx$lat_idx], 2)
  
  # Convert values to formatted strings to ensure two decimals
  lon_names <- sprintf("%.2f", lon_rounded)
  lat_names <- sprintf("%.2f", lat_rounded)
  
  # Set dimnames for the time dimension
  dimnames(stacked_daily_data) <- list(lon_names, lat_names, formatted_dates)
  
  # Save the stacked data as an RDS file
  saveRDS(stacked_daily_data, file.path(input_folder, paste0("DailyAlongYears/Daily_", sector, "_", start_year, "_", end_year, "_", pollutant, ".rds")))
}

# Function to sum all sectors into one
SumAllSectorsIntoOne <- function(input_folder, output_file, pollutant, start_year, end_year) {
  # List of sectors from "A" to "L"
  sectors <- LETTERS[1:12]
  
  # Variable to store the total sum
  total_sum <- NULL
  
  for (sector in sectors) {
    # Handle the special case where files may be named with "NO2" instead of "NOx"
    if (pollutant == "NOx") {
      file_name <- file.path(input_folder, paste0("Daily_", sector, "_", start_year, "_", end_year, "_NOx.rds"))
      if (!file.exists(file_name)) {
        file_name <- file.path(input_folder, paste0("Daily_", sector, "_", start_year, "_", end_year, "_NO2.rds"))
      }
    } else {
      file_name <- file.path(input_folder, paste0("Daily_", sector, "_", start_year, "_", end_year, "_", pollutant, ".rds"))
    }
    
    if (file.exists(file_name)) {
      cat("Processing data for sector:", sector, "\n")
      
      # Load the data for the current sector
      sector_data <- tryCatch(readRDS(file_name), error = function(e) {
        cat("Error for sector", sector, ":", e$message, "\n")
        return(NULL)
      })
      
      if (!is.null(sector_data)) {
        if (is.null(total_sum)) {
          # Initialize total_sum with the first sector's data
          total_sum <- sector_data
        } else {
          # Add the current sector's data to the total sum
          total_sum <- total_sum + sector_data
        }
        
        # Free memory
        rm(sector_data)
        gc()
      }
    } else {
      cat("File not found for sector:", sector, "-", file_name, "\n")
    }
  }
  
  # Save the combined matrix
  saveRDS(total_sum, output_file)
  
  cat("Sum of sectors completed:", output_file, "\n")
}

