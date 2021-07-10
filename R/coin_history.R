#' Get historical market data
#'
#' Retrieves market data for a coin for the last _n_ days
#'
#' @eval function_params(c("coin_id", "vs_currency"))
#' @param days (numeric or `"max"`): number of days to look back.
#'     If `days = "max"`, the entire available history for `coin_id` will be
#'     retrieved. Depending on the value of `days`, the time interval used to
#'     present the data will differ - see "Details".
#' @param interval (character or `NULL`): time interval used to present the data.
#'     The only currently supported value is `daily`. Defaults to `NULL`.
#' @eval function_params("max_attempts")
#'
#' @details If `days = 1` and `interval = NULL`, the data will be returned for
#'    every few minutes (typically 3-8 minutes). If `days` is between 2 and 90
#'    (inclusive) and `interval = NULL`, an (approximately) hourly time step will
#'    be used. Daily data are used for `days` above 90. If `interval = "daily"`,
#'    daily data will be used irrespective of the value of `days`.
#' @eval function_params("api_note")
#'
#' @return A tibble with the following columns:
#' * `timestamp` (POSIXct);
#' * `coin_id` (character): same as the argument `coin_id`;
#' * `vs_currency` (character): same as the argument `vs_currency`;
#' * `price` (double): coin price, as of `timestamp`;
#' * `total_volume` (double): a 24 hours rolling-window trading volume, as
#' of `timestamp`;
#' * `market_cap` (double): market capitalisation, as of `timestamp`.
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' \donttest{
#' r <- coin_history(coin_id = "bitcoin", vs_currency = "usd", days = 30)
#' print(r)
#' }
coin_history <- function(coin_id,
                         vs_currency = "usd",
                         days,
                         interval = NULL,
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
    is.na(suppressWarnings(as.numeric(days))) && days != "max") {
    rlang::abort("`days` only accepts coercible-to-numeric values or a character value \"max\"")
  }

  if (!is.null(interval) && interval != "daily") {
    rlang::abort("`interval` must be equal to NULL or \"daily\"")
  }

  query_params <- list(
    vs_currency = vs_currency,
    days = days,
    interval = interval
  )

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "coins", coin_id, "market_chart"),
    query_parameters = query_params
  )

  r <- api_request(url = url, max_attempts = max_attempts)

  if (length(r$prices) == 0) {
    message("No data found. Check if the query parameters are specified correctly")
    return(NULL)
  }

  prices <- lapply(r$prices, function(x) {
    if (is.null(x[[1]])) {x[[1]] <- NA}
    if (is.null(x[[2]])) {x[[2]] <- NA}
    tibble::tibble(
      timestamp = as.POSIXct(x[[1]] / 1000,
        origin = as.Date("1970-01-01"),
        tz = "UTC", format = "%Y-%m-%d %H:%M:%S"
      ),
      coin_id = coin_id,
      vs_currency = vs_currency,
      price = x[[2]]
    )
  }) %>%
    dplyr::bind_rows()

  market_caps <- lapply(r$market_caps, function(x) {
    if (is.null(x[[1]])) {x[[1]] <- NA}
    if (is.null(x[[2]])) {x[[2]] <- NA}
    tibble::tibble(
      timestamp = as.POSIXct(x[[1]] / 1000,
                             origin = as.Date("1970-01-01"),
                             tz = "UTC", format = "%Y-%m-%d %H:%M:%S"
      ),
      market_cap = x[[2]]
    )
  }) %>%
    dplyr::bind_rows()

  total_volumes <- lapply(r$total_volumes, function(x) {
    if (is.null(x[[1]])) {x[[1]] <- NA}
    if (is.null(x[[2]])) {x[[2]] <- NA}
    tibble::tibble(
      timestamp = as.POSIXct(x[[1]] / 1000,
                             origin = as.Date("1970-01-01"),
                             tz = "UTC", format = "%Y-%m-%d %H:%M:%S"
      ),
      total_volume = x[[2]]
    )
  }) %>%
    dplyr::bind_rows()

  result <- dplyr::full_join(prices, total_volumes, by = "timestamp")
  result <- dplyr::full_join(result, market_caps, by = "timestamp") %>%
    dplyr::arrange(dplyr::desc(.data$timestamp))

  return(result)
}
