test_that("System function for valid conf extensions works", {
  expect_equal(
    SYS_VALID_CONF_EXTENSIONS(),
    c(".yml", ".json")
  )
})

test_that("System function for valid conf extensions works: regexp", {
  expect_equal(
    SYS_VALID_CONF_EXTENSIONS(as_regexp = TRUE),
    ".*(\\.yml|\\.json|\\.YML|\\.JSON)$"
  )
})
