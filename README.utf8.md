---
output: github_document
editor_options: 
  chunk_output_type: console
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# confx

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/confx)](https://CRAN.R-project.org/package=confx)
<!-- badges: end -->

Extends the scope of [{config}](https://www.github.com/rstudio/config) by offering path-like retrieval, queries for
unnamed config entities and referencing of entities. Config file content can be
cached in-memory and can then either be retrieved from cache or from file as
desired.

## Installation

Development version from [GitHub](https://github.com/) with:


```r
remotes::install_github("rappster/confx")
```

## Usage

### TL;DR

Suppose you have a config file `config.yml` in your package's root directory,
you either call


```r
conf_get("path/to/named/entity")
```

or 


```r
conf_get("path/to/unnamed/entity/with/query/<query>")
```

depending on what type of config entity you want to retrieve (named vs. unnamed
entity)

For more detailed explanation of the package continue reading

### Demo preliminaries


```r
library(confx)
#> Warning: replacing previous import 'magrittr::set_names' by 'purrr::set_names'
#> when loading 'confx'
```

The package ships with a demo YAML config file:


```r
(path_to_config <- fs::path_package("confx", "configs/config.yml"))
#> /media/janko/Shared/Code/R/Packages/confx/renv/library/R-4.0/x86_64-pc-linux-gnu/confx/configs/config.yml
```

You can use this file by setting the following environment variable:


```r
Sys.setenv(R_CONFIG_DIR = fs::path_package("confx", "configs"))
```

### Get named entities

Entire config content:


```r
conf_get()
#> $host
#> $host$server_001
#> $host$server_001$url
#> [1] "https://dev-server-001.com"
#> 
#> $host$server_001$port
#> [1] 8000
#> 
#> 
#> 
#> $settings_versions
#> $settings_versions[[1]]
#> $settings_versions[[1]]$id
#> [1] "v1"
#> 
#> $settings_versions[[1]]$valid_from
#> [1] "2020-01-01"
#> 
#> $settings_versions[[1]]$valid_until
#> [1] "2020-03-31"
#> 
#> $settings_versions[[1]]$content
#> [1] "hello world!"
#> 
#> 
#> $settings_versions[[2]]
#> $settings_versions[[2]]$id
#> [1] "v2"
#> 
#> $settings_versions[[2]]$valid_from
#> [1] "2020-04-01"
#> 
#> $settings_versions[[2]]$valid_until
#> [1] "2020-09-30"
#> 
#> $settings_versions[[2]]$content
#> [1] "Hello World!"
#> 
#> 
#> $settings_versions[[3]]
#> $settings_versions[[3]]$id
#> [1] "v3"
#> 
#> $settings_versions[[3]]$valid_from
#> [1] "2020-10-01"
#> 
#> $settings_versions[[3]]$valid_until
#> [1] "2020-12-31"
#> 
#> $settings_versions[[3]]$content
#> [1] "HELLO WORLD!"
#> 
#> 
#> 
#> attr(,"config")
#> [1] "default"
#> attr(,"file")
#> [1] "/media/janko/Shared/Code/R/Packages/confx/renv/library/R-4.0/x86_64-pc-linux-gnu/confx/configs/config.yml"
```

Entity `host`:


```r
conf_get("host")
#> $server_001
#> $server_001$url
#> [1] "https://dev-server-001.com"
#> 
#> $server_001$port
#> [1] 8000
```

Entity `host` but from different config environment:


```r
conf_get("host", config = "prod")
#> $server_001
#> $server_001$url
#> [1] "https://prod-server-001.com"
#> 
#> $server_001$port
#> [1] 8000
#> 
#> 
#> $server_002
#> $server_002$url
#> [1] "https://prod-server-002.com"
#> 
#> $server_002$port
#> [1] 8000
```

Entity `host/server_001`:


```r
conf_get("host/server_001")
#> $url
#> [1] "https://dev-server-001.com"
#> 
#> $port
#> [1] 8000
```

Entity `host/server_001/url`


```r
conf_get("host/server_001/url")
#> [1] "https://dev-server-001.com"
```

### Get unnamed entities

For unnamed entities (which parse into unnamed lists), you can specify a query consisting of a standard R expression written out as a string:


```r
conf_get("settings_versions/id == 'v1'")
#> [[1]]
#> [[1]]$id
#> [1] "v1"
#> 
#> [[1]]$valid_from
#> [1] "2020-01-01"
#> 
#> [[1]]$valid_until
#> [1] "2020-03-31"
#> 
#> [[1]]$content
#> [1] "hello world!"
```


```r
conf_get("settings_versions/valid_from >= '2020-03-01'")
#> [[1]]
#> [[1]]$id
#> [1] "v2"
#> 
#> [[1]]$valid_from
#> [1] "2020-04-01"
#> 
#> [[1]]$valid_until
#> [1] "2020-09-30"
#> 
#> [[1]]$content
#> [1] "Hello World!"
#> 
#> 
#> [[2]]
#> [[2]]$id
#> [1] "v3"
#> 
#> [[2]]$valid_from
#> [1] "2020-10-01"
#> 
#> [[2]]$valid_until
#> [1] "2020-12-31"
#> 
#> [[2]]$content
#> [1] "HELLO WORLD!"
```


```r
conf_get("settings_versions/
  valid_from >= '2020-03-01' & 
  valid_until >= '2020-10-01'")
#> [[1]]
#> [[1]]$id
#> [1] "v3"
#> 
#> [[1]]$valid_from
#> [1] "2020-10-01"
#> 
#> [[1]]$valid_until
#> [1] "2020-12-31"
#> 
#> [[1]]$content
#> [1] "HELLO WORLD!"
```

**DISCLAIMER**

When I said *standard R expressions*, this does not yet reflect the full picture as I started with simple expressions as defined in `valid_operators_logical()`


```r
confx:::valid_operators_logical()
#>      ==      !=    %in%   %!in%       <      <=       >      >= 
#>    "=="    "!="  "%in%" "%!in%"     "<"    "<="     ">"    ">="
```

In future releases, you will also (hopefully) be able to write something like
this:


```r
conf_get("settings_versions/
  stringr::str_detect(content, 'HELLO')")
#> NULL
```

### Entity references

TODO
