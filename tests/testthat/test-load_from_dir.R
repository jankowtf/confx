
# Load configs from dir ---------------------------------------------------

test_that("Load configs from dir", {
  # expect_equal(
  #   conf_load_from_dir(test_path()),
  #   c(
  #     "tests/testthat/config.yml",
  #     "tests/testthat/config_002.yml",
  #     "tests/testthat/config_openapi.yml"
  #   )
  # )
  expect_equal(
    fs::path_file(conf_load_from_dir(test_path())),
    c(
      "conf_rules.yml",
      "config.yml",
      "config_002.yml",
      "config_003.yml",
      "config_openapi.yml"
    )
  )
})
