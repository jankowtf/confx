# Not in ------------------------------------------------------------------

test_that("Not in: scalar: false", {
  result <- letters[1] %!in% letters[1:3]

  target <- FALSE

  expect_identical(result, target)
})

test_that("Not in: vector: false", {
  result <- letters[1:2] %!in% letters[1:3]

  target <- c(FALSE, FALSE)

  expect_identical(result, target)
})

test_that("Not in: scalar: true", {
  result <- letters[4] %!in% letters[1:3]

  target <- TRUE

  expect_identical(result, target)
})

test_that("Not in: vector: true", {
  result <- letters[4:5] %!in% letters[1:3]

  target <- c(TRUE, TRUE)

  expect_identical(result, target)
})

test_that("Not in: vector: false & true", {
  result <- letters[3:4] %!in% letters[1:3]

  target <- c(FALSE, TRUE)

  expect_identical(result, target)
})
