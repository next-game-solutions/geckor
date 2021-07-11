#' Validate arguments
#'
#' Validates arguments that are frequently used in `geckor` functions
#'
#' @return This internal function is to be used for its side effects. If any of
#'     the checks is not passed, the respective error is returned. If all checks
#'     are passed successfully, nothing is returned.
#'
#' @keywords internal
#'
validate_arguments <- function(arg_max_attempts = NULL,
                               arg_coin_ids = NULL,
                               arg_vs_currencies = NULL,
                               arg_exchange_id = NULL,
                               arg_include_market_cap = NULL,
                               arg_include_24h_vol = NULL,
                               arg_include_24h_change = NULL,
                               arg_date = NULL) {
  if (!is.null(arg_max_attempts)) {
    if (!(is.numeric(arg_max_attempts) & arg_max_attempts > 0)) {
      rlang::abort("`max_attempts` must be a positive number")
    }
  }

  if (!is.null(arg_coin_ids)) {
    if (!is.character(arg_coin_ids)) {
      rlang::abort("Coin IDs must be of class character")
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

  if (!is.null(arg_exchange_id)) {
    if (!is.character(arg_exchange_id) | length(arg_exchange_id) != 1) {
      rlang::abort("`exchange_id` must be a single character value")
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
    if (class(arg_date) != "Date") {
      rlang::abort("All dates must be of class Date")
    }
  }
}
