#' Combinations in draws of size k
#'
#' @description
#'
#' Wraps [arrangements::combinations()] for use with [groups_split()].
#'
#' * [k_combinations()] draws combinations of size k
#' * [all_combinations()] draws combinations of size 1 to k
#'
#' @inheritParams arrangements::combinations
#'
#' @rdname combos
#' @export
#' @examples
#' v <- LETTERS[1:3]
#'
#' k_combinations(v)
#'
#' k_combinations(v, 1)
#'
#' k_combinations(v, 2)
k_combinations <- function(v, k = NULL) {
  arrangements::combinations(v, k = k, layout = "list")
}

#' Combinations in draws of increasing size
#'
#' @rdname combos
#' @export
#' @examples
#'
#' all_combinations(v)
all_combinations <- function(v) {
  purrr::flatten(purrr::map2(list(v), seq_along(v), k_combinations))
}

#' Individual items from a vector
#'
#' For use with [groups_split()].  Shorthand for `k_combinations(v, k = 1)`.
#' Longhand for `as.list(v)`.
#'
#' @inheritParams arrangements::combinations
#' @export
#' @examples
#' v <- LETTERS[1:3]
#'
#' individuals(v)
individuals <- function(v) {
  as.list(v)
}

#' First one then first two then first three and so on
#'
#' See the example.
#'
#' @export
#' @examples
#' v <- LETTERS[1:3]
#'
#' hierarchy(v)
hierarchy <- function(v) {
  lapply(seq_along(v), function(x) { v[seq_len(x)] })
}

#' Permutations in draws of size k
#'
#' @description
#'
#' Wraps [arrangements::permutations()] for use with [groups_split()].
#'
#' * [k_permutations()] draws permutations of size k
#' * [all_permutations()] draws permutations of size 1 to k
#'
#' This is only useful when later using `dplyr::arrange()` with `.by_group =
#' TRUE`, otherwise permutations of the same combination are equivalent.
#'
#' @inheritParams arrangements::permutations
#'
#' @rdname perms
#' @export
#' @examples
#' v <- LETTERS[1:3]
#'
#' k_permutations(v)
#'
#' k_permutations(v, 1)
#'
#' k_permutations(v, 2)
k_permutations <- function(v, k = NULL) {
  arrangements::permutations(v, k = k, layout = "list")
}
# gps <- group_vars(group_by(mtcars, cyl, am, gear))
# k_permutations(gps)
# k_permutations(gps, 1)
# k_permutations(gps, 2)

#' Permutations in draws of increasing size
#'
#' @rdname perms
#' @export
#' @examples
#'
#' all_permutations(v)
all_permutations <- function(v) {
  purrr::flatten(purrr::map2(list(v), seq_along(v), k_permutations))
}
