.onLoad <- function(libname, pkgname) {
  options(digits.secs = 3)
  Sys.setenv(TZ = "UTC")
  Sys.setenv(language = "en")

  # Load configs -----
  print(here::here())
  # load_configs()

  # For plumber testing -----
  # .__STATE__ <<- new.env(parent = emptyenv()) #create .state when package is first loaded

  invisible(TRUE)
}

.onAttach <- function(libname, pkgname) {
  # options(digits.secs = 3)
  # Sys.setenv(TZ = "UTC")
  # Sys.setenv(language = "en")

  # Load configs -----
  print(here::here())
  # load_configs()

  # For plumber testing -----
  # .__STATE__ <<- new.env(parent = emptyenv()) #create .state when package is first loaded

  invisible(TRUE)
}
