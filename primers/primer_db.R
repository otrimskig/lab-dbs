library(tidyverse)
library(janitor)

read_csv("Snapgene - Primer Sequences.csv")%>%
  clean_names()%>%
  mutate(primer_name = gsub(",", "", primer_name))%>%
  mutate(sequence = toupper(sequence))%>%
  rename("Primer Name" = primer_name, "Sequence" = sequence)%>%
  write_csv("Snapgene - Primer Sequences.csv")


file.copy("Snapgene - Primer Sequences.csv", 
          "X:/Holmen Lab/Databases/Snapgene - Primer Sequences.csv", 
          overwrite = TRUE)
