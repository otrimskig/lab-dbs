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

files2 <- list.files(path = "X:\\Holmen Lab\\.", full.names = TRUE, recursive = TRUE, pattern = "*\\.dna$", ignore.case = TRUE)


f2<-files2%>%
  as_tibble()

f1<-v_files%>%
  as_tibble()

##############################################
full_join(f1, f2)%>%
  write.csv("all_files.csv")





view(files)

files <- as_tibble(files)

files

files2 <- as_tibble(files2)

files2

all_files <- full_join(files, files2)


files2 <- files2 %>%
  mutate(rn = row_number())

files <- files %>%
  mutate(rn = row_number())

files_all <- left_join(files, files2, by = "rn")

files_all <-
files_all %>%
  mutate(names = gsub(".*\\/", "", files_all$value.x))

files_all <- files_all %>%
  select("value.x", "names") %>%
  relocate(names, before = "value.x")

files_all <-
files_all %>%
  mutate(names = gsub("\\.dna", "", files_all$names))



plasmids_name <- plasmids %>%
  select(num, plasmid)

any(is.na(plasmids_name))


plasmids_name <- plasmids_name[complete.cases(plasmids_name),]

plasmids_name




stringdist_full_join(as.data.frame(files_all), as.data.frame(plasmids), by = c("names", "plasmid"))


fuzzy_list <- stringdist_full_join(as_tibble(files_all), as_tibble(plasmids_name), by = c("names" = "plasmid"),
                                   distance_col = "dist",
                                   max_dist = 20)

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

















