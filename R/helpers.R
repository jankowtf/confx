#' Title
#'
#' TODO-20191026-5: Write doc for `conf_index_recursively()`
#'
#' @param lst [[list]]
#' @param el [[character]]
#' @param leaf_as_list [[logical]]
#' @param .el_trace [[character]]
#' @param .level_trace [[character]]
#'
#' @return [[character]] or [[list]]
conf_index_recursively <- function(
  lst,
  el,
  leaf_as_list = FALSE,
  .el_trace = el,
  .level_trace = 1
) {
  # Reached leaf:
  if (!is.list(lst)) {
    return(lst)
  }

  # Element not in list:
  if (!(el[1] %in% names(lst))) {
    message("Current list branch:")
    message(str(lst))
    message("Trace of indexing vec (last element is invalid):")
    message(stringr::str_c(.el_trace[.level_trace], collapse = "/"))
    stop(stringr::str_glue("No such element in list: {el[1]}"))
  }

  # Index:
  lst <- if (!leaf_as_list || length(el) > 1) {
    lst[[ el[1] ]]
  } else {
    lst[ el[1] ]
  }

  if (!is.na(el[2])) {
    # Continue if there are additional elements in `el` vec
    Recall(lst, el[-1], leaf_as_list,
      .el_trace, .level_trace = 1:(.level_trace + 1))
  } else {
    # Otherwise return last indexing result:
    lst
  }
}

#' Title
#'
#' TODO-20191026-6: Write doc for `conf_merge_lists()`
#'
#' @param base_list [[list]]
#' @param overlay_list [[list]]
#' @param recursive [[logical]]
#' @param is_vector [[logical]]
#'
#' @return [[list]]
conf_merge_lists <- function (
  base_list,
  overlay_list,
  recursive = TRUE,
  is_vector = FALSE
) {
  if (length(base_list) == 0)
    overlay_list
  else if (length(overlay_list) == 0)
    base_list
  else {
    merged_list <- base_list

    # Handle case when list structure is only imposed by `inherits: <reference>`:
    if (!is_vector && !is.list(merged_list)) {
      merged_list <- list(merged_list)
      is_vector <- TRUE
    }

    # Early exit for vectors instead of lists:
    if (is_vector) {
      return(c(merged_list, overlay_list))
    }

    for (name in names(overlay_list)) {
      base <- base_list[[name]]
      overlay <- overlay_list[[name]]
      if (is.list(base) && is.list(overlay) && recursive) {
        merged_list[[name]] <- conf_merge_lists(base, overlay)
      # } else if (is.vector(base) && is.vector(overlay) && recursive) {
      } else if (!is.list(base) && !is.list(overlay) && recursive) {
        merged_list[[name]] <- conf_merge_lists(base, overlay, is_vector = TRUE)
      } else {
        merged_list[[name]] <- NULL
        merged_list <- append(merged_list,
          # if (!is_vector) {
            overlay_list[which(names(overlay_list) %in% name)]
          # } else {
          #   overlay_list[[which(names(overlay_list) %in% name)]]
          # }
        )
      }
    }
    merged_list
  }
}
