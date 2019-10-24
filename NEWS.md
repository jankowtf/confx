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

- File `NEWS.md` file to track changes to the package.
- File `BACKLOG.md` file to track backlog items
- Package dependency `here` to `Imports:` in `DESCRIPTION`
- Package dependency `config` to `Imports:` in `DESCRIPTION`
- Package dependency `magrittr` to `Imports:` in `DESCRIPTION`
- Enabled `testthat`
- File `/config.yml`
- File `/tests/testthat/config.yml`
- File `/tests/testthat/config_2.yml`
- Function `load()` (exported)
- Function `get()` (exported)
- Function `assign()` (exported)
- Function `merge()` (exported)
- Function `get_list_element_recursively()`
- Function `has_inherited()`
- Function `resolve_inherited()`
- Function `merge_inherited()`
- Function `handle_inherited()`
