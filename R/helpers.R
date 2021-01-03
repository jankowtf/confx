#' Not in
#'
#' @param x
#' @param table
#'
#' @return
#'
#' @examples
`%!in%` <- function(x, table) {
  !(`%in%`(x, table))
}

#' Drop missing elements
#'
#' @param x
#'
#' @return
#'
#' @examples
drop_missing <- function(x) {
  x[!is.na(x)]
}

#' Parse object and write to clipboard
#'
#' @param x
#'
#' @return
#'
#' @examples
deparse_and_clip <- function(x) {
  x %>% deparse() %>% clipr::write_clip()
}
