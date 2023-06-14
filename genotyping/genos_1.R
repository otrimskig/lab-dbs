#start with pre-made RDS file previously assembled. 

#then only look at sample of actual genotyping file. 


library(tidyverse)
library(readxl)
library(janitor)

geno_file<-"X:/Holmen Lab/Genotyping/Genotyping Results HCI.xlsx"



read_excel(geno_file, range = "HCI!A21004:R21712", col_names = FALSE)%>%
  as_tibble()%>%
  clean_names()%>%
  mutate(index = 1:NROW(.))%>%
  relocate(index)->read_in



#vector of indexes in dataset where row data is info.

read_in%>%

  select(index, x5)%>%
  mutate(type = if_else(is.na(x5), "cage_heading", NA))%>%
  filter(type=="cage_heading")%>%
  pull(index)->heading_index



#successful for loop. 
for(i in 1:length(heading_index)){
  assign(paste0("cage", sprintf("%04d", i)),
         if (i==1){ read_in%>%
             filter(index < heading_index[(i+1)])
           
         } else if (i==(length(heading_index))){
           read_in%>%
             filter(index>=heading_index[(length(heading_index))])
           
         }else {
           read_in%>%
             filter(index <heading_index[i+2] & index>=(heading_index[(i+1)]))
         }
  )
}



df_list = Filter(function(x) nrow(x)>0, mget(ls(pattern = "cage[0-9]")))




######################


for (i in 1:length(df_list)){



df_list[[i]]%>%
  slice(1)%>%
  select(where(~!any(is.na(.))))%>%
  select(1, ncol(.))%>%
  
    
  mutate(injected = if_else(grepl("/", .[2]), .[[2]], NA))%>%
  select(injected)%>%
  pull()->injection




df_list[[i]]%<>%
  bind_rows(., slice(., 1))%>%
  row_to_names(1)%>%
  clean_names()%>%
  suppressWarnings()%>%
  rename(index = 1, 
         mouse_num =2, 
         cage =3, 
         sex = 4, 
         full_strain = 5, 
         dob = 6,
         ts = 7, 
         wean = 8,
         maternal = 9,
         paternal = 10)%>% 
  
  rename(mc_setup = last_col(), 
         dispo = last_col()-1, 
         death_date = last_col()-2)%>%
  
  mutate(strain = pull(., colnames(.)[2])[length(pull(., colnames(.)[2]))])%>%
  mutate(cage = pull(., colnames(.)[3])[length(pull(., colnames(.)[3]))])%>%
  
  slice(1:nrow(.)-1)%>%
  
  mutate(injection = injection)%>%

  select(where(~!any(is.na(.))))



}



genos_joined<-reduce(df_list, full_join)
