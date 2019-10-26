test_that("conf_get() works (branch)", {
  skip_on_travis()
  res <- confx::conf_get("col_names", dir_from = test_path())
  expect_is(res, "list")
  expect_true(length(res) > 0)
})

test_that("conf_get() works (leaf)", {
  skip_on_travis()
  res <- confx::conf_get("col_names/.col_id", dir_from = test_path())
  expect_is(res, "character")
  expect_true(length(res) == 1)
})

test_that("conf_get() works (all)", {
  skip_on_travis()
  res <- conf_get(dir_from = test_path())
  expect_is(res, "list")
  expect_true(length(res) >= 1)
})

test_that("conf_get() works (error)", {
  skip_on_travis()
  expect_error(conf_get("notthere", dir_from = test_path()), "No such element in list: notthere")
})
