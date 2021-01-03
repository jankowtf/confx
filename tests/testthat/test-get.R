# Test fixtures -----------------------------------------------------------

dir_from <- test_path()

# Branch ------------------------------------------------------------------

test_that("conf_get() works (branch)", {
  # skip_on_travis()
  res <- confx::conf_get("col_names", dir_from = dir_from)
  expect_is(res, "list")
  expect_true(length(res) > 0)
})

test_that("conf_get() works (leaf)", {
  # skip_on_travis()
  res <- confx::conf_get("col_names/.col_id", dir_from = dir_from)
  expect_is(res, "character")
  expect_true(length(res) == 1)
})

test_that("conf_get() works (all)", {
  # skip_on_travis()
  res <- conf_get(dir_from = dir_from)
  expect_is(res, "list")
  expect_true(length(res) >= 1)
})

test_that("conf_get() works (error)", {
  # skip_on_travis()
  expect_error(conf_get("notthere", dir_from = dir_from), "No such element in list: notthere")
})

test_that("conf_get() works (force from file)", {
  # skip_on_travis()
  warning("TODO-2019115-1: `force_from_file` hard to test, think about including an automatic load count or something similar")
  res <- conf_get(dir_from = dir_from, force_from_file = TRUE)
  expect_is(res, "list")
  expect_true(length(res) >= 1)
})

test_that("R_CONFIG_DIR", {
  Sys.setenv(R_CONFIG_DIR = file.path(dir_from, "subdir"))
  res <- conf_get(force_from_file = TRUE)
  expect_is(res, "list")
  expect_identical(res$test, "hello world")
})

test_that("JSON references", {
  Sys.setenv(R_CONFIG_DIR = dir_from)

  . <- test_path("config_openapi.yml") %>%
    conf_load_from_file()

  value <- "responses/200/schema"
  from <- "config_openapi.yml"

  configs <- conf_get(value, from, dir_from, resolve_references = FALSE)
  res <- conf_handle_reference_json(configs, from, dir_from)

  target <- conf_get("components/schemas/User", from = from)

  expect_identical(res, target)
})

test_that("JSON references inter-file", {
  Sys.setenv(R_CONFIG_DIR = dir_from)

  . <- test_path("config_openapi.yml") %>%
    conf_load_from_file()

  value <- "responses/200/inherited_data_structures_via_json"
  from <- "config_openapi.yml"

  configs <- conf_get(value, from, dir_from, resolve_references = FALSE)
  res <- conf_handle_reference_json(configs, from, dir_from)

  target <- conf_get("data_structures",
    from = test_path("config.yml"))

  expect_identical(res, target)
})

test_that("`Inherits`` reference", {
  Sys.setenv(R_CONFIG_DIR = dir_from)

  . <- test_path("config_openapi.yml") %>%
    conf_load_from_file()

  value <- "responses/200/inherited_data_structures"
  from <- "config_openapi.yml"

  configs <- conf_get(value, from, dir_from, resolve_references = FALSE)
  res <- conf_handle_reference_inherited(configs, from, dir_from)

  target <- conf_get("data_structures",
    from = test_path("config.yml"))

  expect_identical(res, target)
})

test_that("Temporary switch of config environment", {
  # Sys.setenv(R_CONFIG_ACTIVE = "default")

  . <- test_path("config_002.yml") %>%
    conf_load_from_file()

  from <- "config_002.yml"

  res <- conf_get("db_name", from, dir_from, config = "test")
  target <- "db_test"

  expect_identical(res, target)

  res <- conf_get("db_host", from, dir_from, config = "test")
  target <- "localhost"

  expect_identical(res, target)
})

