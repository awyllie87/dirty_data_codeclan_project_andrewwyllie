library(tidyverse)
library(readxl)
library(here)
library(janitor)
library(lubridate)

# Import sheet, define column classes to stop corruption on import, fix time column
ships <- read_xls(here("raw_data/seabirds.xls"),sheet = 1,
                  col_types = c("text", "text", "date", 
                                # time
                                "date", "numeric", "numeric",
                                # ew
                                "text", "text", "numeric",
                                # sdir
                                "text", "text", "text",
                                # wspeed
                                "text", "text", "numeric",
                                #aprs
                                "text", "text", "numeric",
                                #sal
                                "text", "numeric", "text",
                                #csmeth
                                "text", "text", "text",
                                #long360
                                "numeric", "numeric", "numeric")) %>% 
  clean_names() %>% 
  rename("season" = "seasn") %>% 
  mutate(time = format(ymd_hms(time), "%H:%M"))
