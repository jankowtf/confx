#' Valid logical operators
#'
#' @param x
#' @param reverse
#' @param flip
#' @param strict
#' @param as_regexp
#'
#' @return
#'
#' @importFrom purrr set_names
#' @importFrom valid valid
#' @examples
valid_operators_logical <- function(
  x = character(),
  reverse = FALSE,
  flip = FALSE,
  strict = TRUE,
  as_regexp = FALSE
) {
  choices <- c(
    "==",
    "!=",
    "%in%",
    "%!in%",
    "<",
    "<=",
    ">",
    ">="
  ) %>%
    purrr::set_names(.)

  x <- valid::valid(
    choice = x,
    choices = choices,
    reverse = reverse,
    flip = flip,
    strict = strict
  )

  if (as_regexp) {
    x %>% stringr::str_c(collapse = "|")
  } else {
    x
  }
}

#' Valid query chain operators
#'
#' @param x
#' @param reverse
#' @param flip
#' @param strict
#'
#' @return
#'
#' @importFrom purrr set_names
#' @importFrom valid valid
#' @examples
valid_operators_query_chain <- function(
  x = character(),
  reverse = FALSE,
  flip = FALSE,
  strict = TRUE
) {
  choices <- c(
    "&",
    "|"
  ) %>%
    purrr::set_names(.)

  valid::valid(
    choice = x,
    choices = choices,
    reverse = reverse,
    flip = flip,
    strict = strict
  )
}
