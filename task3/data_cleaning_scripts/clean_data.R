library(tidyverse)
library(readxl)
library(here)
library(janitor)
library(lubridate)

# Import sheet, define column classes to stop corruption on import
# add an "o" to "seasn", get rid of the date added to the time column

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
                                # aprs
                                "text", "text", "numeric",
                                # sal
                                "text", "numeric", "text",
                                # csmeth
                                "text", "text", "text",
                                # long360
                                "numeric", "numeric", "numeric")) %>% 
  clean_names() %>% 
  rename("season" = "seasn") %>% 
  mutate(time = format(ymd_hms(time), "%H:%M")) %>% 
  # Cut this to what we actually need. Cut all ocean data.
  select(record_id, date, time, lat, long, obs, csmeth, season)

# Import sheet, define column classes to stop corruption on import
# rename a few columns for readability

birds <- read_xls(here("raw_data/seabirds.xls"), sheet = 2,
                  col_types = c("text", "text", "text",
                                # scientific name
                                "text", "text", "text",
                                # wan plum
                                "text", "text", "text",
                                # count
                                "numeric", "numeric", "text",
                                # nsow
                                "numeric", "text", "numeric",
                                # ocsoice
                                "text", "text", "text",
                                # nflyp
                                "numeric", "text", "numeric",
                                # ocacc
                                "text", "numeric", "text",
                                # ocmoult
                                "text", "text"
                                )) %>% 
  clean_names() %>% 
  rename("common_name" = "species_common_name_taxon_age_sex_plumage_phase",
         "scientific_name" = "species_scientific_name_taxon_age_sex_plumage_phase",
         "abbreviation" = "species_abbreviation") %>% 
  # Cut this to what we need.
  select(record_id, common_name, scientific_name, abbreviation, count)

# join tables, write clean file
left_join(birds, ships, "record_id") %>% 
  write.csv(file = here("clean_data/birds_clean.csv"), row.names = FALSE)

rm(birds, ships)