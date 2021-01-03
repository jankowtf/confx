load_conf <- function(
  # dir = here::here(),
  # from = here::here(),
  from = getwd(),
  pattern_disregard = "^(_|\\.|codecov|travis)"
) {
  .Deprecated("conf_load")
  conf_files <- fs::dir_ls(from, type = "file", regexp = "\\.yml$")

  # Filter out special configs such as for TravisCI and `{covr}`:
  idx <- conf_files %>%
    fs::path_file() %>%
    stringr::str_detect(pattern_disregard, negate = TRUE)
  conf_files <- conf_files[idx]

  # Read config file content and put it into an actual option:
  conf_files %>%
    purrr::walk(conf_load__inner)

  conf_files
}

conf_load__inner <- function(
  .file,
  .sep_opt_name = "_",
  .verbose = TRUE
) {
  .Deprecated("conf_load_from_file")
  if (.verbose) {
    message(stringr::str_glue(
      "Loading configs into options: {fs::path_file(.file)}"))
  }
  pkg <- devtools::as.package(".")$package
  # opt_name <- fs::path_file(.file)
  opt_name <- stringr::str_glue("{pkg}{.sep_opt_name}{fs::path_file(.file)}")
  # print(opt_name)
  arg_list <- list(config::get(file = .file)) %>%
    purrr::set_names(opt_name)
  rlang::call2(quote(options), !!!arg_list) %>%
    rlang::eval_tidy()
}

# Tokenize ----------------------------------------------------------------

#' Tokenize query
#'
#' @param query
#' @param ops
#'
#' @return
#'
#' @examples
tokenize_query <- function(
  query,
  ops = valid_operators_query_chain()
) {
  .Deprecated("parse_query")

  for (.op in ops) {
    query <- query %>%
      purrr::map(~stringr::str_split(.x, stringr::fixed(.op)) %>% unlist()) %>%
      unlist()
  }

  query
}

#' Tokenize query items
#'
#' @param query
#' @param ops
#'
#' @return
#'
#' @examples
tokenize_query_items <- function(
  query,
  ops = valid_operators_logical()
) {
  .Deprecated("parse_query")

  # Extract operators
  ops <- query %>% extract_query_operators(ops = ops)

  # Early exit
  # if (all(op %>% purrr::map_int(~.x %>% length()) == 0)) {
  #   query <- list(
  #     list(
  #       query,
  #       query
  #     )
  #   ) %>%
  #     purrr::set_names("==")
  #   return(query)
  # }

  # Tokenize subqueries
  query <- purrr::map2(query, ops, function(.query, .op) {
    # Handle extracted operators
    .op <- .op %>% handle_extracted_operators()

    .query %>%
      # Tokenize query item
      tokenize_query_item(op = .op) %>%
      # Parse right-hand side
      parse_query_rhs()
  }) %>%
    purrr::set_names(ops)

  # Handle vectorized
  query %>% handle_query_vectorized()
}

#' Tokenize query item
#'
#' @param query
#' @param op
#'
#' @return
#'
#' @examples
tokenize_query_item <- function(query, op) {
  .Deprecated("parse_query")

  query %>%
    stringr::str_split(stringr::fixed(op)) %>%
    unlist() %>%
    as.list()
}

# Handler -----------------------------------------------------------------

#' Handle query result
#'
#' Handle vector results and apply recursive chain logic.
#'
#' @param result
#' @param ops
#' @param resolve_fn
#'
#' @return
#'
#' @examples
handle_query_result <- function(result, ops, handler_fn = all) {
  .Deprecated("Not need anymore, see 'apply_query_iter_2()'")
  # Handle vector result
  # Right-hand side is already handled by 'handle_query_vectorized()', but
  # the left-hand side can also be responsible for vector results. However,
  # the latter is impossible/hard to test for this before actually evaluating
  # the query, so handling needs to take place "after the fact"
  result <- handle_query_result_vectorized(
    result = result,
    ops = ops
  )

  # Apply recursive chain logic
  apply_recursive_logic(
    x = result,
    ops = ops
  )
}

#' Handle vectorized query result
#'
#' @param result
#' @param op
#' @param fn
#'
#' @return
#'
#' @examples
handle_query_result_vectorized <- function(
  result,
  ops,
  fn = all
) {
  .Deprecated("Not need anymore, see 'apply_query_iter_2()'")
  if (all(
    stringr::str_detect(
      ops,
      stringr::fixed(valid_operators_query_chain("|")))
  )) {
    fn <- any
  }

  fn(result)
}

#' Handle extracted operator
#'
#' TODO-20201229-1121: Handle multiple extracted operators
#'
#' @param op
#'
#' @return
#'
#' @examples
handle_extracted_operators <- function(op) {
  .Deprecated("parse_query")

  op %>%
    sort() %>%
    max()
}

