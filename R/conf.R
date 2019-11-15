#' Get config \lifecycle{experimental}
#'
#' TODO-20191026-1: Write doc for `conf_get()`
#'
#' @param value [[character]]
#' @param from [[character]]
#' @param dir_from [[character]]
#' @param sep [[character]]
#' @param sep_opt_name [[character]]
#' @param inheritance_handling [[logical]]
#' @param force_from_file [[logical]]
#'
#' @return [[list] or [character]]
#'
#' @export
conf_get <- function(
  value = character(),
  from = "config.yml",
  dir_from = here::here(),
  sep = "/",
  sep_opt_name = "_",
  inheritance_handling = TRUE,
  force_from_file = FALSE
) {
  # configs <- getOption(from)
  pkg_this <- devtools::as.package(dir_from)$package
  from_opts <- stringr::str_glue("{pkg_this}{sep_opt_name}{from}")
  configs <- getOption(from_opts)
  if (is.null(configs) || force_from_file) {
    configs <- config::get(file = fs::path(dir_from, from))
  }

  # Early exit:
  if (!length(value)) {
    return(configs)
  }

  configs <- conf_index_recursively(
    configs,
    stringr::str_split(value, sep, simplify = TRUE)
  )

  if (inheritance_handling) {
    conf_handle_inherited(configs, from = from, dir_from = dir_from)
    # TODO-20191024-3: Think about persisting handled inheritance entities in
    # memory/options
  } else {
    configs
  }
}

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
  dir = here::here(),
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
    purrr::walk(conf_load__inner)

  config_files
}

conf_load__inner <- function(
  .file,
  .sep_opt_name = "_",
  .verbose = TRUE
) {
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

#' Assign configs to local variables \lifecycle{experimental}
#'
#' TODO-20191026-3: Write doc for `conf_assign()`
#'
#' @param config_list [[list]]
#' @param env [[environment]]
#' @param from [[character]]
#' @param dir_from [[character]]
#' @param sep [[character]]
#'
#' @return [[list]]
#'
#' @export
conf_assign <- function(
  config_list,
  # env = rlang::env_parent()
  env = rlang::caller_env(),
  from = "config.yml",
  dir_from = here::here(),
  sep = "/"
) {
  if (!is.list(config_list)) {
    stop(stringr::str_glue("Not a valid config list in arg `config_list`: \n{capture.output(str(config_list))}"))
  }
  purrr::map2(names(config_list), config_list, function(.x, .y) {
    if (!is.list(.y)) {
      .y <- if (is.call(.y)) {
        rlang::eval_tidy(.y)
      } else if (is.character(.y)) {
        if (.y[[1]] %>% stringr::str_detect("/")) {
          # TODO-20191023-2: find better solution for vectorized input
          .y %>% purrr::map_chr(get_config, from = from, dir_from = dir_from, sep = sep)
        } else {
          .y
        }
      } else {
        stop("Unsupported value for .y")
      }
      .y <- if (length(.y) == 1) {
        rlang::sym(.y)
      } else {
        rlang::syms(.y)
      }
    }
    base::assign(.x, .y, envir = env)
  })
}

#' Assign configs to local variables \lifecycle{experimental}
#'
#' TODO-20191026-4: Write doc for `conf_merge()`
#'
#' @param config_x [[list]]
#' @param config_y [[list]]
#'
#' @return [[list]]
#'
#' @export
conf_merge <- function(config_x, config_y) {
  # config::merge(config_x, config_y)
  conf_merge_lists(config_x, config_y)
}

# For `onAttach()` --------------------------------------------------------

#' Load internal package configs \lifecycle{experimental}
#'
#' Put this in your custom `.onAttach()` function to load your package's
#' internal configs based on `.yml` files that typically should live in your
#' `./inst` directory (which becomes the root package directory once the package
#' is attached).
#'
#' TODO-20191115-2: Explain env var `CONFX_AUTO_LOAD_INTERNAL`
#'
#' @param pkgname [[character()]] See [?.onAttach]
#'
#' @return [[list]]
#' @export
conf_auto_load_internal <- function(pkgname) {
  env_auto_load_internal <- as.logical(
    Sys.getenv("CONFX_AUTO_LOAD_INTERNAL", FALSE))
  if (env_auto_load_internal) {
    conf_load(system.file(package = pkgname))
  } else {
    list()
  }
}

#' Load project configs \lifecycle{experimental}
#'
#' Put this in your custom `.onAttach()` function to load your project's configs
#' based on `.yml` files that typically should live in your project's root
#' directory (check via [here::here()]).
#'
#' TODO-20191115-3: Explain env var `CONFX_AUTO_LOAD`
#'
#' @return [[list]]
#' @export
conf_auto_load <- function() {
  env_auto_load <- as.logical(Sys.getenv("CONFX_AUTO_LOAD", FALSE))
  if (env_auto_load) {
    conf_load()
  } else {
    list()
  }
}
