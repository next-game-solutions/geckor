#' Get historical TRX market data
#'
#' Retrieves TRX market data for a range of historical dates
#'
#' @param vs_currency (character): name of the base currency to benchmark TRX
#'     against (`usd` by default). An up-to-date list of supported currencies
#'     (both fiat and cryptocurrencies) can be retrieved with the
#'     [get_supported_coingecko_currencies()] function. If an unsupported
#'     `vs_currency` is requested, the call will fail with the respective error
#'     message.
#' @eval function_params(c("min_timestamp", "max_timestamp", "max_attempts"))
#'
#' @details This function returns hourly data for periods of up to 90 days,
#'     and daily data for periods above 90 days.
#'
#' The minimal acceptable `min_timestamp` is `"1510185600000"` (which
#'     corresponds to `2017-11-09 00:00:00`) as no data are available for
#'     earlier dates. Attempts to retrieve data for earlier dates will fail
#'     with the corresponding error message.
#'
#' Attempts to request a future `max_timestamp` for which no history exists
#'     yet will also fail with the corresponding error message.
#'
#' @return A tibble with the following columns:
#' * `timestamp` (POSIXct);
#' * `vs_currency` (character): same as the argument `vs_currency`;
#' * `price` (double): TRX price, as of `datetime`;
#' * `total_trading_vol` (double): a 24 h rolling-window trading volume, as
#' of `timestampt`;
#' * `market_cap` (double): TRX market cap, as of `timestamp`.
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' r <- get_trx_market_data_for_time_range(
#'   vs_currency = "eur",
#'   min_timestamp = "1609495210000",
#'   max_timestamp = "1609533900000"
#' )
#' print(r)
coin_history_range <- function(coin_id,
                               vs_currency,
                               from,
                               to,
                               max_attempts = 3L) {
  if (length(coin_id) > 1L) {
    rlang::abort("Only one `coin_id` is allowed")
  }

  if (length(vs_currency) > 1L) {
    rlang::abort("Only one `vs_currency` is allowed")
  }

  validate_arguments(
    arg_coin_ids = coin_id,
    arg_vs_currencies = vs_currency,
    arg_max_attempts = max_attempts
  )

  if (!inherits(from, "POSIXct") | !inherits(to, "POSIXct")) {
    rlang:abort("`from` and `to` must be of class POSIXct")
  }

  query_params <- list(
    vs_currency = vs_currency,
    from = as.numeric(from),
    to = as.numeric(to)
  )

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "coins", coin_id, "market_chart", "range"),
    query_parameters = query_params
  )

  r <- api_request(url = url, max_attempts = max_attempts)

  if (length(r$prices) == 0) {
    message("No data found. Check if the query parameters are specified correctly")
    return(NULL)
  }

  prices <- lapply(r$prices, function(x) {
    tibble::tibble(
      timestamp = as.POSIXct(x[[1]]/1000, origin = as.Date("1970-01-01"),
                             tz = "UTC", format = "%Y-%m-%d %H:%M:%S"),
      vs_currency = vs_currency,
      price = x[[2]]
    )
  }) %>%
    dplyr::bind_rows()

  market_caps <- lapply(r$market_caps, function(x) {
    tibble::tibble(
      market_cap = x[[2]]
    )
  }) %>%
    dplyr::bind_rows()

  total_volumes <- lapply(r$total_volumes, function(x) {
    tibble::tibble(
      total_volume = x[[2]]
    )
  }) %>%
    dplyr::bind_rows()

  result <- dplyr::bind_cols(prices, total_volumes, market_caps) %>%
    dplyr::arrange(dplyr::desc(.data$timestamp))

  return(result)
}
