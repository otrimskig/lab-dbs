library(tidyverse)
library(janitor)

read_csv("x drive/x_drive_index.csv", col_names = FALSE)%>%
  clean_names()%>%
  rename(path = x1)%>%
  
  mutate(len = as.numeric(str_extract(path, "^[[:digit:]]+")))%>%
  mutate(path = gsub("^[^:]*:", "", path))%>%
  arrange(path)%>%
  
  saveRDS("x drive/x_drive_index.rds")

