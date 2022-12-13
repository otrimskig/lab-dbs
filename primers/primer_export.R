#read primer sequences from Google sheet, export list for synthesis. 

library(googlesheets4)
library(tidyverse)
read_sheet('https://docs.google.com/spreadsheets/d/11s8_36bnXaRZsAUeRdIY_J0G2fl0D__2IPDjKY9gU0s/edit?usp=sharing')%>%
  as_tibble()%>%
  rename(log = "...1")%>%
  filter(log == TRUE)%>%
  select("Number", "Sequence")%>%
  write.table(sep = ";", col.names = FALSE, row.names = FALSE, quote = FALSE)
