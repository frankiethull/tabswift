#' Swift Predictions
#'
#' @param fit a fitted model
#' @param data a dataset
#' @param type 'raw'
#' @param ... for passing parameters to the predict method
#'
#' @returns predictions
#'
#' @export
swift_predict <- \(fit, data, type = 'raw', ...) {
  if(type == 'raw'){
    predictions <- fit$predict(data, ...)
  } else {
    stop("type must be 'raw'")
  }
  return(predictions)
}
