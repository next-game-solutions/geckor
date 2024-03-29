#' Definitions of common function arguments
#'
#' Used to automatically document frequently used arguments
#'
#' @param arguments (character): vector with names of the arguments to be
#'     documented.
#'
#' @return Literal descriptions of the arguments.
#'
#' @keywords internal
#'
function_params <- function(arguments) {
  descriptions <- c(
    coin_id = "@param coin_id (character): ID of the coin of interest or a vector with _several_ IDs.
       The maximum number of coins that can be queried simultaneously is 5.
       An up-to-date list of supported coins and their IDs can be retrieved
       with the `supported_coins()` function.",
    coin_ids = "@param coin_ids (character): a vector with IDs of the coins of
       interest. An up-to-date list of supported coins and their
       IDs can be obtained with the [supported_coins()] function.",
    vs_currency = "@param vs_currency (character): name of the reference currency to
       express the price in. An up-to-date list of supported reference currencies (both
       fiat and cryptocurrencies) can be obtained with the [supported_currencies()]
       function. If an unsupported `vs_currency` is requested, the call will
       fail with the respective error message.",
    vs_currencies = "@param vs_currencies (character): a vector with
       names of the reference currencies to express the price in, e.g.
       `c(\"usd\", \"eur\", \"btc\")`. An up-to-date list of supported
       `vs_currencies` (both fiat and cryptocurrencies) can be obtained with
       the [supported_currencies()] function. If `vs_currencies`
       contains at least one unsupported currency, the call will fail with the
       respective error message.",
    include_market_cap = "@param include_market_cap (boolean, defaults to
       `TRUE`): whether to return the market capitalisation information.",
    include_24h_vol = "@param include_24h_vol (boolean, defaults to `TRUE`):
       whether to return the trading volume for the last 24 hours.",
    include_24h_change = "@param include_24h_change (boolean, defaults to
       `TRUE`): whether to return the price percentage change compared to 24
       hours ago.",
    api_note = "@details This function is based on the public
               [CoinGecko API](https://www.coingecko.com/api/documentations/v3),
               which has a rate limit of 10-30 calls per minute. Please
               keep this limit in mind when developing your applications.",
    max_attempts = "@param max_attempts (double, positive): specifies the
               maximum number of attempts to call the CoinGecko API (e.g., if
               the first call fails for some reason). Additional attempts are
               implemented with an exponential backoff. Defaults to 3."
  )

  return(descriptions[arguments])
}
