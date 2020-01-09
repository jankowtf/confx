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