#' Handle vectorized query
#'
#' @param query
#'
#' @return
#'
#' @examples
handle_query_vectorized <- function(
  query
) {
  .Deprecated("handle_query_vectorized_2")
  query %>% purrr::imap(function(.query, .op) {
    # LEGACY (keep as reference)
    # .op_orig <- .op
    #
    # Translate %in% queries
    # .op <- if (.op %in% c("==", "!=") && length(.query[[2]]) > 1) {
    #   "%in%"
    # } else {
    #   .op
    # }
    #
    # # Translate != queries
    # if (.op_orig == "!=" && length(.query[[2]]) > 1) {
    #   list(
    #     list(.query) %>%
    #       purrr::set_names(.op)
    #   ) %>%
    #     purrr::set_names("!")
    # } else {
    #   list(.query) %>%
    #     purrr::set_names(.op)
    # }

    if (length(.query[[2]]) > 1) {
      wrap_query_with_fn(
        query = .query,
        op = .op
      )
    } else {
      list(.query) %>%
        purrr::set_names(.op)
    }
  }) %>%
    purrr::flatten()
}

# Apply -------------------------------------------------------------------

#' Apply query (outer)
#'
#' @param on
#' @param query
#' @param ops
#' @param verbose [[logical]]
#'
#' @return
#'
#' @examples
apply_query_iter <- function(
  on,
  query,
  ops,
  verbose = FALSE
) {
  .Deprecated("apply_query_iter_2")

  on %>%
    purrr::keep(function(.on) {
      .on %>%
        # Apply query
        apply_query(query = query, verbose = verbose) %>%
        # Handle query result
        handle_query_result(ops = ops)
    })
}

#' Apply query (inner)
#'
#' @param on
#' @param query
#' @param verbose [[logical]]
#'
#' @return
#'
#' @examples
apply_query <- function(
  on,
  query,
  verbose = FALSE
) {
  .Deprecated("apply_query_2")
  # result <- query %>% purrr::imap_lgl(function(.query, .op) {
  result <- query %>% purrr::imap(function(.query, .op) {
    result <- if (length(.query) > 1) {
      eval_query_call_two_args(.op, .query, on, verbose = verbose)
    } else {
      eval_query_call_one_arg(.op, .query, on, verbose = verbose)
    }

    # Antifragile patch
    if (!length(result)) {
      FALSE
    } else {
      result
    }
  }) %>%
    unlist() %>%
    unname()

  result
}

apply_recursive_logic <- function(x, ops) {
  .Deprecated("Not need anymore, see 'apply_query_iter_2()'")

  if (length(ops) && !is.na(x[2])) {
    # Compute logic result
    result <- rlang::call2(
      # Logical function
      ops[1],
      # Item 1
      x[1],
      # Item 2
      x[2]
    ) %>%
      rlang::eval_tidy()

    # Substitute second element
    x[2] <- result

    # Continue with first elements removed
    Recall(x[-1], ops[-1])
  } else {
    x
  }
}

# Parse -------------------------------------------------------------------

#' Parse right-hand side of query
#'
#' Takes care of transforming a vector notation into an actual vector for the
#' second query subitem
#'
#' @param query
#'
#' @return
#'
#' @examples
parse_query_rhs <- function(query) {
  .Deprecated("parse_query")

  # LEGACY
  # if (query[[2]] %>% stringr::str_detect("c\\(.*\\)")) {
  #   # LEGACY
  #   query[[2]] <- query[[2]] %>%
  #     # stringr::str_remove_all("\\(|\\)") %>%
  #     # stringr::str_split(",") %>%
  #     # unlist() %>%
  #     # stringr::str_squish()
  #
  #     # Better
  #     rlang::parse_expr()
  # }

  query[[2]] <- query[[2]] %>%
    rlang::parse_expr()

  query
}

# Wrap --------------------------------------------------------------------

#' Wrap query with additional function
#'
#' @param query
#' @param op
#' @param fn
#'
#' @return
#'
#' @examples
wrap_query_with_fn <- function(
  query,
  op,
  fn = "all"
) {
  .Deprecated("handle_query_vectorized_2")

  # Input handling
  pattern <- valid_operators_logical(c("<", ">", "%in%"), as_regexp = TRUE)

  if (stringr::str_detect(op, pattern)) {
    fn <- "any"
  }

  list(
    list(query) %>%
      purrr::set_names(op)
  ) %>%
    purrr::set_names(fn)
}

# Extract -----------------------------------------------------------------

extract_query_operators <- function(
  query,
  ops = valid_operators_logical()
) {
  .Deprecated("parse_query")
  query %>%
    purrr::map(function(.x) {
      .x %>%
        stringr::str_extract(
          stringr::fixed(ops)
        ) %>%
        drop_missing() %>%
        sort() %>%
        {
          if (length(.)) {
            max(.)
          } else {
            .
          }
        }
    })
}

extract_chain_operators <- function(query) {
  .Deprecated("parse_query")

  ops <- valid_operators_query_chain()

  # Identify location(s) per operator
  ops_index <- ops %>%
    purrr::map(function(.op) {
      indexes <- stringr::str_locate_all(
        query,
        stringr::fixed(.op)
      )
      indexes[[1]][, "start"]
    }) %>%
    # purrr::flatten() %>%
    purrr::set_names(ops)

  # Sort locations and grab the names which correspond to operators
  ops_order <- ops_index %>%
    unlist() %>%
    sort() %>%
    names() %>%
    stringr::str_remove("\\.start")

  ops_order
}
