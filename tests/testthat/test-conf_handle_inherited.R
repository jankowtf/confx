dir_from <- test_path()

test_that("conf_handle_inherited() works", {
  # skip_on_travis()
  conf_load(dir = dir_from)
  # options() %>% names() %>% stringr::str_subset("\\.yml") %>% print()

  value <- "data_structures/data_structure_d/0.0.2"
  from <- "config_2.yml"
  configs <- conf_get(value, from, dir_from, inheritance_handling = FALSE)
  res <- conf_handle_inherited(configs, from, dir_from)

  expect_identical(res,
    list(cols = c(
      "col_names/.col_id",
      "col_names/.col_name",
      "col_names/.col_value"
    ),
      inherits = "data_structures/data_structure_d/0.0.1"
    )
  )
})

test_that("conf_handle_inherited() works: inter-config", {
  # skip_on_travis()
  conf_load(dir = dir_from)

  value <- "data_structures/data_structure_e"
  from <- "config_2.yml"
  configs <- conf_get(value, from, dir_from, inheritance_handling = FALSE)
  res <- conf_handle_inherited(configs, from, dir_from)

  expect_identical(res,
    list(
      c(
        "col_names/.col_id",
        "col_names/.col_value"
      ),
      inherits = "config.yml/data_structures/data_structure_a"
    )
  )
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
