
# Defaults ----------------------------------------------------------------

context("File extensions as regexp pattern: defaults")

test_that("Keeping all defaults works", {
  expect_identical(
    res <- regexp__file_extensions_as_regexp(c(".yml", ".json")),
    ".*(\\.yml|\\.json|\\.YML|\\.JSON)$"
  )
})

# Prefixes ----------------------------------------------------------------

context("File extensions as regexp pattern: prefixes")

test_that("Custom prefix works", {
  expect_identical(
    res <- regexp__file_extensions_as_regexp(c(".yml", ".json"),
      prefix = "^"),
    "^(\\.yml|\\.json|\\.YML|\\.JSON)$"
  )
})

test_that("Empty prefix works", {
  expect_identical(
    res <- regexp__file_extensions_as_regexp(c(".yml", ".json"),
      prefix = ""),
    "(\\.yml|\\.json|\\.YML|\\.JSON)$"
  )
})

# Suffixes ----------------------------------------------------------------

context("File extensions as regexp pattern: suffixes")

test_that("Custom suffix works", {
  expect_identical(
    res <- regexp__file_extensions_as_regexp(c(".yml", ".json"),
      suffix = ".*"),
    ".*(\\.yml|\\.json|\\.YML|\\.JSON).*"
  )
})

test_that("Empty suffix works", {
  expect_identical(
    res <- regexp__file_extensions_as_regexp(c(".yml", ".json"),
      suffix = ""),
    ".*(\\.yml|\\.json|\\.YML|\\.JSON)"
  )
})

# Parenthesis -------------------------------------------------------------

context("File extensions as regexp pattern: parenthesis")

test_that("No parentheses work", {
  expect_identical(
    res <- regexp__file_extensions_as_regexp(c(".yml", ".json"),
      wrap_in_parentheses = FALSE),
    ".*\\.yml|\\.json|\\.YML|\\.JSON$"
  )
})

# Escaping dots -----------------------------------------------------------

context("File extensions as regexp pattern: escaping of dots")

test_that("Not escaping dots works", {
  expect_identical(
    res <- regexp__file_extensions_as_regexp(c(".yml", ".json"),
      escape_dots = FALSE),
    ".*(.yml|.json|.YML|.JSON)$"
  )
})
