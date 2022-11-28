library(tidyverse)
library(readxl)
library(here)
library(janitor)
library(tidyselect)
library(stringr)


data_2015 <- read_xlsx(here("raw_data/boing-boing-candy-2015.xlsx")) %>% 
  clean_names() %>% 
  select(where(~!all(is.na(.x)))) %>% 
  rename(age = how_old_are_you,
         going_out = are_you_going_actually_going_trick_or_treating_yourself,
         box_raisins = box_o_raisins,
         hersheys_kissables = hershey_s_kissables,
         hersheys_milk_chocolate = hershey_s_milk_chocolate,
         hersheys_dark_chocolate = dark_chocolate_hershey,
         jolly_ranchers_bad_flavor = jolly_rancher_bad_flavor,
         reeses_peanut_butter_cups = reese_s_peanut_butter_cups,
         mms_peanut = peanut_m_m_s,
         mms_regular = regular_m_ms,
         mms_mint = mint_m_ms) %>% 
  relocate(c(sea_salt_flavored_stuff_probably_chocolate_since_this_is_the_it_flavor_of_the_year,
             necco_wafers), .after = york_peppermint_patties) %>% 
  select(-(please_leave_any_remarks_or_comments_regarding_your_choices:last_col()), -timestamp)

data_2016 <- read_xlsx(here("raw_data/boing-boing-candy-2016.xlsx")) %>% 
  clean_names() %>% 
  select(where(~!all(is.na(.x)))) %>% 
  rename(going_out = are_you_going_actually_going_trick_or_treating_yourself,
         gender = your_gender,
         age = how_old_are_you,
         country = which_country_do_you_live_in,
         region = which_state_province_county_do_you_live_in,
         box_raisins = boxo_raisins,
         hersheys_milk_chocolate = hershey_s_milk_chocolate,
         jolly_ranchers_bad_flavor = jolly_rancher_bad_flavor,
         licorice = licorice_yes_black,
         mms_regular = regular_m_ms,
         mms_peanut = peanut_m_m_s,
         mms_blue = blue_m_ms,
         mms_red = red_m_ms,
         mms_third_party = third_party_m_ms,
         reeses_peanut_butter_cups = reese_s_peanut_butter_cups,
         sourpatch_kids = sourpatch_kids_i_e_abominations_of_nature,
         sweetums = sweetums_a_friend_to_diabetes) %>% 
  select(-(please_list_any_items_not_included_above_that_give_you_joy:last_col()), -timestamp)

bound_table_1516 <- data_2015 %>% 
  bind_rows(data_2016) %>% 
  relocate(going_out) %>% 
  relocate(c(gender, country, region), .after = age) %>% 
  select(1:5, sort(peek_vars()))
  
data_2017 <- read_xlsx(here("raw_data/boing-boing-candy-2017.xlsx")) %>% 
  clean_names() %>% 
  select(where(~!all(is.na(.x))))
  
