#' Title
#'
#' TODO-20191026-5: Write doc for `conf_index_recursively()`
#'
#' @param lst [[list]]
#' @param el [[character]]
#' @param .el_trace [[character]]
#' @param .level_trace [[character]]
#'
#' @return [[character]] or [[list]]
conf_index_recursively <- function(
  lst,
  el,
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
  lst <- lst[[ el[1] ]]

  if (!is.na(el[2])) {
    # Continue if there are additional elements in `el` vec
    Recall(lst, el[-1], .el_trace, .level_trace = 1:(.level_trace + 1))
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

    # Early exit for vectors instead of lists:
    if (is_vector) {
      return(c(merged_list, overlay_list))
    }

    for (name in names(overlay_list)) {
      base <- base_list[[name]]
      overlay <- overlay_list[[name]]
      if (is.list(base) && is.list(overlay) && recursive) {
        merged_list[[name]] <- conf_merge_lists(base, overlay)
      } else if (is.vector(base) && is.vector(overlay) && recursive) {
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

#' Title
#'
#' TODO-20191026-7: Write doc for `conf_has_inherited()`
#'
#' @param configs [[list]]
#' @param name [[character]]
#'
#' @return [[logical]]
conf_has_inherited <- function(configs, name = "inherits") {
  name %in% names(configs)
}

#' Title
#'
#' TODO-20191026-8: Write doc for `conf_resolve_inherited()`
#'
#' @param value_reference [[list] or [character]]
#' @param from [[character]]
#' @param dir_from [[character]]
#'
#' @return [[list] or [character]]
conf_resolve_inherited <- function(value_reference, from, dir_from) {
  conf_get(value = value_reference, from = from, dir_from = dir_from)
}

#' Title
#'
#' TODO-20191026-9: Write doc for `conf_merge_inherited()`
#'
#' @param configs_inherited [[list]]
#' @param configs [[list]]
#'
#' @return [[list]]
conf_merge_inherited <- function(configs_inherited, configs) {
  conf_merge(configs_inherited, configs)
}

#' Title
#'
#' TODO-20191026-10: Write doc for `conf_handle_inherited()`
#'
#' @param configs [[list]]
#' @param from [[character]]
#' @param dir_from [[character]]
#' @param name [[character]]
#'
#' @return [[list] or [character]]
conf_handle_inherited <- function(configs, from, dir_from, name = "inherits") {
  if (conf_has_inherited(configs)) {
    configs_inherited <- conf_resolve_inherited(configs[[name]], from = from,
      dir_from = dir_from)
    conf_merge_inherited(configs_inherited, configs)
  } else {
    configs
  }
}
