# Carica il pacchetto sf per lavorare con shapefile
library(sf)
library(ggplot2)
library(reshape2)
library(scales)

# Carica lo shapefile dei comuni
comuni <- st_read("Demo\\Data\\Raw\\MAPS\\ITA-Administrative-maps-2024\\Com01012024_g\\Com01012024_g_WGS84.shp")

# Visualizza una sintesi dei dati
summary(comuni)

head(comuni)



# Plot di base dei confini comunali
ggplot(data = comuni) +
  geom_sf() +
  labs(title = "Italy divided by municipalities", x = "Longitude", y = "Latitude")


# Plotta la mappa dei comuni colorata per area
library(ggplot2)

# Plotta la mappa dei comuni con scala colori logaritmica per l'area
library(ggplot2)
library(scales)  # Per la funzione log_breaks()

# Plotta la mappa dei comuni senza legenda
library(ggplot2)
library(scales)  # For log_breaks()

# Plot the municipalities map without a legend
ggplot(data = comuni) +
  geom_sf(aes(fill = Shape_Area)) +  # Use Shape_Area for the color
  scale_fill_viridis_c(trans = "log", breaks = log_breaks(n = 20)) +  # Logarithmic scale
  labs(title = "Italian Municipalities by Area", 
       x = "Longitude", y = "Latitude") +
  theme_minimal() +
  theme(legend.position = "none")  # Remove the legend


# Filtra per la regione Lombardia
lombardia <- comuni %>%
  filter(COD_REG ==3)

# Plot dei comuni della Lombardia
ggplot(data = lombardia) +
  geom_sf() +
  labs(title = "Map of Municipalities in Lombardy", x = "Longitude", y = "Latitude") +
  theme_minimal()

# Crea un oggetto sf per le emissioni
emissioni_sf <- st_as_sf(emissioni_df, coords = c("lon", "lat"), crs = 4326)

emissioni_matrix<-REG_ANT_yearly_data_nh3[,,13,17]*10^6*60*60*24
# Estrai i nomi di riga e colonna (coordinate lat/lon)
longitudes <- as.numeric(rownames(emissioni_matrix))
latitudes <- as.numeric(colnames(emissioni_matrix))

# Crea un dataframe con le emissioni e le coordinate
emissioni_df <- expand.grid(lat = latitudes, lon = longitudes)
emissioni_df$emissioni <- as.vector(emissioni_matrix)

# Crea un oggetto sf dalle coordinate
emissioni_sf <- st_as_sf(emissioni_df, coords = c("lon", "lat"), crs = 4326)
st_intersect[length(st_intersect(emissioni_sf, comuni))>0]

# Trasforma emissioni_sf al CRS dei comuni (EPSG:32632)
emissioni_sf <- st_transform(emissioni_sf, crs = st_crs(comuni))

# Ora puoi fare il spatial join
# Usa st_join con un'opzione di tolleranza
emissioni_comuni <- st_join(emissioni_sf, comuni, join = st_intersects)

library(ggplot2)
library(scales)

# Assumiamo che 'emissioni_comuni' contenga le emissioni per ciascun comune
# con una colonna "emissioni_totali" che vuoi rappresentare con la scala logaritmica.



ggplot(data = emissioni_comuni) +
  geom_sf(aes(fill = emissioni_totali)) +  # Usa emissioni_totali per il colore
  scale_fill_viridis_c(trans = "log", breaks = log_breaks(n = 20)) +  # Scala logaritmica con molti dettagli
  labs(title = "Map of Emissions by Municipality (Logarithmic Scale)", 
       x = "Longitude", y = "Latitude", fill = "Emissions (log scale)") +
  theme_minimal() +
  theme(legend.position = "right")  # Posiziona la legenda sulla destra


nc<-nc_open("Demo/Data/Raw/CAMS-REG-TEMPO/CAMS-REG-TEMPO_EUR_0.1x0.1_tmp_weights_v3.1_monthly.nc")

