file_config_yml <- test_path("config.yml")
file_config_2_yml <- test_path("config_2.yml")

test_that("conf_load() works (before)", {
  res <- getOption("config.yml")
  expect_true(is.null(res))
})

test_that("conf_load() works (call)", {
  res <- conf_load(dir = test_path())
  expect_equal(res, c(file_config_yml, file_config_2_yml))
})

test_that("conf_load() works (after)", {
  res <- getOption("config.yml")
  expect_true(!is.null(res))
})

# Clean up -----
options("config.yml" = NULL)
