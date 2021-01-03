#' Merge lists
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
