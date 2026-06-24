#' @keywords internal
download_tabswift_weights <- function() {
  # Initialize HF hub manager natively
  hf_hub <- reticulate::import("huggingface_hub")
    
  # Downloads the file and returns its absolute path string
  model_file_path <- hf_hub$hf_hub_download(
    repo_id = "LAMDA-Tabular/TabSwift",
    filename = "swift.ckpt"
  )
  
  return(model_file_path)
}

#' Fit TabSwift Tabular Foundation Model
#'
#' @param X training data matrix or data.frame of features
#' @param y training labels vector
#' @param problem_type either "classification" or "regression"
#' @param ... additional hyperparameters passed down to TabSwift
#'
#' @return A fitted TabSwift model instance
#' @export
swift_fit <- function(X, y, problem_type = "classification", ...) {
  
  # Download check points right before initialization
  chkpt_path <- download_tabswift_weights()
  
  if (problem_type == "classification") {
    cls_module <- tabswift:::.pkg_env$classifier$TabSwiftClassifier(
      model_path = chkpt_path, 
      ...
    )
    fit <- cls_module$fit(X, y)
    
  } else if (problem_type == "regression") {
    reg_module <- tabswift:::.pkg_env$regressor$TabSwiftRegressor(
      model_path = chkpt_path, 
      ...
    )
    fit <- reg_module$fit(X, y)
    
  } else {
    stop("problem_type must be 'classification' or 'regression'")
  }
  
  return(fit)
}