library(tidyverse)
library(janitor)
library(readxl)
library(magrittr)
library(googlesheets4)
minus80<- read_excel("-80 Freezer Layout Holmen Lab.xlsx", 
                                             sheet = "Freezer A", col_names = FALSE)

minus80%>%
  clean_names()->minus80full



minus80full%>%
  mutate(shelf_split = ifelse(grepl("shelf", x1, ignore.case = TRUE), 1, 0))%>%
  mutate(rack_split = ifelse(grepl("rack", x2, ignore.case = TRUE), 1, 0))%>%
  mutate(tray_split = ifelse(grepl("tray", x2, ignore.case = TRUE), 1, 0))%>%
  mutate(index = 1:128)->minus80indexed
  
minus80indexed%>%
 filter(shelf_split == 1)%>%
  pull(index)->shelf_splits


minus80indexed%>%
  filter(rack_split == 1)%>%
  pull(index)->rack_splits


minus80indexed%>%
  filter(tray_split == 1)%>%
  pull(index)->tray_splits



shelf_splits<-c(0, shelf_splits, 130)
shelf_splits
rack_splits
tray_splits


for(i in 1:length(shelf_splits)){
  assign(paste0("shelf", i),
         minus80indexed%>%
             filter(index >=shelf_splits[i]& index<shelf_splits[(i+1)])
        )
}



rm(shelf1)
rm(shelf6)

shelf2%>%
  mutate(shelf_num = c(.$x1[1]))%>%
  slice(-c(1:2))%>%
  view()


shelf_list = Filter(function(x) nrow(x)>0, mget(ls(pattern = "shelf[0-9]")))


shelf_list


for (i in 1:length(shelf_list)){
  
  shelf_list[[i]]%<>%
    mutate(shelf_num = c(.$x1[1]))%>%
    slice(-c(1:2))
}
    


reduce(shelf_list, full_join)->minus80_flat


minus80_flat%>%
  clean_names()%>%
  filter(tray_split == 1)%>%
  pull(index)->tray_splits

################
#tray split

tray_splits<-c(0, tray_splits, 150)

tray_splits

for(i in 1:length(tray_splits)){
  assign(paste0("tray", i),
         minus80_flat%>%
           filter(index >=tray_splits[i]& index<tray_splits[(i+1)])
  )
}

tray_splits

tray_list = Filter(function(x) nrow(x)>0, mget(ls(pattern = "tray[0-9]")))


tray_list


for (i in 1:length(tray_list)){
  
  tray_list[[i]]%<>%
    mutate(tray_num = c(.$x2[1]))%>%
    filter(tray_split!=1)
}



reduce(tray_list, full_join)->minus80_flat2

minus80_flat2%>%
  rename(box_position = x1, rack1_left = x2, rack2 = x3, rack3 = x4, rack4 = x5, rack5_right = x6)%>%
  select(-c(shelf_split:index))%>%
  pivot_longer(cols = 2:6, names_to = "rack_num", values_to = "box_name")%>%
  relocate(shelf_num, rack_num, tray_num, box_position)->minus80long





minus80long%>%
  rename(shelf = shelf_num, rack = rack_num, tray = tray_num)%>%
  mutate(shelf = ifelse(shelf == "First Shelf (Top)", "shelf 1 (top)",
                        ifelse(shelf == "Second Shelf", "shelf 2", 
                               ifelse(shelf == "Third Shelf", "shelf 3", 
                                      ifelse(shelf == "Fourth Shelf (Bottom)", "shelf 4 (bottom)", NA)))))%>%
  
  
  mutate(rack = ifelse(rack == "rack1_left", "rack 1 (left)", 
                       ifelse(rack == "rack2", "rack 2", 
                              ifelse(rack == "rack3", "rack 3",
                                     ifelse(rack == "rack4", "rack 4",
                                            ifelse(rack == "rack5_right", "rack 5 (right)",
                                                   NA))))))%>%
  mutate(tray = tolower(tray))%>%
  mutate(box_position = tolower(box_position))%>%
  arrange(shelf, rack, tray, box_position)%>%
  mutate(box_name = ifelse(grepl("^no$", box_name), NA, box_name))->minus80clean




saveRDS(minus80clean, "minus80.rds")




LETTERS[1:9]->row

row
column<-c(1:9)

tibble(row = row, column = column)%>%
  expand(row, column)%>%
  mutate(coordinate = paste0(row,column))->freezer_box


minus80clean%>%
  mutate(box = paste0(shelf, rack, tray, box_position))%>%
  expand(box, coordinate = freezer_box$coordinate)->minus80all_boxs



minus80clean%>%
  mutate(box = paste0(shelf, rack, tray, box_position))%>%
  left_join(minus80all_boxs)%>%
  left_join(freezer_box)%>%
  select(-box, -row, -column)->minus80allvials


minus80allvials%>%
  mutate(contents = NA)->minus80_fulldoc

  gs4_create("minus 80", sheets = minus80_fulldoc)





  
