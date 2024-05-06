source("C:/Users/aminb/Desktop/TesiBorqal/Code/Demo/Utils.R")
source("C:/Users/aminb/Desktop/TesiBorqal/Code/Demo/Config.R")


#Extract selected temporal profile 
extract_and_store_profiles_in_list <- function(nc_file_path, profile_name) {
    nc <- open_nc_file(nc_file_path)

    #get lon,lat from nc
    lon <- ncvar_get(nc, "longitude")
    lat <- ncvar_get(nc, "latitude")

    #bounding box index
    lon_idx <- which(lon >= boundary[1] & lon <= boundary[2])
    lat_idx <- which(lat >= boundary[3] & lat <= boundary[4])

    
    profile_info <- list(
        FW_F = list(var_name = "FW_F", temporal_dim = "weekly"),
        FW_H = list(var_name = "FW_H", temporal_dim = "weekly"),
        FD_C = list(var_name = "FD_C", temporal_dim = "daily"),
        FD_K_nh3_nox = list(var_name = "FD_K_nh3_nox", temporal_dim = "daily"),
        FD_L_nh3 = list(var_name = "FD_L_nh3", temporal_dim = "daily"),
        FW_A_ch4 = list(var_name = "FW_A_ch4", temporal_dim = "weekly"),
        FW_A_co = list(var_name = "FW_A_co", temporal_dim = "weekly"),
        FW_A_co2 = list(var_name = "FW_A_co2", temporal_dim = "weekly"),
        FW_A_nmvoc = list(var_name = "FW_A_nmvoc", temporal_dim = "weekly"),
        FW_A_nox = list(var_name = "FW_A_nox", temporal_dim = "weekly"),
        FW_A_pm25 = list(var_name = "FW_A_pm25", temporal_dim = "weekly"),
        FW_A_pm10 = list(var_name = "FW_A_pm10", temporal_dim = "weekly"),
        FW_A_sox = list(var_name = "FW_A_sox", temporal_dim = "weekly"),
        FM_L_nh3 = list(var_name = "FM_L_nh3", temporal_dim = "monthly"),
        FM_L2 = list(var_name = "FM_L2", temporal_dim = "monthly"),
        FM_C = list(var_name = "FM_C", temporal_dim = "monthly"),
        FM_K_nh3_nox = list(var_name = "FM_K_nh3_nox", temporal_dim = "monthly"),
        FM_F1_nmvoc = list(var_name = "FM_F1_nmvoc", temporal_dim = "monthly"),
        FM_F1_co = list(var_name = "FM_F1_co", temporal_dim = "monthly"),
        FM_B = list(var_name = "FM_B", temporal_dim = "monthly"),
        FM_F = list(var_name = "FM_F", temporal_dim = "monthly"),
        FM_A_ch4 = list(var_name = "FM_A_ch4", temporal_dim = "monthly"),
        FM_G_ch4 = list(var_name = "FM_G_ch4", temporal_dim = "monthly"),
        FM_A_co = list(var_name = "FM_A_co", temporal_dim = "monthly"),
        FM_G_co = list(var_name = "FM_G_co", temporal_dim = "monthly"),
        FM_A_co2 = list(var_name = "FM_A_co2", temporal_dim = "monthly"),
        FM_G_co2 = list(var_name = "FM_G_co2", temporal_dim = "monthly"),
        FM_A_nmvoc = list(var_name = "FM_A_nmvoc", temporal_dim = "monthly"),
        FM_G_nmvoc = list(var_name = "FM_G_nmvoc", temporal_dim = "monthly"),
        FM_A_nox = list(var_name = "FM_A_nox", temporal_dim = "monthly"),
        FM_G_nox = list(var_name = "FM_G_nox", temporal_dim = "monthly"),
        FM_A_pm25 = list(var_name = "FM_A_pm25", temporal_dim = "monthly"),
        FM_G_pm25 = list(var_name = "FM_G_pm25", temporal_dim = "monthly"),
        FM_A_pm10 = list(var_name = "FM_A_pm10", temporal_dim = "monthly"),
        FM_G_pm10 = list(var_name = "FM_G_pm10", temporal_dim = "monthly"),
        FM_A_sox = list(var_name = "FM_A_sox", temporal_dim = "monthly"),
        FM_G_sox = list(var_name = "FM_G_sox", temporal_dim = "monthly")
    )

    if (!(profile_name %in% names(profile_info))) {
        stop("Invalid profile name")
    }

    num_periods <- if (profile_info[[profile_name]]$temporal_dim == "daily") {
        nc$dim$time$len
    } else if (profile_info[[profile_name]]$temporal_dim == "monthly") {
        nc$dim$month$len 
    } else {
        nc$dim$weekday_index$len
    }

    list_of_dfs <- vector("list", num_periods)

    for (period_index in 1:num_periods) {
        if (profile_info[[profile_name]]$temporal_dim == "daily") {
            start_idx <- c(min(lon_idx), min(lat_idx), period_index)
            count_idx <- c(length(lon_idx), length(lat_idx), 1)
        } else if (profile_info[[profile_name]]$temporal_dim == "monthly") {
            start_idx <- c(min(lon_idx), min(lat_idx), period_index)
            count_idx <- c(length(lon_idx), length(lat_idx), 1)
        } else {
            start_idx <- c(min(lon_idx), min(lat_idx), period_index)
            count_idx <- c(length(lon_idx), length(lat_idx), 1)
        }

        profile_data <- ncvar_get(nc, profile_info[[profile_name]]$var_name, start = start_idx, count = count_idx)

        #Dataframe with 3 variables
        df <- expand.grid(x = lon[lon_idx], y = lat[lat_idx])
        df$value <- as.vector(profile_data)

        #add dataframe to list
        list_of_dfs[[period_index]] <- df
    }

    nc_close(nc)

    return(list_of_dfs)
}
