dir_from <- test_path()

test_that("conf_merge() works (config sets)", {
  # skip_on_travis()
  conf_load(dir = dir_from)

  from <- stringr::str_glue("{PKG_THIS}{SEP_OPT_NAME}config.yml")
  config_1 <- getOption(from)
  expect_true(!is.null(config_1))
  from <- stringr::str_glue("{PKG_THIS}{SEP_OPT_NAME}config_2.yml")
  config_2 <- getOption(from)
  expect_true(!is.null(config_2))

  res <- conf_merge(config_1, config_2)
  expect_identical(length(res), length(config_1))
  expect_identical(length(res), length(config_2))

  expect_equal(length(res$col_names),
    length(config_1$col_names) +
    length(config_2$col_names))
  expect_equal(length(res$data_structures),
    length(config_1$data_structures) +
      length(config_2$data_structures))
})

test_that("conf_merge() works (inheritance explicit)", {
  # skip_on_travis()
  conf_load(dir = dir_from)

  value <- "data_structures/data_structure_d/0.0.2"
  from <- "config_2.yml"
  configs <- conf_get(value, from, inheritance_handling = FALSE)
  res <- conf_handle_inherited(configs, from)

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

# Check if `conf_merg()` doesn't interfere with standard inheritance mechanism
# of `{config}`
test_that("conf_merge() works (inheritance default/production)", {
  # skip_on_travis()
  Sys.setenv(R_CONFIG_ACTIVE = "production")

  conf_load(dir = dir_from)

  value <- "db_name"
  from <- "config_2.yml"
  configs <- conf_get(value, from, inheritance_handling = FALSE)
  res <- conf_handle_inherited(configs, from)

  expect_identical(res, "db_prod")

  conf_load(dir = dir_from)
  # configs <- conf_get(from = from, inheritance_handling = FALSE)

  value <- "data_structures/data_structure_d/0.0.2"
  from <- "config_2.yml"
  configs <- conf_get(value, from, inheritance_handling = FALSE)
  res <- conf_handle_inherited(configs, from)

  expect_identical(res,
    list(cols = c(
      "col_names/.col_id",
      "col_names/.col_name",
      "col_names/.col_value"
    ),
      inherits = "data_structures/data_structure_d/0.0.1"
    )
  )

  Sys.setenv(R_CONFIG_ACTIVE = "default")
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
