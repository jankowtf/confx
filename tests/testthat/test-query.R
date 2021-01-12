test_that("Tokenize query item", {
  skip("Deprecated")
  result <- "street==c('a', 'b')" %>%
    tokenize_query_item(op = "==")

  target <- list("street", "c('a', 'b')")

  expect_identical(result, target)
})

# Operators ---------------------------------------------------------------

test_that("Handle extracted operators", {
  skip("Deprecated")
  result <- c("<=", "<") %>%
    handle_extracted_operators()

  target <- "<="

  expect_identical(result, target)

  result <- c("<", "<=") %>%
    handle_extracted_operators()

  target <- "<="

  expect_identical(result, target)
})

