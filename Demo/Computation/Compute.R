#moltiplicheremo i dati annuali con i profili temporali per ottenere i dati giornalieri

# Funzione per estrarre e salvare i profili temporali in file separati per anno

profile<-readRDS(file.path("Demo\\Data\\Processed\\TEMPO_data", "FD_C_2020.rds"))
yearData<-readRDS(file.path("Demo\\Data\\Processed\\ANT_data", "all_data_matrix.rds"))

ProfileMatrix<- FD_C_2000
YearData<- REG_ANT_yearly_data[,,3,1]
ComputedData<-NULL
  for(i in 366){
    
    ComputedData[,,i]<-YearData*ProfileMatrix[,,i]
    
  
  }

  dimnames(ComputedData)<-dimnames(REG_ANT_yearly_data[,,3,1])
  