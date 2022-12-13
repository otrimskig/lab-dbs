


#############################
#list of plasmids to be updated.
new<-"file path here"



####################################
#get plasmid_db_r object convenient into R from csv file. 
plasmid_db_r<-
read.csv("plasmid_db_r.csv")%>%
  as_tibble()%>%
  select(-1)



########################################
#import list of new vectors, with column name "num"

new_plasmids <- read.csv(new)
#convert vector number to 4-digit num4 column. 
new_plasmids<-
  new_plasmids%>%
  mutate(num4 = sprintf("%04d", new_plasmids$num))




##########################################

#only need a list of vector numbers (in 4-digit form) for below to work. 
#use list of num4, to create temporary tables. 
#2 filtering joings: first, use list to extract those values from the full set. 
tbl_a<-
  plasmid_db_r%>%
#pulls out data from main db that have matching num4 from new list.   
  semi_join(new_plasmids, by = c("num4"))%>%
#then, fill out that small list with missing information. 
  #Add "yes" to "file" column,
  mutate(file = "yes")%>%
  #then add the hyperlink to the sequence_file column. 
  mutate(sequence_file = paste0("=HYPERLINK(", "\"", "X:\\holmen lab\\plasmids\\", potential_file_name, "\"", ",", "\"", potential_file_name, "\"", ")"))
#name the object tbl_a. 




##########################################


plasmid_db_r%>%
  #remove old data for values contained in updated plasmid list. 
  anti_join(new_plasmids, by = c("num4"))%>%
  #add updated data back to the full data set.
  full_join(tbl_a)%>%
  #arrange by num4 to make it easy to copy-paste into excel. 
  arrange(num4)%>%
  #write updated csv file
  write.csv("plasmid_db_r2.csv")













