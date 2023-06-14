#purpose:
#updates plasmid database excel file with working links,
#using the most updated version of the dna files list
#from the snapgene db. (/databases/snapgene db/1-holmen plasmids/)

#takes all info from filenames, combines it with info in excel file
#and writes back to excel file with most current filenames and links, 
#without changing formatting of excel file.

library(tidyverse)
library(fs)
library(janitor)
library(openxlsx)


#use dir_ls instead of list.files.

#input path to plasmid db (repo of snapgene files). 
snapgene_db<-path("X:/Holmen Lab/Databases/Snapgene db/DNA Files/1-Holmen Plasmids")

#input path to plasmid db excel file
holmen_plasmids_xl<-path("X:/Holmen Lab/Databases/PLASMID DATABASE - Holmen Lab.xlsx")



#list files from snapgene db path, will be most updated.  
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
  mutate(link_name = paste0(vector_number, ".dna"))%>%
  
  group_by(vector_number)%>%
  slice(1)%>%
  ungroup()



#excel import into df, and basic cleaning, to get vector nums and (current) links
holmen_vector_nums<-read_excel(holmen_plasmids_xl, sheet="Holmen")%>%
  
  #selecting only necessary columns. 
  #map will be link to files. 
  select(1,2)%>%
  row_to_names(1)%>%
  clean_names()%>%
  
  #vector num needs to be in 4-character format. 
  mutate(vector_number = sprintf("%04d", as.numeric(vector_number)))


#join and save df that will be added to excel file.  
holmen_vector_nums%>%
  
  left_join(snapgene_maps)%>%
  #change map value to character with working hyperlink. 
  mutate(map = if_else(!is.na(path), 
                       paste0("=HYPERLINK(", "\"", path, "\"", ",", "\"", link_name, "\"", ")"),
                       NA))%>%
  select(1,2)->holmen_output







#now read and write XL file. 

#loads workbook into R. 
loadWorkbook(holmen_plasmids_xl)->holmen_xl_wb

#re-writes "map" variable to correct links
#writes as a working formula. 
writeFormula(wb = holmen_xl_wb,
            x = holmen_output$map,
            sheet = "Holmen",
            startCol = 1,
            startRow = 3)

#saves updated workbook object back to original file. 
saveWorkbook(holmen_xl_wb, holmen_plasmids_xl, overwrite = TRUE)


