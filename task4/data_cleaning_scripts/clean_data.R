library(tidyverse)
library(readxl)
library(here)
library(janitor)
library(tidyselect)
library(stringr)
library(lubridate)

data_2015_clean <- read_xlsx(here("raw_data/boing-boing-candy-2015.xlsx")) %>% 
  clean_names() %>% 
  remove_empty(which = "cols") %>% 
  mutate(year = format(ymd_hms(timestamp), "%Y")) %>% 
  relocate(year) %>% 
  select(-timestamp) %>% 
  rename(age = how_old_are_you,
         going_out = are_you_going_actually_going_trick_or_treating_yourself,
         hersheys_kissables = hershey_s_kissables,
         hersheys_milk_chocolate = hershey_s_milk_chocolate,
         hersheys_dark_chocolate = dark_chocolate_hershey,
         jolly_ranchers_bad_flavor = jolly_rancher_bad_flavor,
         reeses_peanut_butter_cups = reese_s_peanut_butter_cups,
         licorice_yes_black = licorice,
         mms_peanut = peanut_m_m_s,
         mms_regular = regular_m_ms,
         mms_mint = mint_m_ms,
         joy_other = please_list_any_items_not_included_above_that_give_you_joy,
         despair_other = please_list_any_items_not_included_above_that_give_you_despair,
         dress = that_dress_that_went_viral_early_this_year_when_i_first_saw_it_it_was,
         other_comments = please_leave_any_remarks_or_comments_regarding_your_choices,
         day = which_day_do_you_prefer_friday_or_sunday) %>% 
  relocate(c(sea_salt_flavored_stuff_probably_chocolate_since_this_is_the_it_flavor_of_the_year,
             necco_wafers), .after = york_peppermint_patties)

data_2016_clean <- read_xlsx(here("raw_data/boing-boing-candy-2016.xlsx")) %>% 
  clean_names() %>% 
  remove_empty(which = "cols") %>% 
  mutate(year = format(ymd_hms(timestamp), "%Y")) %>% 
  relocate(year) %>% 
  select(-timestamp) %>% 
  rename(going_out = are_you_going_actually_going_trick_or_treating_yourself,
         gender = your_gender,
         age = how_old_are_you,
         country = which_country_do_you_live_in,
         region = which_state_province_county_do_you_live_in,
         box_o_raisins = boxo_raisins,
         hersheys_milk_chocolate = hershey_s_milk_chocolate,
         jolly_ranchers_bad_flavor = jolly_rancher_bad_flavor,
         mms_regular = regular_m_ms,
         mms_peanut = peanut_m_m_s,
         mms_blue = blue_m_ms,
         mms_red = red_m_ms,
         mms_third_party = third_party_m_ms,
         reeses_peanut_butter_cups = reese_s_peanut_butter_cups,
         sourpatch_kids = sourpatch_kids_i_e_abominations_of_nature,
         sweetums = sweetums_a_friend_to_diabetes,
         joy_other = please_list_any_items_not_included_above_that_give_you_joy,
         despair_other = please_list_any_items_not_included_above_that_give_you_despair,
         dress = that_dress_that_went_viral_a_few_years_back_when_i_first_saw_it_it_was,
         other_comments = please_leave_any_witty_snarky_or_thoughtful_remarks_or_comments_regarding_your_choices,
         day = which_day_do_you_prefer_friday_or_sunday)

bound_table_1516_clean <- data_2015_clean%>% 
  bind_rows(data_2016_clean) %>% 
  relocate(going_out, .after = year) %>% 
  relocate(c(gender, country, region), .after = age) %>% 
  relocate(bonkers_the_candy:whatchamacallit_bars, .after = necco_wafers)

data_2017_clean <- read_xlsx(here("raw_data/boing-boing-candy-2017.xlsx")) %>% 
  clean_names() %>% 
  remove_empty(which = "cols") %>% 
  rename_with(~str_remove(., "^[a-z0-9]+\\_")) %>% 
  select(-x114) %>% 
  slice(-1) %>% 
  rename(region = state_province_county_etc,
         anonymous_brown_globs_that_come_in_black_and_orange_wrappers = 
           anonymous_brown_globs_that_come_in_black_and_orange_wrappers_a_k_a_mary_janes,
         x100_grand_bar = `100_grand_bar`,
         box_o_raisins = boxo_raisins,
         hersheys_milk_chocolate = hershey_s_milk_chocolate,
         jolly_ranchers_bad_flavor = jolly_rancher_bad_flavor,
         mms_regular = regular_m_ms,
         mms_peanut = peanut_m_m_s,
         mms_blue = blue_m_ms,
         mms_red = red_m_ms,
         mms_green_party = green_party_m_ms,
         mms_independent = independent_m_ms,
         mms_abstained = abstained_from_m_ming,
         reeses_peanut_butter_cups = reese_s_peanut_butter_cups,
         sourpatch_kids = sourpatch_kids_i_e_abominations_of_nature,
         sweetums = sweetums_a_friend_to_diabetes)

full_bind_clean <- bound_table_1516_clean %>% 
  bind_rows(data_2017_clean) %>% 
  select(-id) %>% 
  relocate(mms_green_party:take_5, .after = whatchamacallit_bars) %>% 
  mutate(year = coalesce(year, "2017")) %>% 
  select(year:region, other_comments:coordinates_x_y, sort(peek_vars())) %>% 
  relocate(other_comments:coordinates_x_y, .after = york_peppermint_patties)

full_bind_simple <- full_bind_clean %>% 
  # Remove non-candy "candies"
  select(-c(bonkers_the_board_game,
            bottle_caps,
            broken_glow_stick,
            cash_or_other_forms_of_legal_tender,
            chardonnay,
            creepy_religious_comics_chick_tracts,
            dental_paraphenalia,
            generic_brand_acetaminophen,
            glow_sticks,
            hugs_actual_physical_hugs,
            kale_smoothie,
            lapel_pins,
            mint_juleps,
            mint_leaves,
            peanut_butter_jars,
            pencils,
            person_of_interest_season_3_dvd_box_set_not_including_disc_4_with_hilarious_outtakes,
            peterson_brand_sidewalk_chalk,
            real_housewives_of_orange_county_season_9_blue_ray,
            sandwich_sized_bags_filled_with_boo_berry_crunch,
            spotted_dick,
            vials_of_pure_high_fructose_corn_syrup_for_main_lining_into_your_vein,
            vicodin,
            white_bread,
            whole_wheat_anything),
         -c(other_comments:coordinates_x_y))

full_bind_clean %>% 
  write.csv(file = here("clean_data/halloween.csv"), row.names = FALSE)

full_bind_simple %>% 
  write.csv(file = here("clean_data/halloween_simplified.csv"), row.names = FALSE)

rm(bound_table_1516_clean, data_2015_clean, data_2016_clean, data_2017_clean,
   full_bind_clean, full_bind_simple)
