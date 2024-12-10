# Carichiamo le librerie necessarie
library(ggplot2)
library(dplyr)

# Definiamo i nomi dei settori
sector_names <- c(
  "A Public Power and Heat Production",
  "B Industrial Combustion",
  "C Other Stationary Combustion",
  "D Fugitive Emissions",
  "E Solvent and Product Use",
  "F Road Transport",
  "G Shipping",
  "H Aviation",
  "I Offroad Transport",
  "J Waste Treatment and Disposal",
  "K Agriculture",
  "L Other Agricultural Sources",
  "Sum"
)

# Funzione per estrarre i dati aggregati per tutti gli anni e settori
extract_data <- function(data) {
  data_list <- list()
  
  for (sector_index in 1:13) {
    # Estraiamo i dati per il settore corrente su tutti gli anni
    sector_data <- sapply(1:22, function(year_index) {
      sum(data[,,sector_index,year_index])
    })
    
    # Creiamo un dataframe per il settore
    df <- data.frame(
      Year = 2000:2021,  # Anni da 2000 a 2021
      Value = sector_data,
      Sector = sector_names[sector_index]
    )
    
    # Aggiungiamo il dataframe alla lista
    data_list[[sector_names[sector_index]]] <- df
  }
  
  # Combiniamo tutti i dataframe in uno solo
  combined_data <- bind_rows(data_list)
  return(combined_data)
}

# Estrazione dei dati aggregati
all_data <- extract_data(REG_ANT_yearly_data_nh3)

# Troviamo il range massimo e minimo per uniformare i grafici
y_range <- range(all_data$Value)

# Funzione per creare grafici di confronto dei settori per ogni anno
plot_yearly_sector_comparison <- function(data, original_data) {
  pdf("Confronto_Settori_Anni_Professionale.pdf")
  
  for (year_index in 1:22) {
    # Aggrega i dati spaziali per ciascun settore per l'anno corrente
    aggregated_data <- apply(original_data[,,,year_index], 3, sum)  # Somma per settore
    
    # Crea un dataframe per ggplot2 con i nomi ordinati dei settori
    df <- data.frame(sector = factor(sector_names, levels = sector_names), 
                     values = as.numeric(aggregated_data))
    
    # Crea un grafico per l'anno corrente
    year_label <- 2000 + year_index - 1  # Calcola l'anno corretto (es. 2000 + index - 1)
    p <- ggplot(df, aes(x = sector, y = values, fill = sector)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(values = c(rep("steelblue", 12), "red")) +  # Colora "Sum" in rosso
      coord_cartesian(ylim = y_range) +  # Imposta il range uniforme per l'asse y
      theme_minimal() +
      labs(
        title = paste("Confronto dei Settori per Anno", year_label),
        x = "Settore",
        y = expression(paste("Valore Aggregato (Kg/m"^2, " * sec)"))
      ) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1, size = 10),  # Migliora la leggibilità dell'asse x
        plot.title = element_text(size = 14, face = "bold"),  # Titolo più evidente
        legend.position = "none"  # Rimuove la legenda se non necessaria
      )
    
    # Stampa il grafico nel PDF
    print(p)
  }
  
  dev.off()
  cat("Il file PDF con il confronto dei settori è stato salvato come 'Confronto_Settori_Anni_Professionale.pdf'\n")
}

# Funzione per creare grafici di serie temporali per ogni settore
plot_time_series <- function(data) {
  # Controlla se i dati contengono le colonne necessarie
  if (!all(c("Sector", "Year", "Value") %in% names(data))) {
    stop("Il dataframe 'data' deve contenere le colonne 'Sector', 'Year', e 'Value'.")
  }
  
  # Separare "Sum" dal resto dei settori
  data_no_sum <- data %>% filter(Sector != "Sum")
  data_sum <- data %>% filter(Sector == "Sum")
  
  # Crea un file PDF per salvare i grafici
  pdf("Serie_Temporali_Settori.pdf", width = 14, height = 8)
  
  # Crea il grafico per i settori senza "Sum"
  p1 <- ggplot(data_no_sum, aes(x = Year, y = Value, color = Sector, group = Sector)) +
    geom_line(size = 1) +
    geom_point(size = 2) +
    facet_wrap(~ Sector, scales = "free_y", ncol = 3) +  # Usa scale libere per y per ciascun settore
    theme_minimal() +
    labs(
      title = "Time Series of Emissions by Sector (Excluding Sum)",
      x = "Year",
      y = expression(paste("Aggregated Value (Kg/m"^2, " * sec)"))
    ) +
    theme(
      plot.title = element_text(size = 16, face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
      legend.position = "none"
    )
  
  # Stampa il grafico dei settori senza "Sum"
  print(p1)
  
  # Crea un grafico separato per "Sum"
  p2 <- ggplot(data_sum, aes(x = Year, y = Value, color = Sector, group = Sector)) +
    geom_line(size = 1) +
    geom_point(size = 2) +
    theme_minimal() +
    labs(
      title = "Time Series of Emissions for Sum Sector",
      x = "Year",
      y = expression(paste("Aggregated Value (Kg/m"^2, " * sec)"))
    ) +
    theme(
      plot.title = element_text(size = 16, face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
      legend.position = "none"
    )
  
  # Stampa il grafico del settore "Sum"
  print(p2)
  
  # Chiudi il file PDF
  dev.off()
  
  cat("The PDF file with time series has been saved as 'Serie_Temporali_Settori.pdf'\n")
}


# Funzione per creare grafici a barre per ogni anno per ciascun settore
plot_sector_histograms <- function(data) {
  pdf("Istogrammi_Anni_Per_Settore.pdf")
  
  for (sector in sector_names) {
    df <- data %>% filter(Sector == sector)
    p <- ggplot(df, aes(x = factor(Year), y = Value, fill = factor(Year))) +
      geom_bar(stat = "identity", show.legend = FALSE) +
      theme_minimal() +
      coord_cartesian(ylim = y_range) + # Imposta il range uniforme per l'asse y
      labs(
        title = paste("Emissioni per Settore:", sector),
        x = "Anno",
        y = expression(paste("Valore Aggregato (Kg/m"^2, " * sec)"))
      ) +
      theme(
        plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
    print(p)
  }
  
  dev.off()
  cat("Il file PDF con gli istogrammi è stato salvato come 'Istogrammi_Anni_Per_Settore.pdf'\n")
}

# Esecuzione delle funzioni per generare i grafici
plot_yearly_sector_comparison(all_data, REG_ANT_yearly_data) # Grafico di confronto dei settori per ogni anno
plot_time_series(all_data)                                  # Serie temporali per ogni settore
plot_sector_histograms(all_data)                            # Istogrammi degli anni per ciascun settore



> sommaSettori2016<-(D_A_2016+D_B_2016+D_C_2016+D_D_2016+D_E_2016+D_G_2016+D_H_2016+D_I_2016+D_J_2016+D_K_2016+D_L_2016)