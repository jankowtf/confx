# Main --------------------------------------------------------------------

#' Handle config query
#'
#' Currently, this is a list-oriented query
#'
#' @param x
#' @param op
#' @param query
#' @param verbose [[logical]]
#'
#' @return
#'
#' @examples
handle_conf_query <- function(
  x,
  query,
  op,
  verbose = FALSE
) {
  # LEGACY (KEEP AS REFERENCE FOR A WHILE)
  if (FALSE) {
    # Extract chain operators
    ops_chain <- extract_chain_operators(query)

    # Tokenize
    query_v1 <- query %>%
      # Tokenize queryL
      tokenize_query() %>%
      # Tokenize query items
      tokenize_query_items()

    apply_query_iter(
      on = x,
      query = query,
      ops = ops_chain,
      verbose = verbose
    )
  }

  # Parse
  query <- query %>%
    parse_query() %>%
    list()

  apply_query_iter_2(
    on = x,
    query = query,
    verbose = verbose
  )
}

# Parse -------------------------------------------------------------------

#' Parse query
#'
#' @param query
#'
#' @return
#'
#' @importFrom purrr map
#' @importFrom rlang parse_expr
#' @examples
parse_query <- function(
  query) {
  if (all(inherits(query, "character"))) {
    query <- query %>%
      rlang::parse_expr() %>%
      as.list()
  }

  query %>%
    purrr::map(function(.query) {
      # .query
      if (
        inherits(.query, "call")
      ) {
        if (as.character(.query[[1]]) %in% valid_operators_logical()) {
          parse_query(as.list(.query))
        } else {
          .query
        }
      } else if (inherits(.query, "(") |
          inherits(.query, "{")
      ) {
        .query <- as.list(.query)
        .query[[2]] <- parse_query(as.list(.query[[2]]))
        .query
      } else {
        .query
      }
    })
}

# Handle ------------------------------------------------------------------

#' Handle vectorized query
#'
#' @param call
#' @param fn
#'
#' @return
#'
#' @importFrom rlang call2
#' @importFrom stringr str_detect
#' @examples
handle_query_vectorized_2 <- function(
  call,
  fn = "all") {
  # Input handling
  call_list <- call %>% as.list()

  if (
    length(call_list[[2]]) > 1 |
      length(call_list[[3]]) > 1
  ) {
    op <- call_list[[1]]
    pattern <- valid_operators_logical(c("<", ">", "%in%"), as_regexp = TRUE)

    if (stringr::str_detect(op, pattern)) {
      fn <- "any"
    }

    rlang::call2(
      fn,
      call
    )
  } else {
    call
  }
}

# Apply -------------------------------------------------------------------

#' Apply query
#'
#' @param on
#' @param query
#' @param verbose
#'
#' @return
#'
#' @importFrom purrr map
#' @examples
apply_query_2 <- function(
  on,
  query,
  verbose = FALSE
) {
  query
  # result <- query %>% purrr::imap_lgl(function(.query, .op) {
  result <- query %>%
    purrr::map(function(.query, .op) {
      # browser()
      .op <- .query[[1]]
      .query <- .query[-1]

      if (length(.query) > 1) {
        query_fn <- eval_query_call_two_args
      } else {
        query_fn <- eval_query_call_one_arg
      }

      result <- query_fn(
        .op = .op,
        .query = .query,
        on = on,
        recursive_fn = apply_query_2,
        verbose = verbose
      )

      if (verbose) {
        print(on)
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

#' Apply query iteratively
#'
#' @param on
#' @param query
#' @param verbose
#'
#' @return
#'
#' @importFrom purrr keep
#' @examples
apply_query_iter_2 <- function(
  on,
  query,
  verbose = FALSE) {
  on %>%
    purrr::keep(function(.on) {
      # Apply query
      apply_query_2(
        on = .on,
        query = query,
        verbose = verbose
      )
    })
}

# Eval --------------------------------------------------------------------

#' Eval query call (two args)
#'
#' @param .op
#' @param .query
#' @param on
#' @param verbose [[logical]]
#' @param recursive_fn
#'
#' @return
#'
#' @importFrom rlang call2 eval_tidy
#' @importFrom usethis ui_info ui_line
#' @examples
eval_query_call_two_args <- function(
  .op,
  .query,
  on,
  recursive_fn = apply_query,
  verbose = FALSE) {
  call <- rlang::call2(
    # Function
    .op,
    # Value in list
    if (!is.list(.query[[1]])) {
      on[[.query[[1]]]]
    } else {
      recursive_fn(on = on, query = .query[1], verbose = verbose)
    },
    # Value to query
    # .query[[2]]
    if (!is.list(.query[[2]])) {
      # on[[.query[[2]]]]
      .query[[2]]
    } else {
      recursive_fn(on = on, query = .query[2], verbose = verbose)
    },
  )

  # Handle vectorized query/call
  call <- handle_query_vectorized_2(
    call = call
  )

  if (verbose) {
    usethis::ui_info("Query:")
    usethis::ui_line(deparse(call))
  }

  result <- call %>%
    rlang::eval_tidy()

  result
}

#' Eval query call (one argument)
#'
#' @param .op
#' @param .query
#' @param on
#' @param verbose [[logical]]
#' @param recursive_fn
#'
#' @return
#'
#' @importFrom rlang call2 eval_tidy
#' @importFrom usethis ui_info ui_line
#' @examples
eval_query_call_one_arg <- function(
  .op,
  .query,
  on,
  recursive_fn = apply_query,
  verbose = FALSE) {
  call <- rlang::call2(
    # Function
    .op,
    # Value in list
    if (!is.list(.query[[1]])) {
      if (inherits(.query[[1]], "call")) {
        recursive_fn(on = on, query = .query[1], verbose = verbose)
      } else {
        on[[.query[[1]]]]
      }
    } else {
      recursive_fn(on = on, query = .query[1], verbose = verbose)
    }
  )

  if (verbose) {
    usethis::ui_info("Query:")
    usethis::ui_line(deparse(call))
  }

  call %>%
    rlang::eval_tidy()
}
