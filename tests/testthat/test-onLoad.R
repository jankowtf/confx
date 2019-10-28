test_that(".onLoad() works", {
  confx:::.onLoad()

  expect_identical(getOption("digits.secs"), 3)
  expect_identical(Sys.getenv("TZ"), "UTC")
  expect_identical(Sys.getenv("language"), "en")
})
