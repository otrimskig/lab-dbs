library(tidyverse)
library(janitor)
library(stringr)
library(lubridate)
library(rio)
library(fs)

############################################
#read in list of all necropsy files with their paths. 

readRDS("necropsy_files.rds")->necropsy_files

#get xlsx files. 
necropsy_files%>%
  filter(grepl(".xlsx$", filename))->nec_xlsx

#separate xls files. 
necropsy_files%>%
  filter(grepl(".xls$", filename))->nec_xls

#####################################################
#convert all xlsx files to .rds
#XLSX files

#original file paths
nec_xlsx%>%pull(file_path)->orig_paths_xlsx

#extract filenames for each. 
nec_xlsx%>%pull(filename)->filenames_xlsx

#compile destination paths. 
paste0("nec1/",filenames_xlsx)%>%
  gsub("xlsx", "rds", .)->rds_new_paths


#convert all xlsx files and move them into rds. 
mapply(convert, orig_paths_xlsx, rds_new_paths)


###############################################
#convert all xls files to .rds
#XLS files
#same process as above. 
#original file paths
nec_xls%>%pull(file_path)->orig_paths_xls


#filenames for each. 
nec_xls%>%pull(filename)->filenames_xls

#destination. 
paste0("nec1/",filenames_xls)%>%
  gsub("xls$", "rds", .)->rds_new_paths_xls


#convert all xlsx files and move them into rds. 
mapply(convert, orig_paths_xls, rds_new_paths_xls)

###############################################################

