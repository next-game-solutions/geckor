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
    vs_currencies = "@param vs_currencies (character): a vector with
       names of the base currencies to benchmark against, e.g.
       `c(\"usd\", \"eur\", \"btc\")`. An up-to-date list of supported
       `vs_currencies` (both fiat and cryptocurrencies) can be retrieved with
       the [supported_currencies()] function. If `vs_currencies`
       contains at least one unsupported currency, the call will fail with the
       respective error message.",
    include_market_cap = "@param include_market_cap (boolean, defaults to
       `TRUE`): whether to return the market cap information.",
    include_24h_vol = "@param include_24h_vol (boolean, defaults to `TRUE`):
       whether to return the trading volume for the last 24 hours.",
    include_24h_change = "@param include_24h_change (boolean, defaults to
       `TRUE`): whether to return the price percentage change compared to 24
       hours ago.",
    api_note = "@details This function is based on the public
               CoinGecko API, which has a limit of 100 calls per minute. Please
               keep this limit in mind when developing your applications.",
    max_attempts = "@param max_attempts (integer, positive): specifies the
               maximum number of additional attempts to call a URL if the
               first attempt fails (i.e. its call status is different from
               `200`). Additional attempts are implemented with an exponential
               backoff. Defaults to `3`."
  )

  return(descriptions[arguments])
}
