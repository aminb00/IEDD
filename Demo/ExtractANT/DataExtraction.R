library(ncdf4)
library(reshape2)
library(abind)

# Source the utility and configuration files
source("Demo/Utils.R")
source("Demo/Config.R")


# Function to extract data from all sectors in a NetCDF file
extractAllSectors <- function(nc_file_path) {
  # Load the lon, lat, lon_idx, lat_idx from RDS if available
  lon_lat_data <- readRDS("Demo/Data/Processed/lon_lat_idx.rds")
  
  # Open the NetCDF file
  nc <- open_nc_file(nc_file_path)
  
  # Extract relevant lon and lat indices
  lon_idx <- lon_lat_data$lon_idx
  lat_idx <- lon_lat_data$lat_idx
  
  # List of sector names corresponding to the variables in the NetCDF file
  
  
  # Initialize list to store data for each sector
  sector_data <- list()
  for (key in names(sector_names)) {
    # Extract data for each sector within the defined boundaries
    data <- ncvar_get(nc, sector_names[[key]], start = c(min(lon_idx), min(lat_idx), 1), 
                      count = c(length(lon_idx), length(lat_idx), nc$dim$time$len))
    sector_data[[key]] <- data
  }
  
  # Close the NetCDF file
  nc_close(nc)
  
  # Return the extracted data along with the selected longitude and latitude
  return(list(sector_data = sector_data, lon = lon_lat_data$lon[lon_idx], lat = lon_lat_data$lat[lat_idx]))
}

# Function to extract data for a specific sector and year
year_sector <- function(data, sector, year, num_years) {
  if (num_years == 1) {
    # If there's only one year, select the entire sector data
    sector_data <- data$sector_data[[sector]][, ]
  } else {
    # Otherwise, select data corresponding to the specific year
    sector_data <- data$sector_data[[sector]][, , year]
  }
  
  # Convert the data into a data frame with longitude, latitude, and values
  df <- expand.grid(x = data$lon, y = data$lat)
  df$value <- as.vector(sector_data)
  return(df)
}

# Function to add data from new years to the list of all years
add_new_years_data <- function(nc_file_path, all_years_data) {
  # Extract sector data from the new NetCDF file
  new_data <- extractAllSectors(nc_file_path)
  
  if (length(all_years_data) > 0) {
    # Determine the starting year based on the last year in the existing data
    last_year_key <- names(all_years_data)[length(all_years_data)]
    last_year <- as.numeric(sub("Year ", "", last_year_key))
    start_year <- last_year + 1
  } else {
    # If no data exists, start from the year 2000
    start_year <- 2000
  }
  
  # Check if the temporal dimension exists; if not, assume only 1 year is present
  if (is.null(dim(new_data$sector_data[[names(new_data$sector_data)[1]]]))) {
    num_years <- 1  
  } else {
    num_years <- dim(new_data$sector_data[[names(new_data$sector_data)[1]]])[3]
    if (is.na(num_years)) num_years <- 1
  }
  
  # Loop through each year in the data and add it to the all_years_data list
  for (year_index in 1:num_years) {
    current_year <- start_year + year_index - 1
    year_data <- list()
    
    for (sector_key in names(new_data$sector_data)) {
      sector_data <- year_sector(new_data, sector_key, year_index, num_years)
      year_data[[sector_key]] <- sector_data
    }
    
    all_years_data[[paste("Year", current_year)]] <- year_data
  }
  
  return(all_years_data)
}

# Function to build the yearly 4D matrix from the list of all years
build_yearly_matrix <- function(all_data_list, lon_lat_idx) {
  all_data_matrix <- NULL
  
  for (year in 1:length(all_data_list)) {
    year_matrix <- NULL
    
    for (sector in all_data_list[[year]]) {
      # Reshape the sector data for each year, excluding x and y labels from the matrix
      dcast_matrix <- dcast(sector, x ~ y, value.var = "value")
      
      # Convert the dcast result to a matrix, removing the x column (row names)
      value_matrix <- as.matrix(dcast_matrix[,-1])
      
      # Combine the matrices along the 3rd dimension (for different sectors)
      year_matrix <- abind(year_matrix, value_matrix, along = 3)
    }
    
    # Combine all years into a single 4D matrix (adding the year dimension)
    all_data_matrix <- abind(all_data_matrix, year_matrix, along = 4)
  }
  
  # Round the coordinates to 2 decimal places
  lon_rounded <- round(lon_lat_idx$lon[lon_lat_idx$lon_idx], 2)
  lat_rounded <- round(lon_lat_idx$lat[lon_lat_idx$lat_idx], 2)
  
  # Assign dimension names to the all_data_matrix
  dimnames(all_data_matrix) <- list(
    x = lon_lat_idx$lon[lon_lat_idx$lon_idx],  # Rounded longitude coordinates
    y = lon_lat_idx$lat[lon_lat_idx$lat_idx],  # Rounded latitude coordinates
    sector = names(sector_names),  # Sectors (e.g., climate variables)
    year = names(all_data_list)  # Years (e.g., 2000, 2001, etc.)
  )
  
  return(all_data_matrix)
}


# Function to extract data from all sectors in a csv file
extractAllSectorsCSV <- function(csv_file_path,pollutant,countryISO3) {

  # Read the CSV file
  data <- read.csv(csv_file_path, header = TRUE)
  
  #dammi le righe dove la colonna POLL è uguale a NH3 e la colonna ISO3 è uguale a ITA
  
  data<-data[data$ISO3==countryISO3,]
  data<-data[data$POLL==pollutant,]
  
  return(data)
  
}

