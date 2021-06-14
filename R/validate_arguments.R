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
                               arg_coin_ids = NULL,
                               arg_vs_currencies = NULL,
                               arg_include_market_cap = NULL,
                               arg_include_24h_vol = NULL,
                               arg_include_24h_change = NULL,
                               arg_date = NULL) {
  if (!is.null(arg_max_attempts)) {
    if (!(is.integer(arg_max_attempts) & arg_max_attempts > 0)) {
      rlang::abort("`max_attempts` must be a positive integer")
    }
  }

  if (!is.null(arg_coin_ids)) {
    if (!is.character(arg_coin_ids)) {
      rlang::abort("`coin_ids` must be a character vector")
    }
  }

  if (!is.null(arg_vs_currencies)) {
    if (!is.character(arg_vs_currencies)) {
      rlang::abort("`vs_currencies` must be a character vector")
    }

    supported_vs_currencies <- supported_currencies()

    if (!all(arg_vs_currencies %in% supported_vs_currencies)) {
      rlang::abort(c(
        "The following base currencies are not currently supported:",
        arg_vs_currencies[!arg_vs_currencies %in% supported_vs_currencies]
      ))
    }
  }

  if (!is.null(arg_include_market_cap)) {
    if (!is.logical(arg_include_market_cap)) {
      rlang::abort("`include_market_cap` must be boolean")
    }
  }

  if (!is.null(arg_include_24h_vol)) {
    if (!is.logical(arg_include_24h_vol)) {
      rlang::abort("`include_24h_vol` must be boolean")
    }
  }

  if (!is.null(arg_include_24h_change)) {
    if (!is.logical(arg_include_24h_change)) {
      rlang::abort("`include_24h_change` must be boolean")
    }
  }

  if (!is.null(arg_date)) {
    if (!inherits(arg_date, "Date")) {
      rlang::abort("`date` must be of class Date")
    }
  }
}
