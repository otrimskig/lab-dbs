


library(tidyverse)

#read in full enzyme set from hol_enz csv file
#convert to a vector, save as object. 
enzymes<-
  read_csv("hol_enz.csv")%>%
  select(1)%>%
  pull()%>%
  paste(collapse = " ")



txt<-
  paste0("\"holmen enzymes\"", "{", enzymes, "}")

writeLines(txt, "ApE enzymes list.txt")
