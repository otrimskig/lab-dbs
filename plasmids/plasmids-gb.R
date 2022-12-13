plasmids <- as_tibble(plasmids)%>%
  select(1:3)%>%
  slice(-1)



titles <- as_tibble(plasmids)%>%
  select(1:3)%>%
  slice(1)

plasmids = plasmids %>%
 rename(plasmid = 3, num = 2, file =1)


plasmids



v_files <- list.files(path = "X:\\Holmen Lab\\.", full.names = TRUE, recursive = TRUE, pattern = "*\\.gb$", ignore.case = TRUE)


v_files <- v_files %>% as_tibble()






v_files <-
v_files %>% 
  mutate(filename = gsub("\\.gb", "", v_files$filename))



fuzzy_list_nonas <- fuzzy_list %>% drop_na()

v_files <- v_files %>%
  rename(file_path = loc)



plasmids_name

v_files

files_all0 <- files_all

files_all<-full_join(files_all, v_files, by = c("names" = "filename", "before" = "file_path"))%>%
  rename(file_name = names, path = before)%>%
  drop_na()



fuzzy_list_best_hit <- stringdist_full_join(files_all, plasmids_name, by = c("file_name" = "plasmid"), 
                     distance_col = "dist",
                      max_dist = 20)%>%
  group_by(path)%>%
  arrange(dist)%>%
  slice(1:3)%>%
  ungroup()%>%
  
  group_by(plasmid)%>%
  arrange(dist)%>%
  slice(1)%>%
  ungroup()%>%

  group_by(path)%>%
  arrange(dist)%>%
  slice(1)%>%
  ungroup()%>%
  
  relocate(c(num, plasmid), .before = file_name)%>%
  relocate(dist, .before = path)%>%
  drop_na()%>%
  arrange(dist)






write.csv(fuzzy_list_best_hit, "fuzzy_list.csv")
  

fuzzy_list<-
fuzzy_list %>%
  rename(plasmid_file_name = names, file_path = before)%>%
  relocate(num, .before = plasmid_file_name)%>%
  relocate(plasmid, .after = num)%>%
  relocate(dist, .after = plasmid_file_name)
fuzzy_list

fuzzy_list_best_hit<-
fuzzy_list %>%
  group_by(plasmid) %>%
  arrange(dist)%>%
  slice(1)


#######################
#import dataset
fuzzy_list_checked <- read_csv("X:/Holmen Lab/Lab Personnel/Garrett/R/fuzzy_list_checked.csv")

#1st step to tidy database. rename to shorter name. 
flc<-as_tibble(fuzzy_list_checked)%>%
  rename(verify = 1)%>%
  select(-2)


#get rid of NAs
flc<-
flc%>%
  mutate(verify = replace_na(verify, 0))

#check for NAs
sum(is.na(flc))

#get confirmed hits (1s)
flc_1s<-flc%>%
  filter(verify == 1)

#get unsure hits (2s)

flc_2s<-flc%>%
  filter(verify == 2)

setwd("X:/Holmen Lab/Lab Personnel/Garrett/R")

write.csv(flc_2s, "flc_2s.csv")


#####files copy

flc_2s

targetdir <- "X:\\Holmen Lab\\Lab Personnel\\Garrett\\R\\importr\\"



file.copy(from=flc_2s$path, to=targetdir, 
          overwrite = TRUE, recursive = TRUE, 
          copy.mode = TRUE)



#####################

flc_1s<-
flc_1s%>%
  mutate(num4 = sprintf("%04d", flc_1s$num))%>%
  relocate(num, .after=last_col())%>%
  relocate(num4, .before = "plasmid")%>%
  select(-num)



####get file names with extensions.
flc_1s<-
flc_1s%>%
  mutate(file_name_full = gsub(".*/","",flc_1s$path))%>%
  relocate(file_name_full, .before = path)



####add plasmid numbers in front of plasmid names. 
flc_1s%>%
  mutate(file_name_new = paste0(num4, "-", file_name_full))%>%
  relocate(file_name_new, .before = file_name_full)%>%
  mutate(file_name_full = gsub(".*/","",flc_1s$path))


flc_1s<-flc_1s%>%
  arrange(file_name_full)

str(flc_1s)

setwd(targetdir)


file.rename(flc_1s$file_name_full, flc_1s$file_name_new)

str(flc_1s$file_name_full)


plasmids_path <- "X:\\Holmen Lab\\Sequences\\Plasmids"

list.files(plasmids_path)





####get filename extnsion. 
flc2<-
flc_1s%>%
  mutate(extension = paste0(".", file_ext(flc_1s$path)))

flc2<-flc2%>%
  rename(file_name_1 = file_name_new)%>%
  mutate(file_name_2 = paste0(num4, "-", plasmid, extension))%>%
  select(file_name_1, file_name_2)

setwd(plasmids_path)


file.rename(flc2$file_name_1, flc2$file_name_2)


#######################
#######################
#######################
#######################

### second round of file adding with verified group 2 initial


#read in plasmid info, with coded verification added manually by me in excel after looking at plasmid maps. 
flc2 <- read_csv("X:/Holmen Lab/Lab Personnel/Garrett/R/flc_2s.csv")

#clean her up a bit, and filter for all "1s" - AKA plasmids verified as matches. 
flc2<-as_tibble(flc2)%>%
  select(-1, -3)%>%
  filter(verify2 == 1)


#copy files in df above, to holmen plasmids folder.


plasmids_path <- "X:\\Holmen Lab\\Plasmids"

file.copy(from=flc2$path, to=plasmids_path, 
          overwrite = TRUE, recursive = TRUE, 
          copy.mode = TRUE)


