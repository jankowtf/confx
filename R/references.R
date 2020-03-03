#' Title
#'
#' @param value [[character]]
#'
#' @return [[logical]]
conf_has_reference <- function(value) {
  stringr::str_detect(value, "^.*\\.yml")
}

#' Title
#'
#' @param value [[character]]
#'
#' @return [[character]]
conf_resolve_reference <- function(value) {
  stringr::str_extract(value, "^.*\\.yml")
}

#' Title
#'
#' @param value [[value]]
#' @param from [[value]]
#'
#' @return [[value]]
conf_handle_reference <- function(value, from) {
  if (conf_has_reference(value)) {
    from <- conf_resolve_reference(value)
    value <- stringr::str_remove(value, stringr::str_c(from, "/"))
  }
  list(
    value = value,
    from = from
  )
}


#' Title
#'
#' TODO-20191026-7: Write doc for `conf_has_inherited()`
#'
#' @param configs [[list]]
#' @param name [[character]]
#'
#' @return [[logical]]
conf_has_inherited <- function(configs, name = "inherits") {
  name %in% names(configs)
}

#' Title
#'
#' TODO-20191026-8: Write doc for `conf_resolve_inherited()`
#'
#' @param value_reference [[list] or [character]]
#' @param from [[character]]
#' @param dir_from [[character]]
#'
#' @return [[list] or [character]]
conf_resolve_inherited <- function(value_reference, from, dir_from) {
  config_ref <- conf_handle_reference(value_reference, from)
  conf_get(value = config_ref$value, from = config_ref$from, dir_from = dir_from)
}

#' Title
#'
#' TODO-20191026-9: Write doc for `conf_merge_inherited()`
#'
#' @param configs_inherited [[list]]
#' @param configs [[list]]
#'
#' @return [[list]]
conf_merge_inherited <- function(configs_inherited, configs) {
  conf_merge(configs_inherited, configs)
}

#' Title
#'
#' TODO-20191026-10: Write doc for `conf_handle_inherited()`
#'
#' @param configs [[list]]
#' @param from [[character]]
#' @param dir_from [[character]]
#' @param name [[character]]
#'
#' @return [[list] or [character]]
conf_handle_inherited <- function(
  configs,
  from,
  # dir_from = here::here(),
  dir_from = getwd(),
  name = "inherits"
) {
  if (conf_has_inherited(configs)) {
    configs_inherited <- conf_resolve_inherited(configs[[name]], from = from,
      dir_from = dir_from)
    conf_merge_inherited(configs_inherited, configs)
  } else {
    configs
  }
}

# OpenAPI references ------------------------------------------------------

#' Title
#'
#' TODO-20191026-10: Write doc for `conf_handle_inherited()`
#'
#' @param configs [[list]]
#' @param from [[character]]
#' @param dir_from [[character]]
#' @param name [[character]]
#'
#' @return [[list] or [character]]
handle_conf_reference <- function(
  configs,
  from,
  # dir_from = here::here()
  dir_from = getwd()
) {
  ref <- "$ref"
  if (has_conf_reference(configs)) {
    configs_inherited <-
      resolve_conf_reference(configs[[ref]], from = from,
        dir_from = dir_from)
    conf_merge_inherited(configs_inherited, configs)
  } else {
    configs
  }
}

#' Check for existence of `$ref` reference
#'
#' Check for existence of `$ref` reference
#'
#' @param configs [[list]]
#' @param name [[character]]
#'
#' @return [[logical]]
has_conf_reference <- function(configs) {
  ref <- "$ref"
  ref %in% names(configs)
}

#' Title
#'
#' TODO-20191026-8: Write doc for `resolve_conf_reference()`
#'
#' @param path_reference [[list] or [character]]
#' @param from [[character]]
#' @param dir_from [[character]]
#'
#' @return [[list] or [character]]
resolve_conf_reference <- function(path_reference, from, dir_from) {
  reference <- resolve_json_reference(path_reference)

  reference$from <- reference$from %>%
    handle_reference_scope(from_this = from)

  conf_get(value = reference$path, from = reference$from, dir_from = dir_from)
}

resolve_json_reference <- function(uri) {
  # Ref syntax
  # https://tools.ietf.org/html/rfc3986
  validate_json_reference(uri)

  from <- uri %>%
    stringr::str_extract("^.*(\\.json|\\.yml)?#")
  path <- uri %>%
    stringr::str_remove(stringr::str_c(from, "/"))

  list(from = from, path = path)
}

validate_json_reference <- function(
  uri,
  regexp = "^#/.*(/.*)?"
  # regexp = "^(#|\\.{2})/(.*/)?/.*\\.(json|yml)#(/.*)?"
) {
  validated <- uri %>%
    stringr::str_detect(regexp)

  if (!validated) {
    msg <- c(
      stringr::str_glue("Not a valid JSON reference: {uri}"),
      "\n",
      "See https://swagger.io/docs/specification/using-ref/ for valid references"
    )
    stop(msg)
  }
}

handle_reference_scope <- function(from, from_this) {
  if (from == "#") {
    from_this
  } else {
    from
  }
}
