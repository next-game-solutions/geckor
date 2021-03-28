#' Validate arguments
#'
#' Validates arguments that are commonly used in `geckor` functions
#'
#' @param arg_max_attempts (integer): number of additional attempts to call
#'     the API if the first attempt fails.
#' @param arg_vs_currencies (character): abbreviated names of the currencies
#'     to benchmark against.
#'
#' @return This function is to be used for its side effects. If any of the
#'     checks is not passed, it returns the respective error. If all checks
#'     are passed successfully, nothing is returned.
#'
#' @keywords internal
#'
validate_arguments <- function(arg_max_attempts = NULL,
                               arg_vs_currencies = NULL) {

  if (!is.null(arg_max_attempts)) {
    if (!(is.integer(arg_max_attempts) & arg_max_attempts > 0)) {
      rlang::abort("`max_attempts` must be a positive integer")
    }
  }

  if (!is.null(arg_vs_currencies)) {
    if (!is.character(arg_vs_currencies)) {
      rlang::abort("`vs_currencies` must be a character vector")
    }
  }
}
