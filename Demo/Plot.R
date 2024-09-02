# Carica le librerie necessarie
library(reshape2)
library(ggplot2)
library(scales)

# Definisci il percorso della cartella dove salvare le immagini
output_directory <- "NH3_Emissions_Images_Timelapse_2000"
if (!dir.exists(output_directory)) {
  dir.create(output_directory)
}

# Carica lon_lat_idx
lon_lat_idx <- readRDS("Demo/Data/Processed/ANT_data/lon_lat_idx.rds")

# Data di inizio (Lunedì 3 gennaio 2000)
start_date <- as.Date("2000-01-03")

# Loop per plottare e salvare un'immagine ogni 7 giorni, a partire dal giorno 3
for (selected_day in seq(3, 365, by = 7)) {
  
  # Calcola la data corrispondente
  current_date <- start_date + (selected_day - 3)
  
  # Estrai i dati per il giorno selezionato da ComputedData
  mapdata <- ComputedData[,,selected_day]
  
  # Converti i valori in milligrammi/m^2 * day
  mapdata <- mapdata * 10^6 * 60 * 60 * 24
  
  # Crea un data frame per il plot
  df <- expand.grid(x = lon_lat_idx$lon[lon_lat_idx$lon_idx], y = lon_lat_idx$lat[lon_lat_idx$lat_idx])
  df$value <- as.vector(mapdata)
  
  names(df) <- c("lon", "lat", "value")
  
  # Definisci una palette di colori estesa
  extended_colors <- c("darkblue", "blue", "cyan", "green", "yellow", "orange", "red", "darkred", "purple")
  
  # Creazione del grafico
  p <- ggplot(df, aes(x = lon, y = lat, fill = value)) +
    geom_tile(color = "black", size = 0.001) +  # Bordi neri estremamente sottili
    scale_fill_gradientn(
      colors = extended_colors,  # Utilizza la palette di colori estesa
      values = rescale(c(0, 0.1, 0.2, 0.35, 0.5, 0.65, 0.8, 0.9, 1)),  # Scala più graduata per i colori
      name = "Emissions (mg/m² * Day)",
      trans = "log10"
    ) +
    coord_fixed(1.3) +
    theme_minimal() +
    theme(legend.position = "bottom") +
    labs(
      title = paste("NH3 Emissions in Italy - Day", selected_day, "-", format(current_date, "%A %d %B %Y")),
      x = "Longitudine",
      y = "Latitudine"
    )
  
  # Salva l'immagine ad alta risoluzione
  ggsave(filename = paste0(output_directory, "/NH3_Emissions_Italy_Day_", selected_day, "_HighRes.png"),
         plot = p, dpi = 300, width = 10, height = 8)
}



#istogramma delle emissioni per un giorno 

# Supponiamo di voler visualizzare la distribuzione delle emissioni per il giorno 15
selected_day <- 15
mapdata <- ComputedData[,,selected_day] * 10^6 * 60 * 60 * 24  # Conversione in mg/m^2 * day

# Creazione del data frame
df <- data.frame(value = as.vector(mapdata))

# Istogramma
ggplot(df, aes(x = value)) +
  geom_histogram(bins = 30, fill = "blue", color = "black", alpha = 0.7) +
  scale_x_log10() +  # Scala logaritmica per gestire la distribuzione
  labs(
    title = paste("Distribuzione delle Emissioni di NH3 - Giorno", selected_day),
    x = "Emissions (mg/m² * Day)",
    y = "Frequency"
  ) +
  theme_minimal()

#Boxplot delle emissioni su diversi giorni 

# Seleziona un insieme di giorni da confrontare (es. ogni mese)
selected_days <- seq(15, 365, by = 30)

# Prepara i dati per il boxplot
df <- data.frame(
  day = rep(selected_days, each = nrow(ComputedData) * ncol(ComputedData)),
  value = unlist(lapply(selected_days, function(day) {
    as.vector(ComputedData[,,day] * 10^6 * 60 * 60 * 24)
  }))
)

# Boxplot
ggplot(df, aes(x = factor(day), y = value)) +
  geom_boxplot(fill = "lightblue", color = "black") +
  scale_y_log10() +  # Scala logaritmica per gestire i valori estremi
  labs(
    title = "Distribuzione delle Emissioni di NH3 su Diversi Giorni",
    x = "Giorno",
    y = "Emissions (mg/m² * Day)"
  ) +
  theme_minimal()


#Trend temporale di una cella specifica


# Supponiamo di voler analizzare il trend in un punto specifico (es. lon_idx = 50, lat_idx = 100)
lon_idx <- 31
lat_idx <- 209
emissions_trend <- ComputedData[lon_idx, lat_idx, ] * 10^6 * 60 * 60 * 24

# Creazione del data frame
df <- data.frame(day = 1:366, emissions = emissions_trend)

# Plot del trend temporale
ggplot(df, aes(x = day, y = emissions)) +
  geom_line(color = "blue") +
  labs(
    title = paste("Trend delle Emissioni di NH3 nel Tempo per Bergamo (", lon_idx, ",", lat_idx, ")", sep = ""),
    x = "Giorno",
    y = "Emissions (mg/m² * Day)"
  ) +
  theme_minimal()

#save
ggsave(filename = "NH3_C_Emissions_Trend_Bergamo.png", plot = last_plot(), dpi = 300, width = 10, height = 6)

#Trend aggregato delle emissioni su una regione

# Supponiamo di voler aggregare le emissioni su una regione
aggregated_trend <- apply(ComputedData, 3, function(x) {
  sum(x * 10^6 * 60 * 60 * 24, na.rm = TRUE)
})

# Creazione del data frame
df <- data.frame(day = 1:366, total_emissions = aggregated_trend)

# Plot del trend aggregato
ggplot(df, aes(x = day, y = total_emissions)) +
  geom_line(color = "darkred") +
  labs(
    title = "Trend Aggregato delle Emissioni di NH3 nel Tempo",
    x = "Giorno",
    y = "Total Emissions (mg/m² * Day)"
  ) +
  theme_minimal()
