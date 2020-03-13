load_conf <- function(
  # dir = here::here(),
  # from = here::here(),
  from = getwd(),
  pattern_disregard = "^(_|\\.|codecov|travis)"
) {
  .Deprecated("conf_load")
  conf_files <- fs::dir_ls(from, type = "file", regexp = "\\.yml$")

  # Filter out special configs such as for TravisCI and `{covr}`:
  idx <- conf_files %>%
    fs::path_file() %>%
    stringr::str_detect(pattern_disregard, negate = TRUE)
  conf_files <- conf_files[idx]

  # Read config file content and put it into an actual option:
  conf_files %>%
    purrr::walk(conf_load__inner)

  conf_files
}

conf_load__inner <- function(
  .file,
  .sep_opt_name = "_",
  .verbose = TRUE
) {
  .Deprecated("conf_load_from_file")
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
