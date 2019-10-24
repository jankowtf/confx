test_that("get() works (branch)", {
  res <- confx::get("col_names", dir_from = test_path())
  expect_is(res, "list")
  expect_true(length(res) > 0)
})

test_that("get() works (leaf)", {
  res <- confx::get("col_names/.col_id", dir_from = test_path())
  expect_is(res, "character")
  expect_true(length(res) == 1)
})

test_that("get() works (all)", {
  res <- get(dir_from = test_path())
  expect_is(res, "list")
  expect_true(length(res) >= 1)
})

test_that("get() works (error)", {
  expect_error(get("notthere", dir_from = test_path()), "No such element in list: notthere")
})
