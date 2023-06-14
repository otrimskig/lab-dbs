library(tidyverse)
library(janitor)
library(fs)

not_all_na <- function(x) any(!is.na(x))





readRDS("all_recent_necs.rds")->necs1  

necs1%>%
  mutate(index = as.character(row_number()))%>%
  mutate_all(na_if, "NA_value")%>%
  relocate(index)%>%
  select(where(not_all_na))->necs2
  

necs2%>%
  
  select(index, contains("disposition"))%>%
  unite("dispo", 2:last_col(), sep = "; ",na.rm=TRUE)%>%
  mutate_all(function(x){gsub("^$", NA, x)})->dispo


necs2%>%
  select(!contains("disposition"))%>%
  left_join(dispo)->necs3
  




############################
necs3%>%
  
  select(index, contains("date"))->nec_dates_messy
  

nec_dates_messy%>%

  mutate(across(-1, function(x){
    
    x=(if_else(grepl("^44[0-9]{3}", x), substr(x, 1,5), NA_character_))%>%
    as.numeric()%>%
    as.Date(origin = "1899-12-30")
    
    }))%>%
  
  mutate(date_of_first_treatment = if_else(is.na(date_of_first_treatment), 
                                           
                                           #yes
                                           date_of_first_treatrment, 
                                           #no
                                           as.Date(date_of_first_treatment)))%>%
  select(-date_of_first_treatrment)%>%
  
  rename(nec_date = todays_date)->nec_dates_clean



nec_dates_messy%>%
  view()
  
  
  


# 
# function(x){x=if_else(grepl("^[0-9]{5}$", x), 
#                       x, 
#                       NA_character_)%>%
#   as.numeric%>%
#   as.Date(x, origin = "1899-12-30")}))%>%
#   
#   


is.na(nec_dates_messy$date_of_first_treatment)
#   l("^44[0-9]{3}$", x)