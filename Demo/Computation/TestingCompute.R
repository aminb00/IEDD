calculate_daily_matrices <- function(PollutantName, profile,
                                     yearly_data_file, temporal_profile_folder,
                                     output_folder) 
{
  #Load yearly data
  yearly_data_all <- readRDS(yearly_data_file)
  
  #search and put in list all files with initial pattern equal to profile
  
  TempoFiles <- list.files(temporal_profile_folder, pattern = profile)
  
  #get the yearly_data for the sector wanted
  sector_letter <- sub("^FD_([A-Z]).*", "\\1",profile)
  yearly_data <- yearly_data_all[,,sector_letter,]
  
  # Estrarre il numero di anni dalla dimensione della matrice annuale
  num_years <- dim(yearly_data)[3]
  
  # L'anno di partenza è il 2000
  start_year <- 2000
  
  for (year in start_year:(start_year+num_years)) {
  
    # Cerca i file che iniziano con FD_, settore, anno e ignora tutto ciò che segue l'anno
    matching_file <- Sys.glob(file.path(temporal_profile_folder, paste0("FD_",sector_letter,"_",year, "*")))
    
    profile_data <- readRDS(matching_file)
    
    num_days<-dim(profile_data)[3]
    
    daily_data<-array(NA,c(dim(yearly_data)[1],dim(yearly_data)[2],num_days),list(dimnames(yearly_data)[[1]], dimnames(yearly_data)[[2]], 1:num_days))
    
    for(d in 1:num_days){
      
      y<-year-start_year+1
      day_data<-yearly_data[,,y]*profile_data[,,d]
      
      daily_data[,,d]<-day_data
    }
    
    daily_data_file <- file.path(output_folder, paste0("Daily_", sector_letter, "_", year,"_",PollutantName,".rds"))
    saveRDS(daily_data, daily_data_file)
    #delete from memory
    rm(daily_data)
    
    
  }
  

}
    