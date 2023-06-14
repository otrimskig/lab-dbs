###batch renaming of dna files in snapgene database,
#used in this application to prepend the date of submission
#to the sequencing results files. 


library(tidyverse)

pathPrep <- function(path = "clipboard") {
  y <- if (path == "clipboard") {
    readClipboard()
  } else {
    cat("Please enter the path:\n\n")
    readline()
  }
  x <- chartr("\\", "/", y)
  writeClipboard(x)
  return(x)
}

##########################

#submission name for plasmidsaurus
#used to search for relevant files. 
submission="J5G"

#submission date to prepend to file names
sub_date="2023.02.09"

#location of files.
file_loc = "X:/Holmen Lab/Databases/Snapgene db/DNA Files/2-sequencing results/"


###########################

#creates df with new/old names as vars
list.files(file_loc)%>%
  as_tibble()%>%
  rename(n1 = value)%>%
  filter(grepl(submission, n1))%>%
  mutate(n2 = paste0(sub_date, ".", n1))->filenames


#sets wd to relevant place, and renames using above df. 
setwd(file_loc)
file.rename(filenames$n1, filenames$n2)
    

library(googlesheets4)

working_doc<-read_sheet("https://docs.google.com/spreadsheets/d/1DYwkZEVK39qMZl1vYrg3R7hi41nye1yikUNYN4tzWbs/edit#gid=190808741")



  
working_doc%>%
  mutate(z =mapply(sub, "(.{3})(_pLann)", paste0(y, "\\2"), x))%>%
  view()


working_doc%>%
  mutate(z =mapply(sub, "(.{3})(_pLann)", paste0(y, "\\2"), x))%>%
  select(-y)->filenames2

file.rename(filenames2$x, filenames2$z)
