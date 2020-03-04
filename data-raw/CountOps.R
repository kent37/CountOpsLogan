# Read and prepare CountOps data

library(dplyr)
library(lubridate)
co_path = here::here('data-raw')

#' Read original CountOps files, do some basic cleaning and
#' summarizing, and save the results to files.
source(file.path(co_path, 'EquipmentTypes.R'))

co_files = list.files(co_path, 'CountOps_flts_BOS', full.names=TRUE)

# Read files, basic munging
co_raw = vroom::vroom(co_files) %>%
  filter(LOCID=='BOS', operation_type != 'Overflight') %>%
  mutate(Date=ymd(LCL_YYYYMMDD),
         Year=year(Date)) %>%
  rename(Hour=HR_LCL, Operation=operation_type,
         Count=operations) %>%
  select(-LCL_YYYYMMDD, -LOCID)

# Add columns for equipment category and jet
countops_detail = co_raw %>%
  mutate(Category = equip_category(Equipment),
         Jet=!Category %in% c('GA', 'Helo', 'Unknown', 'Regional prop')) %>%
  select(Year, Date, Hour, Runway, Operation,
         Equipment, Count, Category, Jet)

vroom::vroom_write(countops_detail,
                   file.path(co_path, 'countops.tsv'))
usethis::use_data(countops_detail, overwrite=TRUE)

# Hourly summary
countops_hourly = countops_detail %>%
  group_by(Year, Date, Hour, Runway, Operation, Category, Jet) %>%
  summarize(Count=sum(Count))
countops_hourly = countops_hourly %>%
  mutate(Month=floor_date(Date, unit='months'))
countops_hourly = countops_hourly %>%
  select(Year, Date, Month, Hour, Runway, Operation,
         Category, Count, Jet)

vroom::vroom_write(countops_hourly,
            file.path(co_path, 'countops_hourly.tsv'))
usethis::use_data(countops_hourly, overwrite=TRUE)

# Hourly counts jets only
countops_hourly_jets = countops_hourly %>%
  filter(Jet) %>%
  group_by(Year, Date, Month, Hour, Runway, Operation) %>%
  summarize(Count=sum(Count))

vroom::vroom_write(countops_hourly_jets,
        file.path(co_path, 'countops_hourly_jets.tsv'))
usethis::use_data(countops_hourly_jets, overwrite=TRUE)
