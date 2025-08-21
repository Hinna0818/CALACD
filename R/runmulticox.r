#' Run multiple Cox proportional hazards models for a list of main variables
#'
#' @param data A data frame containing all variables.
#' @param main_var A character vector of main variable names to test (as strings).
#' @param covariates A character vector of covariate names (as strings).
#' @param endpoint A character vector of length 2: c("time", "status"), indicating survival time and event.
#' @param ... Additional arguments passed to coxph()
#' 
#' @importFrom survival coxph
#' @return A data.frame summarizing results for each main variable.
#' 
runmulticox <- function(data, 
                        main_var,
                        covariates = NULL,
                        endpoint = c("time", "status"),
                        ...) {

  stopifnot(length(endpoint) == 2)
  
  results <- list()

  for (var in main_var) {
    # construct formula
    formula_str <- paste0("Surv(", endpoint[1], ", ", endpoint[2], ") ~ ", 
                          var,
                          if (!is.null(covariates)) paste0(" + ", paste(covariates, collapse = " + ")) else "")
    
    formula_obj <- as.formula(formula_str)

    # model
    model <- survival::coxph(formula_obj, data = data, ...)

    # extract model results
    sum_model <- summary(model)
    coefs <- sum_model$coefficients
    confint <- sum_model$conf.int
    main_row <- coefs[rownames(coefs) == var, , drop = FALSE]
    conf_row <- confint[rownames(confint) == var, , drop = FALSE]

    results[[var]] <- data.frame(
      variable = var,
      HR = round(conf_row[,"exp(coef)"], 3),
      lower95 = round(conf_row[,"lower .95"], 3),
      upper95 = round(conf_row[,"upper .95"], 3),
      pvalue = signif(main_row[,"Pr(>|z|)"], 3),
      stringsAsFactors = FALSE
    )
  }

  # res
  result_df <- do.call(rbind, results)
  rownames(result_df) <- NULL

  return(result_df)
}