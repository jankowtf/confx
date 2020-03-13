#' Load configs into options \lifecycle{experimental}
#'
#' TODO-20191026-2: Write doc for `conf_load()`
#'
#' @param dir [[character]]
#'
#' @return  [[list]]
#'
#' @export
conf_load <- function(
  # dir = here::here(),
  dir = Sys.getenv("R_CONFIG_DIR", getwd()),
  pattern_disregard = "^(_|\\.|codecov|travis)"
) {
  config_files <- fs::dir_ls(dir, type = "file", regexp = "\\.yml$")

  # Filter out special configs such as for TravisCI and `{covr}`:
  idx <- config_files %>%
    fs::path_file() %>%
    stringr::str_detect(pattern_disregard, negate = TRUE)
  config_files <- config_files[idx]

  # Read config file content and put it into an actual option:
  config_files %>%
    purrr::walk(conf_load_from_file)

  config_files
}

#' Load all configs in a directory into options \lifecycle{experimental}
#'
#' - Lists all files in a given `dir`
#' - Greps for files with extension as defined/returned by
#' `.SYS_VALID_CONF_EXTENSIONS()` while disregarding extensions as
#' defined/returned by `.SYS_DISREGARDED_FILE_EXTENSIONS()``
#' - Maps `conf_load_from_file()` to those grep results
#'
#' TODO-20191026-2: Write doc for `conf_load_from_dir()`
#'
#' @param dir [[character]]
#'
#' @return  [[list]]
#'
#' @seealso [conf::conf_load_from_file()]
#' @export
conf_load_from_dir <- function(
  # dir = here::here(),
  dir = getwd(),
  regexp_valid_files = SYS_VALID_CONF_EXTENSIONS(as_regexp = TRUE),
  regexp_disregarded_files = SYS_DISREGARDED_CONF_FILES(as_regexp = TRUE)
) {
  # List all config files in dir:
  conf_files <- fs::dir_ls(dir, type = "file", regexp = regexp_valid_files,
    all = TRUE)

  # Filter out special configs such as for TravisCI and `{covr}`:
  idx <- conf_files %>%
    fs::path_file() %>%
    stringr::str_detect(regexp_disregarded_files, negate = TRUE)
  conf_files <- conf_files[idx]

  # Read config file content and put it into an actual option:
  conf_files %>%
    purrr::walk(conf_load_from_file)

  conf_files
}

conf_load_from_file <- function(
  file,
  sep_opt_name = "_",
  verbose = TRUE
) {
  if (verbose) {
    message(stringr::str_glue(
      "Loading configs into options: {fs::path_file(file)}"))
  }
  pkg <- devtools::as.package(".")$package
  # opt_name <- fs::path_file(.file)
  opt_name <- stringr::str_glue("{pkg}{sep_opt_name}{fs::path_file(file)}")
  # print(opt_name)
  arg_list <- list(config::get(file = file)) %>%
    purrr::set_names(opt_name)
  rlang::call2(quote(options), !!!arg_list) %>%
    rlang::eval_tidy()
}
