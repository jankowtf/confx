file_config <- test_path("config.yml")
file_config_002 <- test_path("config_002.yml")
file_config_003 <- test_path("config_003.yml")
file_config_openapi <- test_path("config_openapi.yml")

test_that("conf_load() works (before)", {
  # skip_on_travis()
  res <- getOption("config.yml")

  expect_true(is.null(res))
})

test_that("conf_load() works (call)", {
  # skip_on_travis()
  res <- conf_load(dir = test_path())

  # expect_equal(
  #   res,
  #   structure(
  #     c(
  #       "tests/testthat/conf_rules.yml" = "tests/testthat/conf_rules.yml",
  #       "tests/testthat/config.yml" = "tests/testthat/config.yml",
  #       "tests/testthat/config_002.yml" = "tests/testthat/config_002.yml",
  #       "tests/testthat/config_003.yml" = "tests/testthat/config_003.yml",
  #       "tests/testthat/config_openapi.yml" = "tests/testthat/config_openapi.yml"
  #     ),
  #     class = c("fs_path", "character")
  #   )
  # )
  expect_equal(
    res,
    structure(
      c(
        "conf_rules.yml" = "conf_rules.yml",
        "config.yml" = "config.yml",
        "config_002.yml" = "config_002.yml",
        "config_003.yml" = "config_003.yml",
        "config_openapi.yml" = "config_openapi.yml"
      ),
      class = c("fs_path", "character")
    )
  )
  # Note that path is relativ when running tests in batch!

})

test_that("conf_load() works (after)", {
  # skip_on_travis()
  res <- getOption("confx_config.yml")
  expect_true(!is.null(res))
})

test_that("Options are cleaned up", {
  opt_name <- stringr::str_glue("{PKG_THIS}{SEP_OPT_NAME}config.yml")
  arg_list <- list(NULL) %>% purrr::set_names(opt_name)
  rlang::call2(quote(options), !!!arg_list) %>%
    rlang::eval_tidy()
  expect_identical(options(opt_name) %>% unlist(), NULL)

  opt_name <- stringr::str_glue("{PKG_THIS}{SEP_OPT_NAME}config_002.yml")
  arg_list <- list(NULL) %>% purrr::set_names(opt_name)
  rlang::call2(quote(options), !!!arg_list) %>%
    rlang::eval_tidy()
  expect_identical(options(opt_name) %>% unlist(), NULL)
})
