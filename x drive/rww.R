library(tidyverse)
library(fs)


# set the directory path
dir_path <- "X:/Holmen Lab"

# get a list of all the folders within the directory
folders <- list.dirs(path = dir_path, recursive = FALSE)

# create an empty data frame to store the results
results <- data.frame(Folder = character(), Size = numeric(), stringsAsFactors = FALSE)

# loop through each folder and calculate its size
for (folder in folders) {
  # calculate the size of the folder in bytes
  size <- sum(file.info(list.files(path = folder, recursive = TRUE, full.names = TRUE))[,"size"])
  
  # add the results to the data frame
  results <- rbind(results, data.frame(Folder = folder, Size = size))
}




