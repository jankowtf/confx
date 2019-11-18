dir_from <- test_path()

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

test_that("conf_assign() works", {
  # skip_on_travis()
  configs <- conf_get("col_names", dir_from = dir_from)

  env <- environment()
  res <- conf_assign(configs, env = env, dir_from = dir_from)
  expect_is(res, "list")
  expect_length(res, 3)
  expect_true(exists(".col_id", envir = env, inherits = FALSE))
  expect_true(exists(".col_name", envir = env, inherits = FALSE))
  expect_true(exists(".col_value", envir = env, inherits = FALSE))
})

test_that("conf_assign() works (char input error)", {
  configs <- c(
    conf_get("col_names/.col_id", dir_from = dir_from),
    conf_get("col_names/.col_value", dir_from = dir_from)
  )

  # expect_error(conf_assign(configs, dir_from = dir_from),
  #   "Not a valid config list")
  expect_error(conf_assign(configs, dir_from = dir_from),
    "No such element in list: id")
})

test_that("conf_assign() works (reference)", {
  configs <- conf_get("data_structures/data_structure_a", dir_from = dir_from)

  env <- environment()
  res <- conf_assign(configs, env = env, dir_from = dir_from)
  expect_is(res, "list")
  expect_length(res, 2)
  expect_true(exists(".col_id", envir = env, inherits = FALSE))
  expect_true(exists(".col_value", envir = env, inherits = FALSE))
})

test_that("conf_assign() works (reference non-standard file)", {
  from <- "config_2.yml"
  configs <- conf_get("data_structures/data_structure_c",
    from = from, dir_from = dir_from)

  env <- environment()
  res <- conf_assign(configs, env = env, from = from, dir_from = dir_from)
  expect_is(res, "list")
  expect_length(res, 3)
  expect_true(exists(".col_group", envir = env, inherits = FALSE))
  expect_true(exists(".col_id", envir = env, inherits = FALSE))
  expect_true(exists(".col_value", envir = env, inherits = FALSE))
})
