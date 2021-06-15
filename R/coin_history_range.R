#' Get historical TRX market data
#'
#' Retrieves TRX market data for a range of historical dates
#'
#' @param coin_id (character): ID of the coin of interest. An up-to-date list of
#'     supported coins and their IDs can be retrieved with the
#'     [supported_coins()] function.
#' @param vs_currency (character): name of the base currency to benchmark
#'     against. An up-to-date list of supported currencies
#'     (both fiat and cryptocurrencies) can be retrieved with the
#'     [supported_currencies()] function. If an unsupported
#'     `vs_currency` is requested, the call will fail with the respective error
#'     message.
#' @param from (POSIXct): timestamp of the beginning of the period of interest
#' (`YYYY-MM-DD HH:MM:SS`).
#' @param to (POSIXct): timestamp of the end of the period of interest
#' (`YYYY-MM-DD HH:MM:SS`).
#' @eval function_params(c("max_attempts"))
#'
#' @details This function returns hourly data for periods of up to 90 days,
#'     and daily data for periods longer than 90 days.
#'
#' @return A tibble with the following columns:
#' * `timestamp` (POSIXct);
#' * `vs_currency` (character): same as the argument `vs_currency`;
#' * `price` (double): coin price as of `timestamp`;
#' * `total_trading_vol` (double): a 24 h rolling-window trading volume, as
#' of `timestampt`;
#' * `market_cap` (double): market capitalisation, as of `timestamp`.
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' r <- coin_history_range(
#'   coin_id = "cardano",
#'   vs_currency = "usd",
#'   from = as.POSIXct("2021-01-01 13:00:00", tz = "UTC"),
#'   to = as.POSIXct("2021-01-01 18:00:00", tz = "UTC")
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
