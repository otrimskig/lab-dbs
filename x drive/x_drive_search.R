library(tidyverse)
library(janitor)

#open in lab_dbs R project. 
readRDS("x drive/x_drive_index.rds")->files


# #folder
# search_term<-paste0("clara", "\\\\")
# 
# #anywhere in path
# search_term<-"clara"


#in filename
search_term<-paste0(".*\\/*", "nanodrop", "*")






files%>%
  filter(grepl(search_term, path, ignore.case = TRUE))%>%
  view()

files%>%
  filter(grepl(search_term, path, ignore.case = TRUE))->test






test%>%
  slice(1, 7, 8, 12)%>%
  select(path)%>%
  

  filter(str_detect(path, regex("nanodrop(?!\\\\)", ignore_case = TRUE)))%>%
  
view()



