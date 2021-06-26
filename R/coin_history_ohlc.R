#' Historical OHLC price data
#'
#' Retrieves open-high-low-close price data for the last _n_ days
#'
#' @eval function_params(c("coin_id", "vs_currency"))
#' @param days (numeric or `"max"`): number of days to look back. The only
#'     acceptable values are 1, 7, 14, 30, 90, 180, 365 and `"max"`. Attempts to
#'     assign any other values will fail with the corresponding error message.
#'     If `days = "max"`, the entire available history will be retrieved.
#'     Depending on the value of `days`, the time interval used to present the
#'     data will differ - see "Details".
#' @eval function_params(c("max_attempts", "api_note"))
#'
#' @details Granularity of the retrieved data
#'     (i.e. [candle](https://en.wikipedia.org/wiki/Open-high-low-close_chart)'s
#'     body) depends on the value of `days` as follows:
#' * 1 day: 30 minutes;
#' * 7 - 30 days: 4 hours;
#' * above 30: 4 days.
#'
#' @return A tibble with the following columns:
#' * `timestamp` (POSIXct);
#' * `coin_id` (character): coin ID;
#' * `vs_currency` (character): same as the argument `vs_currency`;
#' * `price_open` (double): coin price in the beginning of a time interval;
#' * `price_high` (double): highest coin price observed within a time interval;
#' * `price_low` (double): lowest coin price observed within a time interval;
#' * `price_close` (double): coin price in the end of a time interval.
#'
#' @export
#'
#' @examples
#' \donttest{
#' r <- coin_history_ohlc(
#'   coin_id = "cardano",
#'   vs_currency = "usd",
#'   days = 7
#' )
#' print(r)
#' }
coin_history_ohlc <- function(coin_id,
                              vs_currency,
                              days,
                              max_attempts = 3) {
  if (length(coin_id) > 1L) {
    rlang::abort("Only one `coin_id` is allowed")
  }

  if (length(vs_currency) > 1L) {
    rlang::abort("Only one `vs_currency` is allowed")
  }

  if (length(days) > 1L) {
    rlang::abort("Only one `days` value is allowed")
  }

  validate_arguments(
    arg_coin_ids = coin_id,
    arg_vs_currencies = vs_currency,
    arg_max_attempts = max_attempts
  )

  if (is.na(days) |
    is.na(suppressWarnings(as.numeric(days))) &
      days != "max") {
    rlang::abort("`days` only accepts coercible-to-numeric values or a character value \"max\"")
  }

  if (is.numeric(days) & !days %in% c(1, 7, 14, 30, 90, 180, 365)) {
    rlang::abort("`days` only accepts the following numeric values: 1, 7, 14, 30, 90, 180, 365")
  }

  query_params <- list(
    vs_currency = vs_currency,
    days = days
  )

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "coins", coin_id, "ohlc"),
    query_parameters = query_params
  )

  r <- api_request(url = url, max_attempts = max_attempts)

  if (length(r) == 0) {
    message("No data found. Check if the query parameters are specified correctly")
    return(NULL)
  }

  prices <- lapply(r, function(x) {
    tibble::tibble(
      timestamp = as.POSIXct(x[[1]] / 1000,
        origin = as.Date("1970-01-01"),
        tz = "UTC", format = "%Y-%m-%d %H:%M:%S"
      ),
      coin_id = coin_id,
      vs_currency = vs_currency,
      price_open = x[[2]],
      price_high = x[[3]],
      price_low = x[[4]],
      price_close = x[[5]]
    )
  })

  return(dplyr::bind_rows(prices))
}
