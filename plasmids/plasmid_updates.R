
###input:

csv_file<-"X:\\Holmen Lab\\Databases\\PLASMID DATABASE - Holmen Lab.csv"


holmen_plasmids<-  
  read_csv(csv_file, skip = 1)%>%
  as_tibble()%>%
  select(1:4)%>%
  clean_names()
  
holmen_plasmids<-
  holmen_plasmids%>%
    mutate(num4 = sprintf("%04d", holmen_plasmids$vector_number))%>%
    mutate(potential_sequence_file = sequence_file)%>%
    
    #make a potential file name, clean, for all vectors. Leave already named files as-is. 
    mutate(potential_sequence_file = coalesce(sequence_file,
                                              path_sanitize(paste0(num4, "-", vector_name, ".dna")), sequence_file))
    
    

####now have R-friendly vector db taken from csv. 
holmen_plasmids



########new plasmids to be added to db
sg_matches2<-read_csv("sg_matches2.csv")


rename<-
sg_matches2%>%
  mutate(num4 = sprintf("%04d", sg_matches2$vector_number))%>%
  filter(verify == "1")%>%
  mutate(file2 = "yes")%>%
  mutate(new_name = path_sanitize(paste0(num4, "-", search_term)))%>%

####files
  
  select(sg_files, new_name)%>%
  rename(old_name = sg_files)



#######################################
sg_matches3<-
sg_matches2%>%
  mutate(num4 = sprintf("%04d", sg_matches2$vector_number))%>%
  filter(verify == "1")%>%
  mutate(file2 = "yes")%>%
  mutate(new_name = path_sanitize(paste0(num4, "-", search_term)))%>%
  select(num4, vector_name, new_name, file2, vector_number)%>%
  rename(sequence_file = new_name)
  




holmen_plasmids%>%
  mutate(file = case_when(vector_number %in% sg_matches3$vector_number)~"yes",
         file)













###use at the end. #################################

mutate(sequence_file = ifelse(file == "yes", 
                              paste0("=HYPERLINK(", "\"", "X:\\holmen lab\\plasmids\\", sequence_file, "\"", ",", "\"", sequence_file, "\"", ")"), 
                              sequence_file))