



# Function to add a dash between 09 and 29 (or any number) in filenames




add_dash_to_filenames <- function(filenames) {
  new_filenames <- vector("character", length(filenames))
  
  for (i in seq_along(filenames)) {
    current_filename <- filenames[i]
    
    # Check if filename already contains a dash in the desired position
    if (grepl("(\\d{2})-(\\d{2})[^0-9]", current_filename)) {
      new_filenames[i] <- current_filename
    } else {
      # Insert the dash between 09 and 29 (or any number)
      new_filename <- sub("^(.{7})", "\\1-", current_filename)
      new_filenames[i] <- new_filename
    }
  }
  
  return(new_filenames)
}

library(fs)

file_path<-path("C:/Users/u1413890/OneDrive - University of Utah/Holmen Lab Onedrive/Garrett (OD)/experiment files/dna gel images/")

setwd(file_path)

list.files()->img_files_1


add_dash_to_filenames(img_files_1)->img_files_2

img_files_2

img_files_1

file.rename(img_files_1, img_files_2)
