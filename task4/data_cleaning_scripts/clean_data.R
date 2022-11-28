library(tidyverse)
library(readxl)
library(here)
library(janitor)

what <- read_xlsx(here("raw_data/boing-boing-candy-2015.xlsx")) %>% 
  clean_names()
is_even <- read_xlsx(here("raw_data/boing-boing-candy-2016.xlsx")) %>% 
  clean_names()
happening <- read_xlsx(here("raw_data/boing-boing-candy-2017.xlsx")) %>% 
  clean_names()

