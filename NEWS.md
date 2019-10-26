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
