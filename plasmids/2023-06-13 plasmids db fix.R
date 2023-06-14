
library(tidyverse)
library(readxl)
library(fs)
library(janitor)
library(writexl)
#use dir_ls instead of list.files.

#input path to plasmid db (repo of snapgene files). 
snapgene_db<-path("X:/Holmen Lab/Databases/Snapgene db/DNA Files/1-Holmen Plasmids")

#input path to plasmid db excel file
holmen_plasmids_xl<-path("X:/Holmen Lab/Databases/PLASMID DATABASE - Holmen Lab.xlsx")




#list files from snapgene db path. 
snapgene_maps<-dir_ls(path=snapgene_db)%>%
  
  #move into tibble and rename to path value. 
  as_tibble()%>%
  rename(path = value)%>%
  
  #get filename from path value (as character)
  mutate(filename = basename(path))%>%
  relocate(filename)%>%
  
  #get plasmid number as 4-digit character string. 
  mutate(vector_number = substr(filename, 1,4))%>%
  relocate(vector_number)%>%
  
  #make name of each link. 
  mutate(link_name = paste0(vector_number, ".dna"))



#excel import and basic cleaning
holmen_vector_nums<-read_excel(holmen_plasmids_xl, sheet="Holmen")%>%
  
  #selecting only necessary columns. 
  #map will be link to files. 
  select(1,2)%>%
  row_to_names(1)%>%
  clean_names()%>%
 
  #vector num needs to be in 4-character format. 
  mutate(vector_number = as.character(sprintf("%04d", as.numeric(vector_number))))




#join and write db. 
holmen_vector_nums%>%
  
  left_join(snapgene_maps)%>%
  
  mutate(map = if_else(!is.na(path), 
                       paste0("=HYPERLINK(", "\"", path, "\"", ",", "\"", link_name, "\"", ")"),
                       NA))->holmen_output




library(openxlsx)

write_xlsx(holmen_output, "updated_links.xlsx")
