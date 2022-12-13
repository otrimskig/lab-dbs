library(tidyverse)
library(janitor)
library(readxl)
library(writexl)
library(magrittr)
library(fs)

plasmids_file<-"X:/Holmen Lab/Databases/PLASMID DATABASE - Holmen Lab.xlsx"

#getting excel plasmids file into R. 
read_excel(plasmids_file, sheet="Holmen")->plasmid_excel


#cleaning up. removing unnecessary info. 
plasmid_excel%>%
  row_to_names(1)%>%
  clean_names()%>%
  select(1:4)%>%
  #change to numeric, otherwise transformation to 4-digit doesn't work. 
 mutate(vector_number = as.numeric(vector_number))%>%

  #complicated if_else that adds the link code to the file name and location...
  mutate(sequence_file = if_else(file=="yes",
                    
                    paste0("=HYPERLINK(", "\"", 
                     #full path to file
                     
                     #using this since all sequences copied into snapgene
                     #are automatically converted to .dna - more consistent. 
                     #also the most updated version of the plasmid files. 
                     "X:/Holmen Lab/Databases/Snapgene db/DNA Files/Plasmids/",
                     
                     sprintf("%04d", vector_number),
                     "-",
                     vector_name,
                     ".dna",
                     #add  [","]
                     "\",\"", 
                     #name of link
                     paste0(sprintf("%04d", vector_number),".dna"),
                     #add [")]
                     "\")"
                     
                     ),"NA"))%>%
  

  #exporting csv of plasmids list with working links.... somewhat.
  write.csv("out-plasmids.csv", na="", row.names = FALSE)

#some links do not work, because files are not all uniformly named as they appear
# in the plasmid excel db. Thought this was an issue I fixed previously but
#apparently not. 

################################################################

#now need to go back to the excel, and check for mismatches btwn filename and plasmid name
#and other inconsistencies 


#first, starting with same cleaning as above. 
  plasmid_excel%>%
    row_to_names(1)%>%
    clean_names()%>%
    select(1:4)%>%
  view()
  
  
  
  #now testing for inconsistencies. 
#do any plasmids have links to files that are NOT marked "yes" in the "file" column?
    filter(!is.na(sequence_file)&is.na(file))%>%
    view()
  #no results, so no. db is consistent that way. 
  
  
  
  
#### #### #### ##### #### ##
  
    
 #repeat of cleaning....
#this time noticed a discrepency in reading of special characters in with above excel. 
    #switch to csv. 
  read_csv("PLASMID DATABASE - Holmen Lab.csv")->plasmid_db_csv

  
  plasmid_db_csv%>%
    row_to_names(1)%>%
    clean_names()->plasmid_csv2
  
  
 
  #performing transformation and renaming object as itself.
  plasmid_csv2%<>%
  
  select(1:4)%>%
    mutate(vector_number = as.numeric(vector_number))%>%
   
    #first necessary line of code. 
    #now all vector numbers transformed into 4-digit numbers. 
     mutate(vector_number=sprintf("%04d", vector_number))
 
  
plasmid_csv2%>%
  
    mutate(vector_number = as.character(vector_number))%>%
    select(3,4)%>%
  

    
  #sanitizing path names. Keeping number col to maintain link to actual plasmids. 
  
   mutate(vector_name_clean = trimws(path_sanitize(vector_name)))%>%
  
  #adding filename col. 
 
  mutate(filename = paste0(vector_number, "-",vector_name_clean, ".dna"))%>%  

#now have csv file with file-friendly names for every plasmid
  #linked to the plasmid numbers.  
    write_csv("plasmid_names_clean.csv")
  


#########################
   #getting list of files in snapgene db. 
  
  
  list.files("X:/Holmen Lab/Databases/Snapgene db/DNA Files/Plasmids/")->plas.files

  plas.files%>%
    as_tibble()%>%
    rename(fn_rl = value)%>%
    
    #extracting plasmid numbers from filenames. 
    mutate(nums = substr(fn_rl, 0,4))%>%
    rename(name1 = fn_rl)->snapgene_files


  #used this in join below to check for mismatches; 
  #found some files were mislabeled with the wrong vector number.
  #fixed all discrepencies. 
  read_csv("plasmid_names_clean.csv")%>%
    select(1,4)%>%
    rename(name2 = filename)%>%
    rename(nums = vector_number)->plas_names_clean



left_join(snapgene_files, plas_names_clean, by = "nums")%>%
  relocate(nums)%>%
  select(-name2)%>%
  
  #re-joining to main db to be able to update excel sheet. 
  right_join(plasmid_csv2, by = c("nums" = "vector_number"))%>%
  
  select(-sequence_file, -file)%>%
  rename(filename = name1)%>%
  rename(vector_number = nums)%>%       
  
  #adding links to files. 
  mutate(file_link = ifelse(!is.na(filename),
                             
                    paste0("=HYPERLINK(", "\"", 

                    ######full path to file#######
                    
                    #using this path since all sequences copied into snapgene
                    #are automatically converted to .dna - more consistent. 
                    #also the most updated version of the plasmid files. 
                   
                     "X:/Holmen Lab/Databases/Snapgene db/DNA Files/Plasmids/",filename,
                         
                   
                    "\",\"", #add  [","]
                              
                     
                    ###########name of link:######
                    
                    paste0(vector_number,".dna"),
                    
                    
                    "\")" #add [")]
                    ),
                    #############
                    
                    #neg condition
                    NA))%>%

  relocate(file_link)%>%
       
  
      write.csv("filenames_corrected2022.12.13.csv",row.names = FALSE, na="")

###############
#updated plasmids db excel sheet 12.13.22 with above information. 


  

  
  