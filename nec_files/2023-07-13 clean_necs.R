library(tidyverse)
library(janitor)
library(fs)
library(lubridate)


readRDS("all_recent_necs.rds")->recent_necs




recent_necs2<-
  recent_necs%>%
  

  
  
  mutate(todays_date_original = todays_date)%>%
  mutate(todays_date = openxlsx::convertToDate(todays_date))%>%
  
  mutate(sac_date_original = sac_date)%>%
  mutate(sac_date = openxlsx::convertToDate(sac_date))%>%
  
  
  mutate(injection_date_original = injection_date)%>%
  mutate(injection_date = openxlsx::convertToDate(injection_date))
  
  
  
recent_necs3<-
  recent_necs2%>%
  
  mutate(across(1:last_col(), function(x){gsub("NA_value",NA, x)}))%>%
  
  select(where(function(x) any(!is.na(x))))%>%
  
  relocate(initials, todays_date, mouse_id, sex, bd)%>%
  
  
  mutate(sex = gsub("_", "", sex))%>%
  mutate(sex = gsub("`", "", sex))%>%
  mutate(sex = toupper(substr(sex, 1,1)))%>%
  
  
  mutate(bd = gsub("_", "", bd))%>%
  mutate(bd = gsub("`", "", bd))%>%
  
  mutate(bd = openxlsx::convertToDate(bd))%>%
  
  relocate(strain, .after = "sex")%>%
  relocate(sac_date, .after = "bd")%>%
  relocate(genotype, .after="strain")
  
  
recent_necs4<-
  recent_necs3%>%
  clean_names()%>%
  rename(date_of_first_treatment2 = date_of_first_treatrment)%>%
  
  
  
  unite(date_of_first_treatment, c(date_of_first_treatment, date_of_first_treatment2), na.rm=TRUE)%>%
  
  mutate(date_of_first_treatment = gsub("_", "", date_of_first_treatment))%>%
  mutate(date_of_first_treatment = gsub("`", "", date_of_first_treatment))%>%
  
  mutate(date_of_first_treatment=openxlsx::convertToDate(date_of_first_treatment))%>%
  
  
  unite(disposition_notes, c(disposition, disposition_2, disposition_3, 
                             disposition_4, additional_comments, na_value_2, na_value_3,
                             na_value_4, na_value_5, na_value_6, na_value_7),
        sep = "; ", na.rm = TRUE)%>%
  
  
  mutate(start_of_treatment = openxlsx::convertToDate(start_of_treatment))%>%
  
  mutate(date_tumor_reported_original = date_tumor_reported)%>%
  
  mutate(date_tumor_reported = if_else(nchar(date_tumor_reported)==5, 
                                       as.character(openxlsx::convertToDate(date_tumor_reported)),
                                       date_tumor_reported))%>%
  arrange(desc(todays_date))
  
  


write_csv(recent_necs4, "recent_necs4.csv", na="")
  
