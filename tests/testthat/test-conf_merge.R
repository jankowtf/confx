test_that("conf_merge() works (config sets)", {
  skip_on_travis()
  conf_load(dir = test_path())

  config_1 <- getOption("config.yml")
  config_2 <- getOption("config_2.yml")

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
  skip_on_travis()
  conf_load(dir = test_path())

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

# Clean up -----
options("config.yml" = NULL)
options("config_2.yml" = NULL)
