context("Load conf files from dir")

# Defaults ----------------------------------------------------------------

test_that("Defaults work", {
  # expect_equal(
  #   load_conf_from_dir(test_path()),
  #   c(
  #     "tests/testthat/config.yml",
  #     "tests/testthat/config_2.yml",
  #     "tests/testthat/config_openapi.yml"
  #   )
  # )
  expect_equal(
    fs::path_file(load_conf_from_dir(test_path())),
    c(
      "config.yml",
      "config_2.yml",
      "config_openapi.yml"
    )
  )
})
