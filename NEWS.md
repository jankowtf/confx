# confx 0.0.0.9024 (2021-03-23)

Removed accidental dependency on `renvx`

--------------------------------------------------------------------------------

# confx 0.0.0.9023 (2021-02-26)

Added package dependency {here}

- Added package dependency {here} to `Imports`

--------------------------------------------------------------------------------

# confx 0.0.0.9022 (2021-01-12)

Absolute paths

- Fixed bug for cases when `from` corresponds to an absolute paths in call to
`conf_get()`
- Added unit test for absolute paths
- Aligned some unit tests to 3rd edition of `{testthat}`

# confx 0.0.0.9021 (2021-01-04)

Remote dependency

- Added remote dependency `{rappster/valid}` in `DESCRIPTION` file

--------------------------------------------------------------------------------

# confx 0.0.0.9020 (2021-01-03)

Queries for unnamed entities

Fixed/closed:

Changed:

- Changed default repository to https://packagemanager.rstudio.com/all/__linux__/focal/latest
- Changed repository from CRAN to RSPM
- More systematic YAML files for unit tests:
    - Changed `tests/testthat/config_2.yml` to ``tests/testthat/config_002.yml`
- Renamed:
    - `test-conf_get.R` to `test-get.R`
    - `conf_index_recursively()` to `subset_recursively()`
- Refactored:
    - `subset_recursively()`
    - `handle_conf_query()`
- Moved
    - `subset_recursively()` to `R/subset.R`
    - Content of `R/packages.R` into `R/confx-package.R`. Deleted `R/packages.R`
    
New:

- Added functions:
    - `handle_conf_query()`
    - `parse_query()`
    - `handle_query_vectorized_2()`
    - `apply_query_iter_2()`
    - `apply_query_2()`
    - `eval_query_call_one_arg()`
    - `eval_query_call_two_args()`
    - `valid_operators_logical()`
    - `drop_missing()`
    - `%!in%()`
- Added unit tests:
    - `test-get_with_query.R`
- Misc:
    - Using `{styler}`

--------------------------------------------------------------------------------

# confx 0.0.0.9019 (development version)

Temporary switch of config environment

Fixed/closed:

Changed:

- Added function args `config` and `use_parent` to `conf_get()` so they can be
passed along to `config::get()`
    
New:

--------------------------------------------------------------------------------

# confx 0.0.0.9018 (development version)

Inter-file JSON referencing, naming convention alignment and `{renv}` alignment

Fixed/closed:

- `{renv}` warnings due to changed caching paradigm

Changed:

- Updated some `{renv}` dependencies
- Renamed multiple functions to `conf_*` schema
    
New:

- Added and tested inter-file JSON referencing

--------------------------------------------------------------------------------

# confx 0.0.0.9017 (development version)

`R_CONFIG_DIR` for `conf_load()`

Fixed/closed:

Changed:

- Changed default value of `dir_from` to use env var `R_CONFIG_DIR` if it exists:

    - `conf_load()`
    
New:

--------------------------------------------------------------------------------

# confx 0.0.0.9016 (development version)

Default value of `dir_from` via environment variable `R_CONFIG_DIR` if specified

Fixed/closed:

Changed:

- Changed default value of `dir_from` to use env var `R_CONFIG_DIR` if it exists:

    - `conf_get()`
    - `conf_assign()`
    - `load_conf()`
    - `load_conf_from_dir()`
    - `handle_conf_reference()`
    - `conf_handle_inherited()`
    
New:

--------------------------------------------------------------------------------

# confx 0.0.0.9015 (development version)

Swapped `here::here()` for `getwd()` to facilitate usage in built packages

Fixed/closed:

Changed:

- Swapped `here::here()` for `getwd()` in:

    - `conf_get()`
    - `conf_assign()`
    - `load_conf()`
    - `load_conf_from_dir()`
    - `handle_conf_reference()`
    - `conf_handle_inherited()`
    - `conf_load()`

New:

--------------------------------------------------------------------------------

# confx 0.0.0.9014 (development version)

No changelog

--------------------------------------------------------------------------------

# confx 0.0.0.9013 (development version)

Experimenting with references as specified in https://swagger.io/docs/specification/using-ref/

Fixed/closed:

Changed:

- Updated package deps and created local project library for Linux

New:

--------------------------------------------------------------------------------

# confx 0.0.0.9013 (development version)

Experimenting with references as specified in https://swagger.io/docs/specification/using-ref/

Fixed/closed:

Changed:

- Updated package deps and created local project library for Linux

New:

--------------------------------------------------------------------------------

# confx 0.0.0.9012 (development version)

Fixed `from` in `conf_assign()`

Fixed/closed:

- Fixed `from` in `conf_assign()`

Changed:

New:

--------------------------------------------------------------------------------


# confx 0.0.0.9011 (development version)

Arg `leaf_as_list`

Fixed/closed:

Changed:

- Character input for referenced configs in `conf_assign()` now allowed. Powered
by introducing arg `leaf_as_list = TRUE/FALSE` in `conf_get()` and
`conf_index_recursively()`
- Modified `README.Rmd`

New:

--------------------------------------------------------------------------------

# confx 0.0.0.9010 (development version)

Internal config files and `force_from_file`

Fixed/closed:

Changed:

- Calls to `system.file()` inside `onAttach()` to load internal configs instead
of configs from package/project root directory
- Aligned `conf_get()` to new option name that are prefixed with `<pkg_name>_`
- Changed function prefixes from `config_` to `conf_` for brevity

New:

- File `/inst/config.yml`
- Encapsulated inner function of `conf_load()` into own function
`conf_load__inner()`
- Function `conf_auto_load()`
- Function `conf_auto_load_internal()`
- Argument `force_from_file = FALSE` in `conf_get()`

--------------------------------------------------------------------------------

# confx 0.0.0.9009 (development version)

## Summary

v0.0.0.9009: More unit tests

## Fixed/closed

## Changed

- Changed regex pattern to YAML files to disregard (`pattern_disregard =
"^(_|\\.|codecov|travis)"`)

## New

- Unit tests for `.onLoad()` and `.onAttach()`
- Enabled markdown in Roxygen code

--------------------------------------------------------------------------------

# confx 0.0.0.9008 (development version)

## Summary

v0.0.0.9008: Updated `.travis.yml`

## Fixed/closed

- Fixed warnings in doc

## Changed

- Updated `.travis.yml` (`warnings_are_errors` and `branches`)
- Removed `skip_on_travis()`

## New

--------------------------------------------------------------------------------

# confx 0.0.0.9007 (development version)

## Summary

v0.0.0.9007: Inter config references

## Fixed/closed

- Fixed warnings in doc

## Changed

- Robustified `conf_merge_lists()` (`!is.list()` instead of `is.vector()`) and modified for being able to also handle initial non-list inputs

## New

- Function `conf_has_config_reference()` for checking for inter config
references
- Function `conf_resolve_config_reference()` for resolving inter config
references
- Function `conf_handle_config_reference()` as a handler wrapper for inter
config references
- Dependency `{stringr}`
- Dependency `{devtools}` (suggested)
- Added all `Imports` dependencies to `/R/packages.R` for roxygen to pick them
up for the `NAMESPACE` file

--------------------------------------------------------------------------------

# confx 0.0.0.9006 (development version)

## Summary

v0.0.0.9006: Modified `.travis.yml` to enable `{covr}` and `codecov.io` and
modified roxygen doc

## Fixed/closed

## Changed

- Updated roxygen doc

## New

- Modified `.travis.yml` to enable `{covr}` and `codecov.io`

--------------------------------------------------------------------------------

# confx 0.0.0.9005 (development version)

## Summary

v0.0.0.9005: Modified `.travis.yml` to display test results on Travis CI

## Fixed/closed

## Changed

## New

- Modified `.travis.yml` to display test results on Travis CI

--------------------------------------------------------------------------------

# confx 0.0.0.9004 (development version)

## Summary

v0.0.0.9004: Added skip_on_travis() to tests

## Fixed/closed

## Changed

## New

- Added `skip_on_travis()` to tests

--------------------------------------------------------------------------------

# confx 0.0.0.9003 (development version)

## Summary

v0.0.0.9003: Deleted /man/hello.Rd

## Fixed/closed

## Changed

- Deleted `/man/hello.Rd`

## New

--------------------------------------------------------------------------------

# confx 0.0.0.9002 (development version)

## Summary

v0.0.0.9002: Prefix 'conf' in function names, Travis CI, {covr}, {lifecycle}

## Fixed/closed

## Changed

- Renamed `load()` to `conf_load()` 
- Renamed `get()` to `conf_get()`
- Renamed `assign()` to `conf_assign()`
- Renamed `merge()`  to `conf_merge()` 
- Renamed `get_list_element_recursively()` to `conf_index_recursively()`
- Renamed `has_inherited()` to `conf_has_inherited()`
- Renamed `resolve_inherited()` to `conf_resolve_inherited()`
- Renamed `merge_inherited()` to `conf_merge_inherited()`
- Renamed `handle_inherited()` to `conf_handle_inherited()`

## New

- File `README.Rmd`
- Enabled `Travis CI`
- Enabled `{covr}`

--------------------------------------------------------------------------------

# confx 0.0.0.9001 (development version)

## Summary

Auto load in `.onAttach()`

## Fixed/closed

## Changed

## New

- Function `.onLoad()`
- Function `.onAttach()`
- Possibility to automatically load config files in root directory on attach
(`.onAttach()`) controlled via env variable `CONFX_AUTO_LOAD = TRUE/FALSE`

--------------------------------------------------------------------------------

# confx 0.0.0.9000 (development version)

## Summary

Initial version

## Fixed/closed

## Changed

## New

- File `README.Rmd`
- File `NEWS.md` file to track changes to the package.
- File `BACKLOG.md` file to track backlog items
- Package dependency `here` to `Imports:` in `DESCRIPTION`
- Package dependency `config` to `Imports:` in `DESCRIPTION`
- Package dependency `magrittr` to `Imports:` in `DESCRIPTION`
- Enabled `{testthat}`
- Enabled `Travis CI`
- Enabled `{covr}`
- File `/config.yml`
- File `/tests/testthat/config.yml`
- File `/tests/testthat/config_2.yml`
- Function `conf_load()` (exported)
- Function `conf_get()` (exported)
- Function `conf_assign()` (exported)
- Function `conf_merge()` (exported)
- Function `conf_index_recursively()`
- Function `conf_has_inherited()`
- Function `conf_resolve_inherited()`
- Function `conf_merge_inherited()`
- Function `conf_handle_inherited()`
