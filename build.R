
# Package infos -----------------------------------------------------------

package_name <- devtools::as.package(".")$package

# Manage renv cache -------------------------------------------------------

# renv_cache <- here::here("renv/cache")
renv_cache <- "renv/cache"
dir.create(renv_cache, recursive = TRUE, showWarnings = FALSE)

Sys.setenv(RENV_PATHS_CACHE = normalizePath(renv_cache))
# Sys.getenv("RENV_PATHS_CACHE")

reinstall_deps <- as.logical(Sys.getenv("RENV_REINSTALL_DEPENDENCIES", FALSE))

# Install dependencies ----------------------------------------------------

if (reinstall_deps) {
  # Dev packages ignored in snapshots:
  renv::install("devtools")
  # renv::install("reprex")
  renv::install("here")
  # renv::install("usethis")

  # Actual dependencies:
  usethis::use_package("magrittr")

  renv::install("config")
  usethis::use_package("config")

  renv::install("lifecycle")
  usethis::use_package("lifecycle")

  renv::install("fs")
  usethis::use_package("fs")

  renv::install("stringr")
  usethis::use_package("stringr")

  # Try to get rid of these:
  usethis::use_package("here")
}

renv::settings$ignored.packages(c(
  # "devtools",
  "here",
  "usethis",
  "roxygen2",
  "testthat"
))
# renv::settings$ignored.packages()

# Build -------------------------------------------------------------------

dir.create("renv/local", recursive = TRUE, showWarnings = FALSE)
usethis::use_build_ignore(c("data", "renv"))
devtools::document()
devtools::build(path = "./renv/local")
# install.packages(paste0(package_name, ".tar.gz"), repos = NULL, type="source")
# renv::install(list.files(pattern = paste0(package_name, ".*\\.tar\\.gz")))

# Create snapshot ---------------------------------------------------------

renv::snapshot(confirm = FALSE)

file <- "renv.lock"
renv_lock_hash_current <- digest::digest(readLines(file))

# Copy snapshot to cache builder dir --------------------------------------

file <- "../cache_builder/renv.lock"
renv_lock_hash_cached <- if (file.exists(file)) {
  digest::digest(readLines(file))
} else {
  ""
}

if (renv_lock_hash_current != renv_lock_hash_cached) {
  message("Updating cached renv.lock")
  fs::file_copy("renv.lock", "../cache_builder/renv.lock", overwrite = TRUE)
  fs::dir_create("../cache_builder/renv")
  fs::file_copy("renv/activate.R", "../cache_builder/renv/activate.R", overwrite = TRUE)
  fs::file_copy("renv/settings.dcf", "../cache_builder/renv/settings.dcf", overwrite = TRUE)
  fs::dir_copy("renv/local", "../cache_builder/renv/local", overwrite = TRUE)
} else {
  message("Cached renv.lock up to date")
}

package_record <- list(list(
  Package = package_name,
  Version = devtools::as.package(".")$version,
  Source = "Filesystem"
))
names(package_record) <- package_name
renv::record(package_record)

# Preps for Docker --------------------------------------------------------

dir.create("renv/cache_docker", recursive = TRUE, showWarnings = FALSE)
