

####get list of snapgene files, unmatched to db. 
sg_files <- list.files(path = "X:\\Holmen Lab\\Snapgene db\\DNA Files\\Other Sequences\\")%>%
  as_tibble()%>%
  rename(sg_files = value)

sg_files

#####get holmen plasmid db
library(readr)
plasmid_db <- read_csv("X:/Holmen Lab/Lab Personnel/Garrett/R/plasmid_db.csv", 
                       skip = 1)
View(plasmid_db)

unmatched_plasmids<-
plasmid_db%>%
  select(2:4)%>%
  clean_names()%>%
  filter(is.na(file))%>%
  select(-file)%>%
  mutate(search_term = paste0(vector_name, ".dna"))

unmatched_plasmids








#fuzzy_list_best_hit <- 
stringdist_full_join(unmatched_plasmids, sg_files, by = c("search_term" = "sg_files"), 
                                            distance_col = "dist",
                                            max_dist = 20)%>%
  group_by(search_term)%>%
  arrange(dist)%>%
  slice(1:3)%>%
  ungroup()%>%
  
  group_by(sg_files)%>%
  arrange(dist)%>%
  slice(1)%>%
  ungroup()%>%
  
  group_by(search_term)%>%
  arrange(dist)%>%
  slice(1)%>%
  ungroup()%>%
  arrange(dist)%>%
  drop_na()%>%
  write.csv("sg_matches.csv")
  
  #%>%
  
  relocate(c(num, plasmid), .before = file_name)%>%
  relocate(dist, .before = path)%>%
  drop_na()%>%
  arrange(dist)
  
  
  
  
  
  
  
  
  
  #############
  starting_path<-"X:\\Holmen Lab\\Snapgene db\\DNA Files\\Other Sequences\\"
  
  sg_matches2<-read_csv("sg_matches2.csv")
  
  sg_matches2
  
  rename<-
    sg_matches2%>%
      mutate(num4 = sprintf("%04d", sg_matches2$vector_number))%>%
      filter(verify != 0)%>%
    select(-dist, -1)%>%
      mutate(new_name = paste0(num4, "-", search_term))%>%
      rename(old_name = sg_files)%>%
      relocate(old_name)%>%
      filter(verify == 1)%>%
      select(-verify)%>%
    mutate(sg_path =  paste0(starting_path, new_name))

  
 
  rename
  
  
  
  
 
  setwd(starting_path)
  file.rename(rename$old_name, rename$new_name)
  
  plasmids_path <- "X:\\Holmen Lab\\Plasmids\\"

  
  
  file.copy(from=paste0(starting_path, rename$new_name), to=plasmids_path, 
                      overwrite = TRUE, recursive = TRUE, 
                      copy.mode = TRUE)

  
  
  holmen_plasmids<-"X:\\Holmen Lab\\Databases\\PLASMID DATABASE - Holmen Lab.csv"

holmen_plasmids<-  
 read_csv(holmen_plasmids, skip = 1)%>%
   as_tibble()%>%
   select(1:4)

holmen_plasmids%>%
  filter(file == "yes")
  
  #################
  
  

  sg_matches2%>%
  mutate(num4 = sprintf("%04d", sg_matches2$vector_number))%>%
  filter(verify != 0)%>%
  select(-dist, -1)%>%
  mutate(new_name = paste0(num4, "-", search_term))%>%
  rename(old_name = sg_files)%>%
  relocate(old_name)%>%
  filter(verify == 1)%>%
  select(-verify)%>%
  mutate(sg_path =  paste0(starting_path, new_name))%>%
  select(vector_number, new_name)%>%
  mutate(file = "yes")#%>%
  
  right_join(holmen_plasmids, by = c(vector_number = 'vector #', "new_name" = 'sequence file', "file"))%>%
mutate('sequence file'= ifelse(file == "yes",
                     paste0("=HYPERLINK(", "\"", "X:\\holmen lab\\plasmids\\", new_name, "\"", ",", "\"", new_name, "\"", ")"),
                     ifelse("")))%>%
  select(-new_name)%>%
  filter(file == "yes")
  
  
  holmen2<-
  holmen_plasmids%>%
    mutate(num4 = sprintf("%04d", holmen_plasmids$'vector #'))%>%
    mutate(file_name = ifelse(file == "yes", 
                               holmen_plasmids$'sequence file'))%>%
             mutate(file_name = replace_na(file_name, 
                                           "poop"))

  
  
  
    holmen2%>%
    mutate(file_name = ifelse(file_name == "poop", 
                              path_sanitize(paste0(num4, "-", `Vector Name`, ".dna")), file_name))%>%
    clean_names()
   
######
  
    holmen_plasmids_R2<-
    
  holmen2%>%
    mutate(sequence_file = ifelse(file == "yes", 
                                    paste0("=HYPERLINK(", "\"", "X:\\holmen lab\\plasmids\\", file_name, "\"", ",", "\"", file_name, "\"", ")"), 
                                    "" )
                                    )#%>%
   # replace(is.na(.), "")
  
  
  holmen_plasmids_R2
  
  
  
  
  ################
  

  sg_matches3<-
  sg_matches2%>%
    filter(verify == 1)%>%
    mutate(file = "yes")%>%
    select(vector_number, file)

    sg_matches3  
  
    
    
    sg_matches3
  

   full_join(holmen_plasmids_R, sg_matches3)%>%
     group_by(vector_number)
  
  
  holmen_plasmids_R
  
  