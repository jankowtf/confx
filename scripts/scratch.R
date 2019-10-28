cols <- list(
  a = "a",
  b = "b"
) %>%
  dplyr::syms()

df <- tibble::tibble(a = 1:3, b = letters[1:3], c = TRUE)

df %>%
  dplyr::select(!!cols$a)
# Works

df %>%
  dplyr::select({{ (cols$a) }})
# Doesn't work

df %>%
  dplyr::select(!!!cols)

df %>%
  dplyr::select({{ ({{ cols }}) }})

foo <- function(
  x,
  cols = list(
    a = "a",
    b = "b"
  ) %>%
    dplyr::syms()
) {
  df %>%
    dplyr::select(!!!cols)
}

foo(df)

foo <- function(
  x,
  cols = list(
    a = "a",
    b = "b"
  ) %>%
    dplyr::syms()
) {
  df %>%
    dplyr::select(!!cols$a, !!cols$b)
}

foo(df)

foo <- function(
  x,
  cols = list(
    a = dplyr::sym(a),
    b = dplyr::sym(b)
  ) %>%
    dplyr::quos()
) {
  df %>%
    dplyr::select(!!!cols)
}

foo(df)

