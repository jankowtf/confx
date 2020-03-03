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
  dir = getwd(),
  pattern_disregard = "^(_|\\.|codecov|travis)"
) {
  .Deprecated("load_conf")
  config_files <- fs::dir_ls(dir, type = "file", regexp = "\\.yml$")

  # Filter out special configs such as for TravisCI and `{covr}`:
  idx <- config_files %>%
    fs::path_file() %>%
    stringr::str_detect(pattern_disregard, negate = TRUE)
  config_files <- config_files[idx]

  # Read config file content and put it into an actual option:
  config_files %>%
    purrr::walk(conf_load__inner)

  config_files
}

conf_load__inner <- function(
  .file,
  .sep_opt_name = "_",
  .verbose = TRUE
) {
  .Deprecated("load_conf_from_file")
  if (.verbose) {
    message(stringr::str_glue(
      "Loading configs into options: {fs::path_file(.file)}"))
  }
  pkg <- devtools::as.package(".")$package
  # opt_name <- fs::path_file(.file)
  opt_name <- stringr::str_glue("{pkg}{.sep_opt_name}{fs::path_file(.file)}")
  # print(opt_name)
  arg_list <- list(config::get(file = .file)) %>%
    purrr::set_names(opt_name)
  rlang::call2(quote(options), !!!arg_list) %>%
    rlang::eval_tidy()
}
