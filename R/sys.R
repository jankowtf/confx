SYS_VALID_CONF_EXTENSIONS <- function(as_regexp = FALSE) {
  file_extensions <- c(
    ".yml",
    ".json"
  )
  if (as_regexp) {
    file_extensions <- regexp__file_extensions_as_regexp(file_extensions,
      include_uppercase = TRUE)
  }

  file_extensions
}

SYS_DISREGARDED_CONF_FILES <- function(as_regexp = FALSE) {
  file_names_1 <- c(
    "codecov",
    ".travis"
  )
  file_names_2 <- c(
    "_",
    "."
  )

  # "^(_|\\.|codecov|travis)"

  file_names <- if (as_regexp) {
    file_names_1 <- regexp__file_extensions_as_regexp(
      file_names_1,
      prefix = "^",
      suffix = "\\.yml$",
      wrap_in_parentheses = TRUE,
      escape_dots = TRUE,
      include_uppercase = TRUE
    )
    file_names_2 <- regexp__file_extensions_as_regexp(
      file_names_2,
      prefix = "^",
      suffix = ".*\\.yml$",
      wrap_in_parentheses = TRUE,
      escape_dots = TRUE,
      include_uppercase = TRUE
    )

    stringr::str_glue("({file_names_1})|({file_names_2})")
  } else {
    c(file_names_1, file_names_2)
  }

  file_names
}
