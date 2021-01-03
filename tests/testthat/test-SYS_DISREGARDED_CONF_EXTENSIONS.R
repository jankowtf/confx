# System function for disregarded conf files ------------------------------

test_that("As vector", {
  expect_equal(
    SYS_DISREGARDED_CONF_FILES(),
    c("codecov", ".travis", "_", ".")
  )
})

test_that("As regexp", {
  expect_equal(
    res <- SYS_DISREGARDED_CONF_FILES(as_regexp = TRUE),
    "(^(codecov|\\.travis|CODECOV|\\.TRAVIS)\\.yml$)|(^(_|\\.).*\\.yml$)" %>%
      glue::as_glue()
  )
})

test_that("Regexp captures the right things", {
  x <- c(
    "_my.yml", ".my.yml", "codecov.yml", ".travis.yml",
    "my.yml", "travis.yml"
  )
  regexp <- SYS_DISREGARDED_CONF_FILES(as_regexp = TRUE)
  expect_identical(
    stringr::str_detect(x, regexp),
    c(
      TRUE, TRUE, TRUE, TRUE,
      FALSE, FALSE
    )
  )
})
