#' Definitions of common function arguments
#'
#' Used to automatically generate documentation for commonly occurring arguments
#'
#' @param arguments (character): vector with names of the arguments to be
#'     documented.
#'
#' @return Literal descriptions of function arguments.
#'
#' @keywords internal
#'
function_params <- function(arguments) {
  descriptions <- c(
    max_attempts = "@param max_attempts (integer, positive): specifies the
               maximum number of additional attempts to call a URL if the
               first attempt fails (i.e. its call status is different from
               `200`). Additional attempts are implemented with an exponential
               backoff. Defaults to `3`.",

    vs_currencies = "@param vs_currencies (character): a vector with
       names of the base currencies to benchmark TRX against, e.g.
       `c(\"usd\", \"eur\", \"btc\")`. An up-to-date list of supported currencies
       (both fiat and cryptocurrencies) can be retrieved with the
       [get_supported_coingecko_currencies()] function. If `vs_currencies`
       contains at least one unsupported currency, the call will fail with the
       respective error message.",

    api_note = "@details This function is based on the public
               CoinGecko API, which has a limit of 100 calls per minute. Please
               keep this limit in mind when developing your code."
  )

  return(descriptions[arguments])
}
