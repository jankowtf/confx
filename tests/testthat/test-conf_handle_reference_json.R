# config_openapi.yml <- test_path("config_openapi.yml")
#
# test_that("multiplication works", {
#   conf_get("components", config_openapi.yml)
#   conf_get("responses", "config_openapi.yml")
# })

dir_from <- test_path()

test_that("conf_handle_reference_json() works", {
  # skip_on_travis()
  conf_load(dir = dir_from)
  # options() %>% names() %>% stringr::str_subset("\\.yml") %>% print()

  value <- "responses/200/schema"
  from <- "config_openapi.yml"
  configs <- conf_get(value, from, dir_from, resolve_references = FALSE)
  res <- conf_handle_reference_json(configs, from, dir_from,
    drop_ref_link = FALSE)

  expect_identical(res,
    list(
      properties = list(
        id = list(
          type = "integer"
        ),
        name = list(
          type = "string"
        )
      ),
      `$ref` = "#/components/schemas/User"
    )
  )
})

test_that("conf_handle_reference_json() works: inter-config", {
  # skip_on_travis()
  conf_load(dir = dir_from)

  value <- "data_structures/data_structure_e"
  from <- "config_2.yml"
  configs <- conf_get(value, from, dir_from, resolve_references = FALSE)
  res <- conf_handle_reference_json(configs, from, dir_from)

  expect_identical(res,
    list(
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
