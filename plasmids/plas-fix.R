#import current db into R
plasmid_db<-
read.csv("PLASMID DATABASE - Holmen Lab.csv", skip = 1)%>%
  select(1:4)%>%
  clean_names()%>%
  as_tibble()


#make db r-friendly. add convenient numbers/columns to get proper names. 
plasmid_db_r<-
plasmid_db%>%
  mutate(num4 = sprintf("%04d", plasmid_db$vector))%>%
  mutate(file_name = str_sub(sequence_file, 6))%>%
  rename(potential_file_name = file_name)%>%
  mutate(potential_file_name = ifelse(potential_file_name == "",
                                     paste0(vector_name, ".dna"),
                                      potential_file_name)
                                      )%>%
  mutate(potential_file_name = path_sanitize(paste0(num4, "-", potential_file_name)))%>%
  rename(old_file = sequence_file)%>%
  mutate(sequence_file = ifelse(file == "yes", 
                paste0("=HYPERLINK(", "\"", "X:\\holmen lab\\plasmids\\", potential_file_name, "\"", ",", "\"", potential_file_name, "\"", ")"), 
                old_file))%>%
  relocate(sequence_file, file)
         

plasmid_db_r<-
plasmid_db_r%>%
  select(-old_file)
  
  
  write.csv("plasmid_db_r.csv")

#filter values contained in new plasmids list.
tbl_a<-
  plasmid_db_r%>%
  semi_join(sg_matches3, by = c("num4"))%>%
  mutate(file = "yes")%>%
  mutate(sequence_file = paste0("=HYPERLINK(", "\"", "X:\\holmen lab\\plasmids\\", potential_file_name, "\"", ",", "\"", potential_file_name, "\"", ")"))


plasmid_db_r%>%
  #remove old data for values contained in updated plasmid list. 
  anti_join(sg_matches3, by = c("num4"))%>%
  full_join(tbl_a)%>%
  arrange(num4)%>%
  
plasmid_db_r%>%
  write.csv("plasmid_db_r.csv")

plasmid_db_r%>%
  filter(file == "yes")


plasmid_db_r%>%
  write.csv("plasmid_db_r.csv")



