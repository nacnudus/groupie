library(tidyverse)

#' Split data frame by sets of groups
#'
#' @param .tbl A grouped tibble
#'
#' @param .f A function or formula to apply to the grouping variables. It must
#'           return a list of character vectors.
#'
#' * If a *function*, it is used as is. It should have at least 1 formal
#'       argument.
#'
#' * If a *formula*, e.g. ‘~ list(.x)’, it is converted to a function.
#'
#' In the formula, you can use ‘.’ or ‘.x’ to refer to the grouping variables
#' of the input tibble as a character vector.
#'
#' @param ... Additional arguments passed on to ‘.f’
#'
#' @export
#' @examples
#' grouped <- dplyr::group_by(mtcars, cyl, am, gear)
#'
#' grouped %>%
#'   groups_split(k_combinations, k = 1) %>%
#'   lapply(head, n = 1) # or use purrr::map()
#'
#' grouped %>%
#'   groups_split(k_combinations, k = 2) %>%
#'   lapply(head, n = 1)
#'
#' grouped %>%
#'   groups_split(all_combinations) %>%
#'   lapply(head, n = 1)
#'
#' # A formula that returns a single set of all grouping variables
#' grouped %>%
#'   groups_split(~ list(.x)) %>%
#'   lapply(head, n = 1)
#'
#' # A function that returns a single set of all grouping variables
#' grouped %>%
#'   groups_split(function(x) list(x)) %>%
#'   lapply(head, n = 1)
#'
#' # A formula that overrides the grouping variables with two new sets
#' grouped %>%
#'   groups_split(~ list(c("cyl", "am"), c("gear", "carb"))) %>%
#'   lapply(head, n = 1)
groups_split <- function(.tbl, .f, ...) {
  UseMethod("groups_split")
}

#' @export
groups_split.grouped_df <- function(.tbl, .f, ...) {
  .f <- as_groups_split_function(.f)
  sets <- .f(dplyr::group_vars(.tbl), ...)
  purrr::map2(list(.tbl), sets, dplyr::group_by_at)
}

#' @export
groups_split.function <- function (.tbl, .f, ...) {
  rlang::abort("Did you forget to provide the primary input tibble?")
}

#' @export
groups_split.formula <- function (.tbl, .f, ...) {
  rlang::abort("Did you forget to provide the primary input tibble?")
}

as_groups_split_function <- function(.f) {
  .f <- rlang::as_function(.f)
  if (length(form <- formals(.f)) < 1 && !"..." %in% names(form)) {
    stop("The function must accept at least one argument. You can use ... to absorb unused components")
  }
  .f
}
