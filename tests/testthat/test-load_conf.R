file_config_yml <- test_path("config.yml")
file_config_2_yml <- test_path("config_2.yml")
file_config_openapi_yml <- test_path("config_openapi.yml")

test_that("Loading configs work: option state before", {
  # skip_on_travis()
  res <- getOption("config.yml")
  expect_true(is.null(res))
})

test_that("Loading configs work: from dir", {
  # skip_on_travis()
  res <- load_conf(from = test_path())
  expect_equal(res, c(file_config_yml, file_config_2_yml, file_config_openapi_yml))
})

test_that("load_conf() works (after)", {
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

  opt_name <- stringr::str_glue("{PKG_THIS}{SEP_OPT_NAME}config_2.yml")
  arg_list <- list(NULL) %>% purrr::set_names(opt_name)
  rlang::call2(quote(options), !!!arg_list) %>%
    rlang::eval_tidy()
  expect_identical(options(opt_name) %>% unlist(), NULL)
})
