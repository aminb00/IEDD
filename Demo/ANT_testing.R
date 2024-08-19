

FD_C_matrix<-NULL
day<-1
indexFromYear<-1
leap_year<-FALSE

for(y in 1:21)
{
  if(y%%4==0 || y==1)
  {  
    for(day in 1:366){  
    leap_year<-TRUE
    FD_C_matrix<-abind(FD_C_matrix,dcast(FD_C[[day+indexFromYear]], x ~ y, value.var = "value"),along=3)
    
            }
  }
  else
  {
    for(day in 1:365){  
      leap_year<-FALSE
      FD_C_matrix<-abind(FD_C_matrix,dcast(FD_C[[day+indexFromYear]], x ~ y, value.var = "value"),along=3)
      
    }
  }
  if(leap_year)
  { indexFromYear<-indexFromYear+366 }
  else
  { indexFromYear<-indexFromYear+365 }
  
  #salviamo in file rds rinominato con anni a partire da 2000
  saveRDS(FD_C_matrix, file = paste0("C:\\Users\\aminb\\Desktop\\IEDD\\Demo\\Data\\FD_C-",1999+y,".rds"))
  rm(FD_C_matrix)
  gm()
}


