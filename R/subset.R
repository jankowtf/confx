#' Subset object recursively
#'
#' TODO-20191026-5: Write doc for `subset_recursively()`
#'
#' @param x [[list]]
#' @param index [[character]]
#' @param leaf_as_list [[logical]]
#' @param .index_trace [[character]]
#' @param .level_trace [[character]]
#' @param verbose [[logical]]
#'
#' @return [[character]] or [[list]]
subset_recursively <- function(
  x,
  index,
  leaf_as_list = FALSE,
  .index_trace = index,
  .level_trace = 1,
  verbose = FALSE
) {
  # Reached leaf
  if (!is.list(x)) {
    return(x)
  }

  index_this <- index[1]

  # Element not in list and no suitable list-oriented query
  if (
    !(index[1] %in% names(x)) &&
      !is.null(names(x)) &&
      !any(
        op <- stringr::str_detect(
          index_this,
          valid_operators_logical()
        )
      )
  ) {
    message("Current list branch:")
    message(str(x))
    message("Trace of indexing vec (last element is invalid):")
    message(stringr::str_c(.index_trace[.level_trace], collapse = "/"))
    stop(stringr::str_glue("No such element in list: {index[1]}"))
  }

  # Index:
  x <- if (!leaf_as_list || length(index) > 1) {
    # Handle queries
    if (is.null(names(x))) {#&&
      if (any(
        op <- stringr::str_detect(
          index_this,
          valid_operators_logical()
        )
      )
      ) {
        handle_conf_query(
          x = x,
          query = index_this,
          op = op,
          verbose = verbose
        )
      } else {
        if (stringr::str_detect(index[1], "\\d+$")) {
          x[[ as.numeric(index[1]) ]]
        } else {
          x[[1]][[ index[1] ]]
        }
      }
    } else {
      x[[ index[1] ]]
    }
  } else {
    if (is.null(names(x))) {
      if (any(
        op <- stringr::str_detect(
          index_this,
          valid_operators_logical()
        )
      )
      ) {
        handle_conf_query(
          x = x,
          query = index_this,
          op = op,
          verbose = verbose
        )
      } else {
        if (stringr::str_detect(index[1], "\\d+$")) {
          x[[ as.numeric(index[1]) ]]
        } else {
          x[[1]][[ index[1] ]]
        }
      }
    } else {
      x[ index[1] ]
    }
  }

  if (!is.na(index[2])) {
    # Continue if there are additional elements in `index` vec
    Recall(
      x = x,
      index = index[-1],
      leaf_as_list = leaf_as_list,
      .index_trace = .index_trace,
      .level_trace = 1:(.level_trace + 1),
      verbose = verbose
    )
  } else {
    # Otherwise return last indexing result
    x
  }
}
