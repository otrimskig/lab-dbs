library(tidyverse)
library(janitor)
library(stringr)
library(lubridate)
library(rio)
library(fs)



readRDS("nec_file_paths_all_x.rds")->all_x

all_x


readRDS("nec_file_paths_folder.rds")->in_folder

files<-in_folder%>%
  as_tibble()%>%
  rename(path =value)%>%
  mutate(fspath = as_fs_path(path))%>%
  mutate(modified = file_info(fspath)$modification_time)%>%
  arrange(desc(modified))%>%
  slice(1:700)
  
  
  view(files)

  
files%>%
  filter(grepl(".xlsx$", path))->xlsx
files%>%
  filter(grepl(".xls$", path))->xls


saveRDS(xlsx,"xlsx.rds")
saveRDS(xls, "xls.rds")
