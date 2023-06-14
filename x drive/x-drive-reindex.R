library(tidyverse)
library(fs)
library(pbapply)
# list.files(path = "X:/Holmen Lab", recursive = TRUE, full.names = TRUE)->x_drive
# 
# 
# x_drive%>%saveRDS("C:/Users/u1413890/OneDrive - University of Utah/Holmen Lab Onedrive/Garrett (OD)/R/x_drive2.rds")
# 
# 


readRDS("x_drive2.rds")->x_drive2


x_drive2[1:500]->x_sample


pbsapply(x_drive2, file_info)->x_all_files

# file_info(x_drive2)->file_info
# 
# 
# file_info%>%saveRDS("x_drive_info.rds")
# 
# view(file_info)

saveRDS(x_all_files, "x_all_files.rds")
