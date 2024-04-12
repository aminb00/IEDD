# ncdf4 library
library(ncdf4)

nc_path <- "C:\\Users\\aminb\\Desktop\\TesiBorqal\\Data\\Raw\\CAMS-REG-TEMPO_EUR_0.1x0.1_tmp_weights_v3.1_daily_2016.nc"
nc <- nc_open(nc_path)

names(nc$var)

# Read the data
