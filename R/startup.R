.onLoad <- function(libname, pkgname) {
  options(digits.secs = 3)
  Sys.setenv(TZ = "UTC")
  Sys.setenv(language = "en")

  invisible(TRUE)
}

.onAttach <- function(libname, pkgname) {
  # Load internal configs:
  # conf_auto_load_internal(pgkname)

  # Load project-based configs:
  # conf_auto_load()

  # For plumber testing:
  # .__STATE__ <<- new.env(parent = emptyenv()) #create .state when package is first loaded

  invisible(TRUE)
}
