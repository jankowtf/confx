.onLoad <- function(libname, pkgname) {
  options(digits.secs = 3)
  Sys.setenv(TZ = "UTC")
  Sys.setenv(language = "en")

  invisible(TRUE)
}

.onAttach <- function(libname, pkgname) {
  # Load configs -----
  env_auto_load <- as.logical(Sys.getenv("CONFX_AUTO_LOAD", FALSE))
  if (env_auto_load) {
    confx::load()
  }

  # For plumber testing -----
  # .__STATE__ <<- new.env(parent = emptyenv()) #create .state when package is first loaded

  invisible(TRUE)
}
