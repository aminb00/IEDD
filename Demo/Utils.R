library(ncdf4)

#Open NetCDF file
open_nc_file <- function(file_path) {
    nc <- nc_open(file_path)
    return(nc)
}
