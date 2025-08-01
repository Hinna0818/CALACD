#' Calculate M10, L5, and Relative Amplitude (RA) for Each Individual
#'
#' This function processes 24-hour accelerometer data for multiple individuals
#' and calculates rest-activity rhythm metrics: M10 (most active 10-hour average),
#' L5 (least active 5-hour average), and RA (relative amplitude).
#'
#' @param df A data.frame containing individual ID and 24-hour activity data.
#' @param id_column The column index or name of the individual ID. Default is 1.
#' @param hour_prefix The prefix of column names containing hourly activity values. Default is "Average acceleration".
#'
#' @return A data.frame with columns: ID, M10, M10_start, L5, L5_start, RA.
#' @export
calculate_RA <- function(df, id_column = 1, hour_prefix = "Average acceleration") {
  
  # extract id
  ids <- df[[id_column]]
  hour_cols <- get_hour_columns(df, hour_prefix)

  # extract hour matrix
  hour_matrix <- as.matrix(df[, hour_cols])
  result_mat <- t(apply(hour_matrix, 1, calculate_M10_L5_RA))
  result_df <- data.frame(ID = ids, result_mat)
  return(result_df)
}


#' Get the Column Indexes of Hourly Acceleration Data
#'
#' Identifies 24 columns in a data.frame corresponding to hourly activity based on a common prefix.
#'
#' @param df The input data.frame.
#' @param hour_prefix Prefix string of the column names (e.g., "Average acceleration").
#'
#' @return A numeric vector of column indexes for the 24-hour activity columns.
#' @export
get_hour_columns <- function(df, hour_prefix = "Average acceleration") {
  hour_cols <- grep(paste0("^", hour_prefix), colnames(df))
  if (length(hour_cols) != 24) {
    stop("Can not find 24 hour columns with the format 'Average acceleration hh:mm - hh:mm'.")
  }
  return(hour_cols)
}


#' Calculate M10 and its Start Time
#'
#' Calculates the highest average activity level during the most active 10-hour window of a 24-hour period.
#'
#' @param activity_vec A numeric vector of 24 hourly activity values.
#'
#' @return A named numeric vector with M10 and M10_start (hour index 0–23).
#' @export
get_m10 <- function(activity_vec) {
  m10_vals <- numeric(15)
  for (i in 0:14) {
    idx <- (i:(i + 9)) %% 24 + 1
    m10_vals[i + 1] <- mean(activity_vec[idx])
  }
  M10 <- max(m10_vals)
  m10_start <- which.max(m10_vals) - 1
  return(c(M10 = M10, M10_start = m10_start))
}


#' Calculate L5 and its Start Time
#'
#' Calculates the lowest average activity level during the least active 5-hour window of a 24-hour period.
#'
#' @param activity_vec A numeric vector of 24 hourly activity values.
#'
#' @return A named numeric vector with L5 and L5_start (hour index 0–23).
#' @export
get_l5 <- function(activity_vec) {
  l5_vals <- numeric(20)
  for (i in 0:19) {
    idx <- (i:(i + 4)) %% 24 + 1
    l5_vals[i + 1] <- mean(activity_vec[idx])
  }
  L5 <- min(l5_vals)
  l5_start <- which.min(l5_vals) - 1
  return(c(L5 = L5, L5_start = l5_start))
}


#' Calculate M10, L5, and Relative Amplitude (RA) for One Individual
#' RA = (M10 - L5) / (M10 + L5)
#' Calculates the three core rest-activity rhythm metrics from hourly activity input.
#' @param activity_vec A numeric vector of 24 hourly activity values.
#'
#' @return A named numeric vector: M10, M10_start, L5, L5_start, RA.
#' @export

calculate_M10_L5_RA <- function(activity_vec) {
  m10_info <- get_m10(activity_vec)
  l5_info <- get_l5(activity_vec)
  RA <- if ((m10_info["M10"] + l5_info["L5"]) == 0) NA else 
    (m10_info["M10"] - l5_info["L5"]) / (m10_info["M10"] + l5_info["L5"])
  return(c(m10_info, l5_info, RA = RA))
}
