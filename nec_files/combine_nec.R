library(tidyverse)
library(janitor)

# df <- list.files(path = "nec_recent/") %>%
#   map(readRDS) %>% 
#   bind_rows()



readRDS("nec_recent/27983-2022.rds")->sample


list.files(path="nec_recent/")->files




for(i in 1:length(files)){suppressWarnings(
  
  readRDS(paste0("nec_recent/",files[i]))%>%
  
  clean_names()%>%

  rename(col1 = 1, col2 = 2)%>%
  unite(col2, c(2:last_col()), na.rm = TRUE)%>%
  mutate(col2 =trimws(col2))%>%
  replace_na(list(col1 = 'NA_value', col2 = 'NA_value'))%>%
  mutate_all(function(x){sub("^$", "NA_value", x)})%>%
  
  select(1,2)%>%
  data.frame()%>%
  t()%>%
  as_tibble()%>%
  
  row_to_names(1)%>%
  clean_names()%>%
  mutate_all(as.character)%>%
  saveRDS(paste0("nec_recent2/",files[i]))
)
}



list.files(path="nec_recent2/")%>%
  paste0("nec_recent2/",.)%>%
  map_dfr(readRDS)->flattened

saveRDS(flattened, "all_recent_necs.rds")
