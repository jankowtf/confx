# Query operators ---------------------------------------------------------

test_that("Query operators: no choice", {
  result <- valid_operators_logical()

  target <- c(
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

  expect_identical(result, target)
})

test_that("Query operators: no choice: regexp", {
  result <- valid_operators_logical(as_regexp = TRUE)

  target <- "==|!=|%in%|%!in%|<|<=|>|>="

  expect_identical(result, target)
})

test_that("Query operators: choice: scalar", {
  result <- valid_operators_logical(c("<"))

  target <- c(
    "<"
  ) %>%
    purrr::set_names(.)

  expect_identical(result, target)
})

test_that("Query operators: choice: vector", {
  result <- valid_operators_logical(c("<", ">"))

  target <- c(
    "<",
    ">"
  ) %>%
    purrr::set_names(.)

  expect_identical(result, target)
})

# Query chain operators ---------------------------------------------------

test_that("Chain ops: no choice", {
  result <- valid_operators_query_chain()

  target  <- c("&" = "&", "|" = "|")

  expect_identical(result, target)
})

test_that("Chain ops: &", {
  result <- valid_operators_query_chain("&")

  target  <- c("&" = "&")

  expect_identical(result, target)
})

test_that("Chain ops: |", {
  result <- valid_operators_query_chain("|")

  target  <- c("|" = "|")

  expect_identical(result, target)
})

test_that("Chain ops: invalid", {
  expect_error(
    valid_operators_query_chain("abc"),
    regexp = "Invalid choice: valid_operators_query_chain\\(\"abc\"\\)"
  )
})
