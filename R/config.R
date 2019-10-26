#' Get config \lifecycle{experimental}
#'
#' TODO-20191026-1: Write doc for `conf_get()`
#'
#' @param value [[character]]
#' @param from [[character]]
#' @param dir_from [[character]]
#' @param sep [[character]]
#' @param inheritance_handling [[logical]]
#'
#' @return  [[list]]
#'
#' @export [[list] or [character]]
conf_get <- function(
  value = character(),
  from = "config.yml",
  dir_from = here::here(),
  sep = "/",
  inheritance_handling = TRUE
) {
  configs <- getOption(from)
  if (is.null(configs)) {
    # configs <- config::get(file = here::here(dir_from, from))
    # Per se okay but hard to test and inflexible for non-standard use cases

    # Better:
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
    conf_handle_inherited(configs, from = from, dir_from = dir_vrom)
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
conf_load <- function(dir = here::here()) {
  config_files <- fs::dir_ls(dir, type = "file", regexp = "\\.yml$")
  idx <- config_files %>%
    fs::path_file() %>%
    stringr::str_detect("^(_|\\.)", negate = TRUE)
  config_files <- config_files[idx]

  config_files %>%
    purrr::walk(function(.file) {
      message(stringr::str_glue("Loading configs into options: {fs::path_file(.file)}"))
      arg_list <- list(config::get(file = .file)) %>%
        purrr::set_names(fs::path_file(.file))
      rlang::call2(quote(options), !!!arg_list) %>%
        rlang::eval_tidy()
    })

  config_files
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
