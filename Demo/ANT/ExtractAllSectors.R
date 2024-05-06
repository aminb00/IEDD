source("C:/Users/aminb/Desktop/TesiBorqal/Code/Demo/Utils.R")
source("C:/Users/aminb/Desktop/TesiBorqal/Code/Demo/Config.R")

extractAllSectors <- function(nc_file_path) {
    nc <- open_nc_file(nc_file_path)

    lon <- ncvar_get(nc, "lon")
    lat <- ncvar_get(nc, "lat")

    lon_idx <- which(lon >= boundary[1] & lon <= boundary[2])
    lat_idx <- which(lat >= boundary[3] & lat <= boundary[4])

    sector_names <- list(
        A = "A_PublicPower",
        B = "B_Industry",
        C = "C_OtherStationaryComb",
        D = "D_Fugitives",
        E = "E_Solvents",
        F = "F_RoadTransport",
        G = "G_Shipping",
        H = "H_Aviation",
        I = "I_OffRoad",
        J = "J_Waste",
        K = "K_AgriLivestock",
        L = "L_AgriOther",
        S = "SumAllSectors"
    )

    sector_data <- list()
    for (key in names(sector_names)) {
        data <- ncvar_get(nc, sector_names[[key]], start = c(min(lon_idx), min(lat_idx), 1), count = c(length(lon_idx), length(lat_idx), nc$dim$time$len))
        sector_data[[key]] <- data
    }

    nc_close(nc)

    return(list(sector_data = sector_data, lon = lon[lon_idx], lat = lat[lat_idx]))
}
