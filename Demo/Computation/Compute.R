#moltiplicheremo i dati annuali con i profili temporali per ottenere i dati giornalieri

# Funzione per estrarre e salvare i profili temporali in file separati per anno

profile<-readRDS(file.path("Demo\\Data", "FD_C_2020.rds"))
yearData<-readRDS(file.path("Demo\\Data\\Processed\\ANT_data", "all_data_matrix.rds"))

yearData[,,3,21]
profile
From_Daily_to_Daily<- function(yearData,profile,profile_name){
  
  daily_data<-yearData[,,3,21]*profile[,,1]
  
  saveRDS(daily_data, file = file.path("Demo\\Data\\", paste0("Daily", 2020, ".rds")))
  
  
}