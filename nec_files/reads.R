



file_names <- list.files(pattern = ".rds")

file_names



for(i in 1:length(file_names)){
  assign(file_names[i],readRDS(file_names[i]))
}
