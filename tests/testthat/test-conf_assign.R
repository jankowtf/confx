test_that("conf_assign() works", {
  # skip_on_travis()
  configs <- conf_get("col_names", dir_from = test_path())

  env <- environment()
  res <- conf_assign(configs, env = env, dir_from = test_path())
  expect_is(res, "list")
  expect_length(res, 3)
  expect_true(exists(".col_id", envir = env, inherits = FALSE))
  expect_true(exists(".col_name", envir = env, inherits = FALSE))
  expect_true(exists(".col_value", envir = env, inherits = FALSE))
})

test_that("conf_assign() works (error)", {
  # skip_on_travis()
  configs <- c(
    conf_get("col_names/.col_id", dir_from = test_path()),
    conf_get("col_names/.col_value", dir_from = test_path())
  )

  expect_error(conf_assign(configs, dir_from = test_path()),
    "Not a valid config list")
})
