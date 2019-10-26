test_that("conf_handle_inherited() works", {
  skip_on_travis()
  # warning("TODO-20191024-7: Write test for `conf_handle_inherited()`")
  conf_load(dir = test_path())
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
})

test_that("conf_handle_inherited() works: inter-config", {
  skip_on_travis()
  # warning("TODO-20191024-7: Write test for `conf_handle_inherited()`")
  conf_load(dir = test_path())

  value <- "data_structures/data_structure_e"
  from <- "config_2.yml"
  configs <- conf_get(value, from, inheritance_handling = FALSE)
  res <- conf_handle_inherited(configs, from)

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

# Clean up -----
options("config.yml" = NULL)
options("config_2.yml" = NULL)
