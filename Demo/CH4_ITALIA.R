library(ncdf4)
library(ggplot2)

# Open the NetCDF file
nc <- nc_open("C:/Users/aminb/Desktop/TesiBorqal/Data/Raw/CAMS-REG-ANT_EUR_0.05x0.1_anthro_ch4_v5.1_yearly.nc")

# Define the geographic boundaries of Italy
boundary <- c(6.62, 18.517, 35.49, 47.091)

# Extract the longitude and latitude coordinates from nc
lon <- ncvar_get(nc, "lon")
lat <- ncvar_get(nc, "lat")

# Calculate the indices for the bounding box around Italy
lon_idx <- which(lon >= boundary[1] & lon <= boundary[2])
lat_idx <- which(lat >= boundary[3] & lat <= boundary[4])

# Extract data for the defined region
data <- ncvar_get(nc, "SumAllSectors",
  start = c(min(lon_idx), min(lat_idx), 1),
  count = c(length(lon_idx), length(lat_idx), nc$dim$time$len)
)

# Create a data frame
df <- expand.grid(x = lon[lon_idx], y = lat[lat_idx])
df$value <- as.vector(data[, , 1]) # Assuming you're interested in data for a specific year (first time step)

# Plot the data using ggplot2
p <- ggplot(df, aes(x = x, y = y, fill = value)) +
  geom_tile() + # This creates a grid-based heatmap
  scale_fill_viridis_c(option = "C", name = "Emissioni (kg/m²)") + # Sets a color scale and labels the legend
  coord_fixed(1.3) + # This helps maintain the aspect ratio, adjust as necessary for your display
  theme_minimal() + # Uses a minimal theme for a cleaner look
  theme(legend.position = "bottom") + # Positions the legend at the bottom
  labs(
    title = "Emissioni di Metano in Italia nel 2020",
    subtitle = "Analisi distributiva regionale delle emissioni",
    x = "Longitudine",
    y = "Latitudine",
    caption = "Fonte: CAMS-REG-ANT EUR 0.05x0.1 anthro CH4 v5.1 yearly"
  ) # Adds a source caption

# Print the plot
print(p)
