
# Quick access of common admin tasks --------------------------------------

renv::upgrade()
renv::settings$snapshot.type("simple")
# renv::restore(clean = TRUE)
renv::update()

renv::settings$snapshot.type()
renv::snapshot()

renv::refresh()
renv::rehash()

# Other -------------------------------------------------------------------

renv::activate()
renv::upgrade()

renv::install("magrittr")
renv::install("devtools")
renv::install("tidyverse")
renv::install("config")
renv::install("here")
renv::install("lifecycle")
renv::install("r-lib/usethis")
# renv::remove("usethis")

usethis::use_readme_rmd()
usethis::use_travis()
usethis::use_coverage()
usethis::use_lifecycle()

usethis::use_package("magrittr")
usethis::use_package("here")
usethis::use_package("config")
usethis::use_package("stringr")
usethis::use_package("fs")
usethis::use_package("devtools", type = "Suggests")

usethis::use_news_md()
usethis::use_testthat()
write(NULL, here::here("BACKLOG.md"))
write(NULL, here::here("config.yml"))

usethis::use_test("conf_get")
usethis::use_test("conf_load")
usethis::use_test("conf_assign")
usethis::use_test("conf_merge")
usethis::use_test("conf_has_reference_inherits")
usethis::use_test("conf_resolve_reference_inherited")
usethis::use_test("conf_merge_referenced")
usethis::use_test("conf_handle_reference_inherited")
usethis::use_test("conf_has_reference")
usethis::use_test("conf_resolve_reference_file")
usethis::use_test("conf_handle_reference_file")

# 2019-10-28 --------------------------------------------------------------

usethis::use_test("onLoad")
usethis::use_test("onAttach")
usethis::use_roxygen_md()
# Run once:
if (FALSE) {
  renv::install("roxygen2md")
  roxygen2md::roxygen2md()
  renv::remove("roxygen2md")
}

# v0.0.0.9013 (2020-01-09) ------------------------------------------------

usethis::use_test("references")

# v0.0.0.9014 (2020-01-17) ------------------------------------------------

usethis::use_test("regexp__file_extensions_as_pattern")
usethis::use_test("SYS_VALID_CONF_EXTENSIONS")
usethis::use_test("SYS_DISREGARDED_CONF_EXTENSIONS")
usethis::use_test("conf_load_from_dir")
