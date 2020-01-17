regexp__file_extensions_as_regexp <- function(
  x,
  prefix = ".*",
  suffix = "$",
  wrap_in_parentheses = TRUE,
  include_uppercase = TRUE,
  escape_dots = TRUE
) {
  if (include_uppercase) {
    x <- unique(c(x, base::toupper(x)))
  }

  if (escape_dots) {
    x <- stringr::str_replace_all(x, "\\.", "\\\\.")
  }

  stringr::str_c(
    prefix,
    ifelse(wrap_in_parentheses, "(", ""),
    stringr::str_c(x, collapse = "|"),
    ifelse(wrap_in_parentheses, ")", ""),
    suffix
  )
}
