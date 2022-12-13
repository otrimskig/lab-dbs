

o1 <- read.csv("orders1.csv")
o2<- read.csv("orders2.csv")


o1<-o1%>%
  as_tibble()%>%
  clean_names()%>%
  rename(catalog = vwr_catalog)

o2<-o2%>%
  as_tibble()%>%
  clean_names()%>%
  slice(-1)%>%
  rename(catalog = x_3)


full_join(o1, o2, by = "catalog")%>%
  write.csv("storeroom.csv")


read.csv("storeroom.csv")%>%
  as_tibble()%>%
  filter(!is.na(row))%>%
  relocate(description_stockroom)%>%
  relocate(quantity)%>%
  write.csv(row.names = FALSE, "storeroom_price.csv")
  
