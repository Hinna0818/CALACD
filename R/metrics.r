#' Calculate Daily LPA, MPA, and VPA Minutes from Hourly Acceleration Data
#'
#' This function calculates the estimated daily minutes spent in 
#' Light Physical Activity (LPA), Moderate Physical Activity (MPA), 
#' and Vigorous Physical Activity (VPA) based on hourly average 
#' acceleration data in one week. The classification follows intensity thresholds:
#' - LPA: 30–125 mg
#' - MPA: >125–400 mg
#' - VPA: >400 mg
#'
#' @param acc_data A data frame containing hourly average acceleration 
#' values for each participant, along with their ID.
#' @param hour_start_column Integer. The starting column index 
#' of the hourly average acceleration values (default is 4).
#' @param hour_end_column Integer. The ending column index of the 
#' hourly average acceleration values (default is 27).
#' @param id_column Integer. The column index of the participant ID (default is 1).
#'
#' @return A data frame with one row per participant and the following columns:
#' @export
calculate_pa_intensity <- function(
    acc_data, 
    hour_start_column = 4, 
    hour_end_column = 27, 
    id_column = 1) {

  # get continuous 24h acc data
  acc_matrix <- as.matrix(acc_data[, hour_start_column:hour_end_column])
  
  # initialize counts matrix
  lpa_minutes <- matrix(0, nrow = nrow(acc_matrix), ncol = 1)
  mpa_minutes <- matrix(0, nrow = nrow(acc_matrix), ncol = 1)
  vpa_minutes <- matrix(0, nrow = nrow(acc_matrix), ncol = 1)

  # set LPA, MPA, and VPA thresholds
  lpa_minutes <- rowSums(acc_matrix >= 30 & acc_matrix <= 125) * 60 * 7
  mpa_minutes <- rowSums(acc_matrix > 125 & acc_matrix <= 400) * 60 * 7
  vpa_minutes <- rowSums(acc_matrix > 400) * 60 * 7

  # merge results
  result <- data.frame(
    participant_id = acc_data[id_column],
    LPA_minutes_per_week = lpa_minutes,
    MPA_minutes_per_week = mpa_minutes,
    VPA_minutes_per_week = vpa_minutes
  )

  return(result)
}
