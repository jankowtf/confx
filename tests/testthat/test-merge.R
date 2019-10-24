test_that("merge() works (config sets)", {
  load(dir = test_path())

  config_1 <- getOption("config.yml")
  config_2 <- getOption("config_2.yml")

  res <- merge(config_1, config_2)
  expect_identical(length(res), length(config_1))
  expect_identical(length(res), length(config_2))

  expect_equal(length(res$col_names),
    length(config_1$col_names) +
    length(config_2$col_names))
  expect_equal(length(res$data_structures),
    length(config_1$data_structures) +
      length(config_2$data_structures))
})

test_that("merge() works (inheritance explicit)", {
  load(dir = test_path())

  value <- "data_structures/data_structure_d/0.0.2"
  from <- "config_2.yml"
  configs <- get(value, from, inheritance_handling = FALSE)
  res <- handle_inherited(configs, from)

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
