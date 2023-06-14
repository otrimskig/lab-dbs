library(tidyverse)


path<-"X:/Holmen Lab/Databases/LIQUID NITROGEN - Holmen Lab.xls"


# load readxl package
library(readxl)

# specify the path to the Excel document
excel_file <- path

# get a list of all sheets in the Excel document
sheet_names <- excel_sheets(excel_file)

# loop through each sheet, import it and save it as an object
for (sheet_name in sheet_names) {
  # import the sheet using read_excel function
  sheet_data <- read_excel(excel_file, sheet = sheet_name)
  
  # save the sheet as an object based on the sheet name
  assign(sheet_name, sheet_data)
}








# where key_column is the column that uniquely identifies the rows in each object










