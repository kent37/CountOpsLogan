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
  mutate(Date=ymd(LCL_YYYYMMDD)) %>%
  rename(Hour=HR_LCL, Operation=operation_type,
         Count=operations) %>%
  select(-LCL_YYYYMMDD, -LOCID)

# Add columns for equipment categories
countops_detail = co_raw %>%
  mutate(Category=equip_category(Equipment),
         Jet=!Category %in% c('GA', 'Helo', 'Other', 'Regional prop'))

# vroom::vroom_write(countops_detail,
#                    file.path(co_path, 'countops.tsv'))
usethis::use_data(countops_detail)

# Hourly summary
countops_hourly = countops_detail %>%
  group_by(Date, Hour, Runway, Operation, Category, Jet) %>%
  summarize(Count=sum(Count)) %>%
  mutate(Month=floor_date(Date, unit='months'))

# vroom::vroom_write(countops_hourly,
#             file.path(co_path, 'countops_hourly.tsv'))
usethis::use_data(countops_hourly)

# Hourly jets only
countops_hourly_jets = countops_hourly %>%
  filter(Jet) %>%
  group_by(Date, Month, Hour, Runway, Operation) %>%
  summarize(Count=sum(Count))

# vroom::vroom_write(countops_hourly_jets,
#         file.path(co_path, 'countops_hourly_jets.tsv'))
usethis::use_data(countops_hourly_jets)
