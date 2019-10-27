file_config_yml <- test_path("config.yml")
file_config_2_yml <- test_path("config_2.yml")

test_that("conf_load() works (before)", {
  # skip_on_travis()
  res <- getOption("config.yml")
  expect_true(is.null(res))
})

test_that("conf_load() works (call)", {
  # skip_on_travis()
  res <- conf_load(dir = test_path())
  expect_equal(res, c(file_config_yml, file_config_2_yml))
})

test_that("conf_load() works (after)", {
  # skip_on_travis()
  res <- getOption("config.yml")
  expect_true(!is.null(res))
})

# Clean up -----
options("config.yml" = NULL)
options("config_2.yml" = NULL)
