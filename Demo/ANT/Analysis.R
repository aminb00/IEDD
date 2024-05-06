source("C:/Users/aminb/Desktop/TesiBorqal/Code/Demo/ANT/ExtractAllSectors.R")

year_sector <- function(data, sector, year, num_years) {
    if (num_years == 1) {
        sector_data <- data$sector_data[[sector]][, ]
    } else {
        sector_data <- data$sector_data[[sector]][, , year]
    }

    df <- expand.grid(x = data$lon, y = data$lat)
    df$value <- as.vector(sector_data)
    return(df)
}

add_new_years_data <- function(nc_file_path, all_years_data) {
  new_data <- extractAllSectors(nc_file_path)
  
  if (length(all_years_data) > 0) {
    last_year_key <- names(all_years_data)[length(all_years_data)]
    last_year <- as.numeric(sub("Year ", "", last_year_key))
    start_year <- last_year + 1
  } else {
    start_year <- 2000
  }
  
  #Checking if the temporal dimension exists, if not so there is just 1 year in the file
  if (is.null(dim(new_data$sector_data[[names(new_data$sector_data)[1]]]))) {
    num_years <- 1  
  } else {
    num_years <- dim(new_data$sector_data[[names(new_data$sector_data)[1]]])[3]
    if (is.na(num_years)) num_years <- 1
  }
  
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