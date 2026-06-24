.pkg_env <- new.env()
.pkg_env$classifier <- NULL
.pkg_env$regressor <- NULL

.onLoad <- function(...) {
  # repo_dir <- paste0(here::here(), "/TabSwift")
  repo_dir <- paste0(system.file(package = "tabswift"), "/TabSwift")

  if (!dir.exists(repo_dir)) {
    system(paste("git clone https://github.com/LAMDA-Tabular/TabSwift.git", repo_dir))
  }

  reticulate::py_require(c("torch", "scikit-learn<1.6.0", "pandas", "numpy", "huggingface_hub"))
  
  lib_path <- paste0(repo_dir, "/TALENT/model/lib")

  # Define a delay_load list configuration with an explicit error logger
  debug_hook <- list(
    on_error = function(err) {
      cat("\n[REAL PYTHON ERROR CAUGHT]:\n")
      print(err)
      cat("\n")
    }
  )

  .pkg_env$classifier <- reticulate::import_from_path(
    "tabswift.classifier",
    path = lib_path,
    delay_load = debug_hook
  )

  .pkg_env$regressor <- reticulate::import_from_path(
    "tabswift.regressor",
    path = lib_path,
    delay_load = debug_hook
  )
}