######### files copied and in plasmids folder. now need to rename. ######


#set up data frame of files, with columns for file names before and after
names<-
flc2 %>%
  #keep only necessary columns
  select(2, 3, 4, 6)%>%
  #rename to make a bit clearer
  rename(plasmid_name = plasmid)%>%
  #get original file names that include extensions, so R will recognize the files listed in the "before" names
  mutate(file_name_1= gsub(".*/","",flc2$path))%>%
  select(-file_name, -path)%>%
  #"sanitize" names of plasmids so that all characters can are allowed for use in file names. uses package "fs"
  mutate(plasmid_name_safe = path_sanitize(flc2$plasmid))%>%
  select(-plasmid_name)%>%
  #turns plasmid number into 4-digit number with leading zeros, if applicable. uses package "tools" (I think)
  mutate(num4 = sprintf("%04d", flc2$num))%>%
  select(-num)%>%
  #lastly, add all info into new file name column. add 4-digit number, new name, a period, and then the extension of the new file, which is copied from the path of the old file. 
  mutate(file_name_2 = paste0(num4, "-", plasmid_name_safe, ".", file_ext(flc2$path)))%>%
  select(-plasmid_name_safe, -num4)


####now to rename all the files....
#set name of path
plasmids_path <- "X:\\Holmen Lab\\Plasmids"
#set working directory to where you want to rename files, because the stupid function doesn't allow you to point it anywhere other than the wd. (-____-)
setwd(plasmids_path)
#and finally rename the files with the vectors from "names" df. 
file.rename(names$file_name_1, names$file_name_2)


###and done. 





###############getting list of matched plasmids into excel database. 
library(readr)
plasmid_db <- read_csv("PLASMID DATABASE - Holmen Lab.csv", 
                       skip = 1)
View(plasmid_db)



plasmid_db<-
  plasmid_db%>%
  select(1:3)%>%
  clean_names()%>%
  mutate(vector_number = as.numeric(vector_number))%>%
  filter(!is.na(vector_number))

#make df of files in plasmids dir 
nums<-
#extract plasmid numbers from the file names. 
  list.files(plasmids_path)%>%
  as_tibble()%>%
mutate(value = as.numeric(substr(nums$value, 1, 4)))%>%
#add "file" value
  mutate(file = 1)



#full_join(plasmid_db, nums, by = c("vector_number" = "value", "file" = "file"))%>%
  #mutate(file = coalesce(file, 0))%>%
  #write.csv("table.csv")



nums
plasmid_db
setwd(home)





##################################

checks<-
left_join(plasmid_db, nums, by = c("vector_number" = "value"))%>%
  arrange(file.y)%>%
  select(-file.x)%>%
  rename(file = file.y)%>%
  relocate(file, .before = vector_number)

checks2<-
checks%>%
  mutate(file = coalesce(file, 69))%>%
  arrange(desc(file))%>%
  mutate(file2 = replace(file, file ==69, ""))%>%
  mutate(file2 = replace(file2, file2 == 1, "yes"))%>%
  relocate(file2, .before = vector_number)%>%
  select(-file)%>%
  rename("file" = "file2")

view(checks2)

#write.csv(checks2, "checks.csv")


checks2
plasmid_db
#####################


library(readr)
checks <- read_csv("checks.csv", 
                       skip = 0)
View(checks)

checks<-
checks%>%
  select(-1)



plasmids_path <- "X:\\Holmen Lab\\Plasmids"
#make df of files in plasmids dir 
nums<-
  #extract plasmid numbers from the file names. 
  list.files(plasmids_path)%>%
  as_tibble()%>%
  mutate(value2 = as.numeric(substr(nums$value, 1, 4)))%>%
  #add "file" value
  mutate(file = 1)

nums_left<-
nums%>%
  rename(vector_name = value, vector_number = value2)%>%
  select(-file)

files_list<-checks%>%
  left_join(nums_left, by = c("vector_number"))%>%
  rename(vector_name = vector_name.x, file_name = vector_name.y)


files_links<-
files_list%>%
 # filter(file_name != is.na(file_name))%>%
  
  #code to turn name of file into working hyperlink (in excel)
  mutate(link = ifelse(file == "yes",
                       paste0("=HYPERLINK(", "\"", "X:\\holmen lab\\plasmids\\", file_name, "\"", ",", "\"", file_name, "\"", ")"),
                       ifelse("")))%>%
  relocate(link, .before = file)%>%
  replace(is.na(.), "")



write.csv(files_links, "files_links.csv")






#########
checks <-read_csv("flc_2s.csv", 
                  skip = 0)

checks<-
checks%>%
  filter(verify2 == 2)%>%
  select(-1, -2, -3, -file_name, -dist)%>%
  arrange(num)

checks  


#copy files in df above, to holmen plasmids folder.


plasmids_path2 <- "X:\\Holmen Lab\\Plasmids\\check matches"

file.copy(from=checks$path, to=plasmids_path2, 
          overwrite = TRUE, recursive = TRUE, 
          copy.mode = TRUE)

setwd(plasmids_path2)

checks%>%
  mutate(file_name_1= gsub(".*/","", checks$path))%>%
  select(-path)%>%
  rename(link = file_name_1)%>%
  mutate(link = paste0("=HYPERLINK(", "\"", "X:\\holmen lab\\plasmids\\check matches\\", link, "\"", ",", "\"", link, "\"", ")"))%>%
  rename(vector_number = num, plasmid_name = plasmid, link_to_file = link)%>%
  mutate("is match?" = "")%>%
  relocate("is match?", .before = vector_number)%>%
  write.csv("sheri_match_check.csv")

