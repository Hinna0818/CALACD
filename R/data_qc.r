#' qc_subset: Subset wear and calibration data based on QC flags
#' @references QC standard reference(DOI: 10.1161/CIRCULATIONAHA.122.059663)
#'
#' @param wear_data A data.frame or data.table containing wear quality information.
#' @param calibration_data A data.frame or data.table containing calibration quality information.
#' @param ID_column Integer. The column index that contains participant IDs (default = 1).
#' @param wear_column Integer. The column index in wear_data used to filter for good wear time (default = 2).
#' @param calibration_column Integer. The column index in calibration_data used to filter for good calibration (default = 2).
#' @param duration_day_column Integer. The column index in wear_data that contains the wear duration in days (default = 10).
#' @param min_hours Numeric. The minimum wear time in hours required for inclusion (default = 72).
#'
#' @return A list containing:
#'   - wear_data_subset: Subset of wear_data with valid IDs
#'   - calibration_data_subset: Subset of calibration_data with valid IDs
#'   - sub_id: Vector of participant IDs who passed both QC filters
#'
#' @examples
#' result <- qc_subset(wear_qc, calib_qc)
#' valid_ids <- result$sub_id
#'
qc_subset <- function(
  wear_data, 
  calibration_data,
  ID_column = 1,
  wear_column = 2,
  calibration_column = 2,
  duration_day_column = 10,
  min_hours = 72
) {

  ## convert hours threshold to days threshold
  min_days <- min_hours / 24

  # Subset wear data where the wear quality flag is 1 (good)
  wear_subset <- subset(wear_data, wear_data[, wear_column] == 1)

  # subset wear data to only include participants with sufficient wear time (72h == 3days)
  wear_subset <- subset(
    wear_subset,
    !is.na(wear_subset[[duration_day_column]]) &
    as.numeric(wear_subset[[duration_day_column]]) >= min_days
  )

  # Subset calibration data where the calibration quality flag is 1 (good)
  calibration_subset <- subset(calibration_data, calibration_data[, calibration_column] == 1)
  
  # Find overlapping participant IDs that are valid in both datasets
  sub_population <- intersect(wear_subset[, ID_column], calibration_subset[, ID_column])
  
  # Subset the original wear and calibration data using the valid IDs
  wear_data_subset <- wear_data[wear_data[[ID_column]] %in% sub_population, ]
  calibration_data_subset <- calibration_data[calibration_data[[ID_column]] %in% sub_population, ]
  
  # Return results as a list
  return(list(
    wear_data_subset = wear_data_subset,
    calibration_data_subset = calibration_data_subset,
    sub_id = sub_population
  ))
}
