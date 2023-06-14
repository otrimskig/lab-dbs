library(tidyverse)
library(fs)
library(pbapply)





readRDS("x_all_files.rds")->all_files


all_files[1,4]

all_files[,1:10]%>%
  t()%>%
  row.names(NULL)%>%
  view()


all_files[c(1,3),]%>%
  t()->all_files2

row.names(all_files2) <- NULL

all_files2%>%
  as_tibble()%>%
  mutate(gb = as.numeric(size)/1073741824)->all_files3

all_files3%>%
  slice(1)



head(all_files3)
