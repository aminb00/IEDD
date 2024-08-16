
#CAMS-REG-ANT

source("Code\\Demo\\ANT\\Analysis.R")
all_years_data <- list()

nc_file_paths <- c(
    "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-REG-ANT\\CAMS-REG-ANT_EUR_0.05x0.1_anthro_nh3_v5.1_yearly.nc",
    "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-REG-ANT\\NH3\\CAMS-REG-ANT_EUR_0.05x0.1_anthro_nh3_v6.1_yearly.nc",
    "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-REG-ANT\\NH3\\CAMS-REG-ANT_EUR_0.05x0.1_anthro_nh3_v7.0_yearly.nc"
)

for (nc_file_path in nc_file_paths) {
    all_years_data <- add_new_years_data(nc_file_path, all_years_data)
}

#CAMS-REG-TEMPO

source("C:/Users/aminb/Desktop/TesiBorqal/Code/Demo/TEMPO-Profiles/ProfilesExtraction.R")

nc_file_path <- "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-TEMPO\\CAMS-REG-TEMPO_EUR_0.1x0.1_tmp_weights_v3.1_daily.nc"
FD_C <- extract_and_store_profiles_in_list(nc_file_path, "FD_C")

nc_file_path <- "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-TEMPO\\CAMS-REG-TEMPO_EUR_0.1x0.1_tmp_weights_v3.1_monthly.nc"
FM_B <- extract_and_store_profiles_in_list(nc_file_path, "FM_B")

df <- FD_C[[120]]  # Accesso al 120° giorno





COMMIT PROVA

