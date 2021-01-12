# Test fixtures -----------------------------------------------------------

dir_from <- test_path()

# == ----------------------------------------------------------------------

test_that("Query: ==: scalar: match", {
  result <- conf_get(
    "object_with_array/id=='a'",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "a", value = 1L))

  expect_identical(result, target)
})

test_that("Query: ==: scalar: no match", {
  result <- conf_get(
    "object_with_array/id=='x'",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

test_that("Query: ==: vector: match", {
  result <- conf_get(
    "object_with_array/value==c(3, 4)",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "c", value = c(3, 4)))

  expect_identical(result, target)

  result <- conf_get(
    "object_with_array/value==3:4",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  expect_identical(result, target)
})

test_that("Query: ==: vector: no match", {
  result <- conf_get(
    "object_with_array/value==c(2, 3)",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

# != ----------------------------------------------------------------------

test_that("Query: !=: scalar: match", {
  result <- conf_get(
    "object_with_array/id!='a'",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "b", value = 2L),
    list(id = "c", value = c(3, 4)))

  expect_identical(result, target)
})

test_that("Query: !=: vector: match", {
  result <- conf_get(
    "object_with_array/value!=3:4",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "a", value = 1L),
    list(id = "b", value = 2L))

  expect_identical(result, target)
})

# In ----------------------------------------------------------------------

test_that("Query: %in%: scalar: match", {
  result <- conf_get(
    "object_with_array/id%in%'a'",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "a", value = 1L))

  expect_identical(result, target)

  result <- conf_get(
    "object_with_array/value%in%1",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  expect_identical(result, target)
})

test_that("Query: %in%: scalar: no match", {
  result <- conf_get(
    "object_with_array/id%in%'d'",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)

  result <- conf_get(
    "object_with_array/value%in%99",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  expect_identical(result, target)
})

test_that("Query: %in%: vector: match", {
  result <- conf_get(
    "object_with_array/id%in%c('a', 'b')",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <-
    list(list(id = "a", value = 1L), list(id = "b", value = 2L))

  expect_identical(result, target)

  result <- conf_get(
    "object_with_array/value%in%c(1, 2)",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  expect_identical(result, target)
})

test_that("Query: %in%: vector: no match", {
  result <- conf_get(
    "object_with_array/id%in%c('d', 'e')",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)

  result <- conf_get(
    "object_with_array/value%in%c(99, 100)",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  expect_identical(result, target)
})

# Not in ------------------------------------------------------------------

test_that("Query: %!in%: scalar: match", {
  result <- conf_get(
    "object_with_array/id%!in%'a'",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "b", value = 2L),
    list(id = "c", value = c(3, 4)))

  expect_identical(result, target)

  result <- conf_get(
    "object_with_array/value%!in%1",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  expect_identical(result, target)
})

test_that("Query: %!in%: vector: match", {
  result <- conf_get(
    "object_with_array/id%!in%c('a', 'b')",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "c", value = c(3, 4)))

  expect_identical(result, target)

  result <- conf_get(
    "object_with_array/value%!in%c(1, 2)",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  expect_identical(result, target)
})

test_that("Query: %!in%: vector: no match", {
  result <- conf_get(
    "object_with_array/id%!in%c('a', 'b', 'c')",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)

  result <- conf_get(
    "object_with_array/value%!in%1:4",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  expect_identical(result, target)
})

# > -----------------------------------------------------------------------

test_that("Query: >: scalar: match", {
  result <- conf_get(
    "object_with_array/value>2",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "c", value = c(3, 4)))

  expect_identical(result, target)
})

test_that("Query: >: scalar: no match", {
  result <- conf_get(
    "object_with_array/id>'c'",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

test_that("Query: >: vector: match", {
  result <- conf_get(
    "object_with_array/id>c('a', 'b')",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(
    list(id = "b", value = 2L),
    list(id = "c", value = c(3, 4))
  )

  expect_identical(result, target)
})

test_that("Query: >: vector: no match", {
  result <- conf_get(
    "object_with_array/id>c('c', 'd')",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

# >= ----------------------------------------------------------------------

test_that("Query: >=: scalar: match", {
  result <- conf_get(
    "object_with_array/value>=2",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "b", value = 2L),
    list(id = "c", value = c(3, 4)))

  expect_identical(result, target)
})

test_that("Query: >=: scalar: no match", {
  result <- conf_get(
    "object_with_array/id>='d'",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

test_that("Query: >=: vector: match", {
  result <- conf_get(
    "object_with_array/id>=c('a', 'b')",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(
    list(id = "a", value = 1L),
    list(id = "b", value = 2L),
    list(id = "c", value = c(3, 4))
  )

  expect_identical(result, target)
})

test_that("Query: >=: vector: no match", {
  result <- conf_get(
    "object_with_array/id>=c('d', 'e')",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

# < -----------------------------------------------------------------------

test_that("Query: <: scalar: match", {
  result <- conf_get(
    "object_with_array/value<2",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "a", value = 1L))

  expect_identical(result, target)
})

test_that("Query: <: scalar: no match", {
  result <- conf_get(
    "object_with_array/id<'a'",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

test_that("Query: <: vector: match", {
  result <- conf_get(
    "object_with_array/id<c('a', 'b')",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "a", value = 1L))

  result <- conf_get(
    "object_with_array/value<1:2",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  expect_identical(result, target)
})

test_that("Query: <: vector: no match", {
  result <- conf_get(
    "object_with_array/id<c('a', 'a')",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  result <- conf_get(
    "object_with_array/value<c(1, 1)",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  expect_identical(result, target)
})

# <= ----------------------------------------------------------------------

test_that("Query: <=: scalar: match", {
  result <- conf_get(
    "object_with_array/value <= 2",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- target <- list(
    list(id = "a", value = 1L),
    list(id = "b", value = 2L)
  )

  expect_identical(result, target)
})

test_that("Query: <=: scalar: no match", {
  result <- conf_get(
    "object_with_array/value<=0",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

test_that("Query: <=: vector: match", {
  result <- conf_get(
    "object_with_array/id <= c('b', 'c')",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- target <- list(
    list(id = "a", value = 1L),
    list(id = "b", value = 2L),
    list(id = "c", value = c(3, 4))
  )

  expect_identical(result, target)
})

test_that("Query: <=: vector: no match", {
  result <- conf_get(
    "object_with_array/value <= -1:0",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

# & -----------------------------------------------------------------------

test_that("Query: &: scalar: match", {
  result <- conf_get(
    "object_with_array_2/id=='a'&value==1",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "a", value = 1L))

  expect_identical(result, target)
})

test_that("Query: &: scalar: match: no match", {
  result <- conf_get(
    "object_with_array_2/id=='a'&value==4",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

test_that("Query: &: vector: match", {
  result <- conf_get(
    "object_with_array_2/id=='a'&value%in%c(1, 2)",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "a", value = 1L),
    list(id = "a", value = 2L))

  expect_identical(result, target)
})

test_that("Query: &: vector: no match", {
  result <- conf_get(
    "object_with_array_2/id=='a'&value%in%c(4, 5)",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

# | -----------------------------------------------------------------------

test_that("Query: |: scalar: match", {
  result <- conf_get(
    "object_with_array_2/id=='b'|value==3",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(
    list(id = "a", value = 3L),
    list(id = "b", value = 1L),
    list(id = "b", value = 2L),
    list(id = "b", value = 3L)
  )

  expect_identical(result, target)
})

test_that("Query: |: scalar: match: no match", {
  result <- conf_get(
    "object_with_array_2/id=='d'|value==5",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

test_that("Query: |: vector: match", {
  result <- conf_get(
    "object_with_array_2/id=='c'|value%in%c(3, 4)",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(
    list(id = "a", value = 3L),
    list(id = "b", value = 3L),
    list(id = "c", value = c(1, 2)),
    list(id = "c", value = c(3, 4))
  )

  expect_identical(result, target)
})

test_that("Query: |: vector: no match", {
  result <- conf_get(
    "object_with_array_2/id=='d'|value%in%c(5, 6)",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

# & and | -----------------------------------------------------------------

test_that("Query: | + &: scalar: match", {
  # result <- conf_get(
  #   "object_with_array_2/id=='a'&value==2",
  #   from = "config_003.yml",
  #   dir_from = dir_from,
  #   force_from_file = TRUE,
  #   verbose = TRUE
  # )

  result <- conf_get(
    "object_with_array_2/(id=='a'&value==2)|value==3",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(list(id = "a", value = 2L),
    list(id = "a", value = 3L),
    list(id = "b", value = 3L))

  expect_identical(result, target)
})

test_that("Query: & + |: scalar: match: no match", {
  result <- conf_get(
    "object_with_array_2/(id=='a'&value==4)|value==4",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

test_that("Query: & + |: vector: match", {
  result <- conf_get(
    "object_with_array_2/(id%in%c('a', 'b')&value%in%c(2, 3))|value%in%4:5",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list(
    list(id = "a", value = 2L),
    list(id = "a", value = 3L),
    list(id = "b", value = 2L),
    list(id = "b", value = 3L),
    list(id = "c", value = c(3, 4))
  )

  expect_identical(result, target)
})

test_that("Query: & + |: vector: no match", {
  result <- conf_get(
    "object_with_array_2/(id%in%c('d', 'e')&value%in%c(2, 3))|value%in%5:6",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  target <- list()

  expect_identical(result, target)
})

# Dates -------------------------------------------------------------------

# test_that("Query: dates", {
#   result <- conf_get("versions/valid_from==2020-01-01",
#     from = "config_003.yml",
#     dir_from = dir_from,
#     force_from_file = TRUE
#   )
#
#   target <- list(list(valid_from = "2020-01-01", valid_until = "2020-05-31"))
#
#   expect_identical(result, target)
# })
#
# test_that("Query: dates", {
#   result <- conf_get("versions/valid_from>2020-01-01&valid_from<=2020-07-01",
#     from = "config_003.yml",
#     dir_from = dir_from,
#     force_from_file = TRUE
#   )
#
#   target <- list(list(valid_from = "2020-06-01", valid_until = "2020-08-31"))
#
#   expect_identical(result, target)
# })
#
# # List of docs ------------------------------------------------------------
#
# test_that("Query: dates", {
#   result <- conf_get(
#     "versions/valid_from>=2020-01-01&valid_from<=2020-01-02/version",
#     from = "config_003.yml",
#     dir_from = dir_from,
#     force_from_file = TRUE
#   )
#
#   result <- conf_get(
#     "versions/valid_from>=2020-01-01&valid_from<=2020-01-02/version/major",
#     from = "config_003.yml",
#     dir_from = dir_from,
#     force_from_file = TRUE
#   )
#
#   result <- conf_get(
#     "versions/valid_from>=2020-06-01&valid_until==2020-08-31/test/value==hello",
#     from = "config_003.yml",
#     dir_from = dir_from,
#     force_from_file = TRUE
#   )
#
#   result <- conf_get(
#     "versions/valid_from>=2020-06-01&valid_until==2020-08-31/test/value==world",
#     from = "config_003.yml",
#     dir_from = dir_from,
#     force_from_file = TRUE
#   )
#
#   result <- conf_get(
#     "versions/valid_from>=2020-06-01&valid_until==2020-08-31/test/1",
#     from = "config_003.yml",
#     dir_from = dir_from,
#     force_from_file = TRUE
#   )
#
#   result <- conf_get(
#     "versions/valid_from>=2020-06-01&valid_until==2020-08-31/test/2",
#     from = "config_003.yml",
#     dir_from = dir_from,
#     force_from_file = TRUE
#   )
#
#   result <- conf_get(
#     "versions/valid_from==2020-09-01&valid_until==2020-12-31/test/value",
#     from = "config_003.yml",
#     dir_from = dir_from,
#     force_from_file = TRUE
#   )
#
#   result <- conf_get(
#     "versions/valid_from>=2020-09-01&valid_until==2020-12-31/test/value/title==hello",
#     from = "config_003.yml",
#     dir_from = dir_from,
#     force_from_file = TRUE
#   )
#
#   target <- list(list(valid_from = "2020-06-01", valid_until = "2020-08-31"))
#
#   expect_identical(result, target)
# })

test_that("Query: ==: scalar: match: rules", {
  skip("Rapid prototyping")
  confx::conf_get(
    "object_with_array/id=='a'",
    from = "config_003.yml",
    dir_from = dir_from,
    force_from_file = TRUE
  )

  result <- conf_get(
    "wage_types/wage_type=='002'",
    from = "conf_rules.yml",
    dir_from = dir_from,
    force_from_file = TRUE,
    verbose = TRUE
  )

  target <- list(list(id = "a", value = 1L))

  expect_identical(result, target)
})
