library(tidyverse)
library(readxl)
library(here)
library(janitor)

data_2015 <- read_xlsx(here("raw_data/boing-boing-candy-2015.xlsx")) %>% 
  clean_names()
data_2016 <- read_xlsx(here("raw_data/boing-boing-candy-2016.xlsx")) %>% 
  clean_names()
data_2017 <- read_xlsx(here("raw_data/boing-boing-candy-2017.xlsx")) %>% 
  clean_names()

bound_table_1516 <- data_2015 %>% 
  bind_rows(data_2016) %>% 
  select(!where(~all(is.na(.x))))

