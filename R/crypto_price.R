#' Get the current cryptocurrency prices
#'
#' The current price of any cryptocurrencies in any other supported currencies
#'
#' @param coin_ids (character): a vector with names of the cryptocurrencies of
#'     interest (all in lower case). An up-to-date list of supported
#'     cryptocurrencies can be retrieved with the [supported_cryptocurrencies()]
#'     function. If `coin_ids` contains at least one unsupported currency,
#'     the call will fail with the respective error message.
#'
#' @eval function_params(c("vs_currencies", "include_market_cap",
#'                         "include_24h_vol", "include_24h_change",
#'                         "max_attempts", "api_note"))
#'
#' @return A tibble, which by the default will have the following columns:
#' * `coin` (character): names of the cryptocurrencies, ordered alphabetically;
#' * `vs_currency` (character): names of the base currencies to express the
#' price in;
#' * `last_updated_at` (POSIXct, UTC timezone): timestamp of the last price
#' update;
#' * `market_cap` (double): current market cap;
#' * `vol_24h` (double): trading volume in the last 24 hours;
#' * `price_percent_change_24h` (double): percentage change of the price
#' compared to 24 hours ago.
#'
#' @export
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' r <- crypto_price(coin_ids = c("aave", "tron", "btc"),
#'                   vs_currencies = c("usd", "eur", "gbp"))
#' print(r)
crypto_price <- function(coin_ids,
                         vs_currencies,
                         include_market_cap = TRUE,
                         include_24h_vol = TRUE,
                         include_24h_change = TRUE,
                         max_attempts = 3L) {
  validate_arguments(
    arg_vs_currencies = vs_currencies,
    arg_include_market_cap = include_market_cap,
    arg_include_24h_vol = include_24h_vol,
    arg_include_24h_change = include_24h_change,
    arg_max_attempts = max_attempts
  )

  query_params <- list(
    ids = paste(coin_ids, collapse = ","),
    vs_currencies = paste0(vs_currencies, collapse = ","),
    include_market_cap = tolower(include_market_cap),
    include_24hr_vol = tolower(include_24h_vol),
    include_24hr_change = tolower(include_24h_change),
    include_last_updated_at = tolower(TRUE)
  )

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "simple", "price"),
    query_parameters = query_params
  )

  r <- api_request(url = url, max_attempts = max_attempts)

  result <- lapply(r, function(x) {
    if (include_market_cap) {
      market_cap <- as.numeric(
        x[paste(vs_currencies, "market_cap", sep = "_")]
      )
    } else {
      market_cap <- NULL
    }

    if (include_24h_vol) {
      vol_24h <- as.numeric(
        x[paste(vs_currencies, "24h_vol", sep = "_")]
      )
    } else {
      vol_24h <- NULL
    }

    if (include_24h_change) {
      change_24h <- as.numeric(
        x[paste(vs_currencies, "24h_change", sep = "_")]
      )
    } else {
      change_24h <- NULL
    }

    tibble::tibble(
      price = as.numeric(x[vs_currencies]),
      vs_currency = vs_currencies
    ) %>%
      dplyr::mutate(
        market_cap = market_cap,
        vol_24h = vol_24h,
        price_percent_change_24h = change_24h,
        last_updated_at = as.POSIXct(x$last_updated_at,
          origin = as.Date("1970-01-01"),
          tz = "UTC",
          format = "%Y-%m-%d %H:%M:%S"
        )
      )
  }) %>%
    dplyr::bind_rows(.id = "coin") %>%
    dplyr::arrange(coin)

  return(result)
}
