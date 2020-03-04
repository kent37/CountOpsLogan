#' Detailed CountOps data.
#' @format A data.frame with 2,094,354 rows and columns
#' - Year, Date - Local year and date of the operation
#' - Hour - Hour of the day, 0-23
#' - Runway
#' - Operation - Arrival, Departure or Overflight
#' - Equipment - CountOps code for the type of aircraft
#' - Count - Number of operations
#' - Category - Wide body, single aisle, etc
#' - Jet - true / false
#' @source FAA CountOps data via FOIA request.
"countops_detail"

#' CountOps data summarized by hour, runway and equipment category.
#' @format A data.frame with 908,613 rows and columns
#' - Year, Date - Local year and date of the operation
#' - Month - Date of the first of the month containing the event
#' - Hour - Hour of the day, 0-23
#' - Runway
#' - Operation - Arrival, Departure or Overflight
#' - Category - Wide body, single aisle, etc
#' - Count - Number of operations
#' - Jet - true / false
#' @source FAA CountOps data via FOIA request.
"countops_hourly"

#' CountOps data, jets only, summarized by hour and runway.
#' @format A data.frame with 263,490 rows and columns
#' - Year, Date - Local year and date of the operation
#' - Month - Date of the first of the month containing the event
#' - Hour - Hour of the day, 0-23
#' - Runway
#' - Operation - Arrival, Departure or Overflight
#' - Count - Number of operations
#' @source FAA CountOps data via FOIA request.
"countops_hourly_jets"
