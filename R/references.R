
# Has reference -----------------------------------------------------------

#' Check for existence of `yaml` file reference
#'
#' Check for existence of `yaml` file reference
#'
#' @param value [[character]]
#'
#' @return [[logical]]
#'
#' @importFrom stringr str_detect
conf_has_reference <- function(value) {
  stringr::str_detect(value, "^.*\\.yml")
}

#' Check for existence of `$ref` reference
#'
#' Check for existence of `$ref` reference
#'
#' @param configs [[list]]
#'
#' @return [[logical]]
conf_has_reference_json <- function(configs) {
  ref <- conf_get_reference_id_json()
  ref %in% names(configs)
}

#' Check for existence of `inherits` reference
#'
#' Check for existence of `inherits` file reference
#'
#' TODO-20191026-7: Write doc for `conf_has_reference_inherits()`
#'
#' @param configs [[list]]
#' @param name [[character]]
#'
#' @return [[logical]]
conf_has_reference_inherits <- function(configs, name = "inherits") {
  name %in% names(configs)
}

# Handle references -------------------------------------------------------

#' Handle file references
#'
#' @param value [[value]]
#' @param from [[value]]
#'
#' @return [[value]]
#'
#' @importFrom stringr str_remove
conf_handle_reference_file <- function(value, from) {
  if (conf_has_reference(value)) {
    from <- conf_resolve_reference_file(value)
    value <- stringr::str_remove(value, stringr::str_c(from, "/"))
  }
  list(
    value = value,
    from = from
  )
}

#' Handle references to inherited configs
#'
#' TODO-20191026-10: Write doc for `conf_handle_reference_inherited()`
#'
#' @param configs [[list]]
#' @param from [[character]]
#' @param drop_ref_link [[logical]]
#' @param dir_from [[character]]
#'
#' @return [[list] or [character]]
conf_handle_reference_inherited <- function(
  configs,
  from,
  # dir_from = here::here(),
  # dir_from = getwd(),
  dir_from = Sys.getenv("R_CONFIG_DIR", getwd()),
  # name = "inherits",
  drop_ref_link = TRUE
) {
  ref_id <- conf_get_reference_id_inherited()

  if (conf_has_reference_inherits(configs)) {
    configs_inherited <- conf_resolve_reference_inherited(
      configs[[ref_id]],
      from = from,
      dir_from = dir_from
    )

    configs <- conf_merge_referenced(configs_inherited, configs)

    if (drop_ref_link) {
      configs[[ref_id]] <- NULL
    }

    configs
  } else {
    configs
  }
}

#' Handle JSON references
#'
#' TODO-20191026-10: Write doc for `conf_handle_reference_json()`
#'
#' @param configs [[list]]
#' @param from [[character]]
#' @param drop_ref_link [[logical]]
#' @param dir_from [[character]]
#'
#' @return [[list] or [character]]
conf_handle_reference_json <- function(
  configs,
  from,
  # dir_from = here::here()
  dir_from = Sys.getenv("R_CONFIG_DIR", getwd()),
  drop_ref_link = TRUE
) {
  ref_id <- conf_get_reference_id_json()

  if (conf_has_reference_json(configs)) {
    configs_referenced <-
      conf_resolve_reference_json(
        configs[[ref_id]],
        from = from,
        dir_from = dir_from
      )

    configs <- conf_merge_referenced(configs_referenced, configs)

    if (drop_ref_link) {
      configs[[ref_id]] <- NULL
    }

    configs
  } else {
    configs
  }
}

# Resolve references ------------------------------------------------------

#' Resolve file reference
#'
#' @param value [[character]]
#'
#' @return [[character]]
#'
#' @importFrom stringr str_extract
conf_resolve_reference_file <- function(value) {
  stringr::str_extract(value, "^.*\\.yml")
}

#' Title
#'
#' TODO-20191026-8: Write doc for `conf_resolve_reference_inherited()`
#'
#' @param value_reference [[list] or [character]]
#' @param from [[character]]
#' @param dir_from [[character]]
#'
#' @return [[list] or [character]]
conf_resolve_reference_inherited <- function(
  value_reference,
  from,
  dir_from
) {
  config_ref <- conf_handle_reference_file(value_reference, from)
  conf_get(value = config_ref$value, from = config_ref$from, dir_from = dir_from)
}

#' Resolve JSON reference
#'
#' TODO-20191026-8: Write doc for `conf_resolve_reference_json()`
#'
#' @param path_reference [[list] or [character]]
#' @param from [[character]]
#' @param dir_from [[character]]
#'
#' @return [[list] or [character]]
conf_resolve_reference_json <- function(
  path_reference,
  from,
  dir_from
) {
  reference <- conf_resolve_reference_json_(path_reference)

  reference$from <- reference$from %>%
    conf_handle_reference_scope(from_this = from)

  conf_get(value = reference$path, from = reference$from, dir_from = dir_from)
}

#' Resolve JSON reference (inner)
#'
#' @param uri [[character]]
#'
#' @return
#'
#' @importFrom stringr str_extract str_remove
#' @examples
conf_resolve_reference_json_ <- function(uri) {
  # Ref syntax
  # https://tools.ietf.org/html/rfc3986
  validate_json_reference(uri)

  from <- uri %>%
    stringr::str_extract("^.*(\\.json|\\.yml)?#")
  path <- uri %>%
    stringr::str_remove(stringr::str_c(from, "/"))

  if (from != "#") {
    from <- from %>%
      stringr::str_remove("#$")
  }

  list(
    from = from,
    path = path
  )
}

# Merge references --------------------------------------------------------

#' Title
#'
#' TODO-20191026-9: Write doc for `conf_merge_referenced()`
#'
#' @param configs_inherited [[list]]
#' @param configs [[list]]
#'
#' @return [[list]]
conf_merge_referenced <- function(configs_inherited, configs) {
  conf_merge(configs_inherited, configs)
}

# Validate references -----------------------------------------------------

#' Validate JSON references
#'
#' @param uri [[character]]
#' @param regexp [[character]]
#'
#' @return
#'
#' @importFrom stringr str_detect str_glue
#' @examples
validate_json_reference <- function(
  uri,
  # regexp = "^#/.*(/.*)?"
  regexp = ".*#/.*(/.*)?"
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

# Reference IDs -----------------------------------------------------------

#' Reference ID for JSON/OpenAPI
#'
#' @return
#'
#' @examples
conf_get_reference_id_json <- function() {
  "$ref"
}

#' Reference ID for `inherits` YAML entity
#'
#' @return
#'
#' @examples
conf_get_reference_id_inherited <- function() {
  "inherits"
}

# Misc --------------------------------------------------------------------

#' Handle reference scope
#'
#' @param from
#' @param from_this
#'
#' @return
#'
#' @examples
conf_handle_reference_scope <- function(from, from_this) {
  if (from == "#") {
    from_this
  } else {
    from
  }
}
