library(magrittr)
library(tidyverse)
setwd("C:/Users/u1413890/OneDrive - University of Utah/Holmen Lab Onedrive/Garrett (OD)/R/lab dbs/nec_files")

nec_files_x<-list.files(path = "X:/Holmen Lab/", pattern = "necropsy",
                      full.names = TRUE, 
                      recursive = TRUE, 
                      ignore.case = TRUE)

saveRDS(nec_files_x, "nec_file_paths_all_x.rds")

nec_files_folder<-list.files(path = "X:/Holmen Lab/Necropsy files", full.names = TRUE)

saveRDS(nec_files_folder, "nec_file_paths_folder.rds")

nec_files_folder%>%
  view()
