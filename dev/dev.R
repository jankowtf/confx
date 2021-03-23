# Dependencies ------------------------------------------------------------

renv::install("rappster/renvx", rebuild = TRUE)

packages <- renvx::extract_packages_for_renv_install()

renv::install(packages, rebuild = TRUE, type = getOption("pkgType"))

renv::remove("renvx")

# Somehow not all packages were installed from RSPM.
# But seems to be the case when explicitly forcing type = "binary"
renv::install(
  "base64enc",
  "brio",
  "credentials",
  "diffobj",
  "gitcreds",
  "highr",
  "knitr",
  "markdown",
  "rappdirs",
  "rematch2",
  "xfun",
  rebuild = TRUE,
  type = getOption("pkgType")
)

renv::install("stringi", type = "binary")
renv::install("rappster/valid")

renv::snapshot()

usethis::use_package("usethis")
usethis::use_package("rlang")
usethis::use_package("pkgload")
usethis::use_package("purrr")
usethis::use_package("valid")
usethis::use_package("clipr", type = "Suggests")
usethis::use_package("here")

# Tests -------------------------------------------------------------------

usethis::use_test("valid")
usethis::use_test("get_list_query")
usethis::use_test("helpers")
usethis::use_test("query")
