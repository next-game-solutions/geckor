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
#' @eval function_params(c("max_attempts"))
#'
#' @details Granularity of the retrieved data
#'     (i.e. [candle](https://en.wikipedia.org/wiki/Open-high-low-close_chart)'s
#'     body) depends on the value of `days` as follows:
#' * 1 day: 30 minutes;
#' * 7 - 30 days: 4 hours;
#' * above 30: 4 days.
#'
#' @eval function_params(c("api_note"))
#'
#' @return If the API call succeeds, the function returns a tibble with
#' the following columns:
#' * `timestamp` (POSIXct): beginning of the candle's time interval;
#' * `coin_id` (character): same as the argument `coin_id`;
#' * `vs_currency` (character): same as the argument `vs_currency`;
#' * `price_open` (double): coin price in the beginning of a time interval;
#' * `price_high` (double): highest coin price observed within a time interval;
#' * `price_low` (double): lowest coin price observed within a time interval;
#' * `price_close` (double): coin price in the end of a time interval.
#'
#' If no data can be retrieved (e.g., because of going over the API
#' rate limit or mis-specifying the query parameters), the function
#' returns nothing (`NULL`).
#'
#' @export
#'
#' @examplesIf FALSE
#' r <- coin_history_ohlc(
#'   coin_id = "cardano",
#'   vs_currency = "usd",
#'   days = 7
#' )
#' print(r)
#'
coin_history_ohlc <- function(coin_id,
                              vs_currency = "usd",
                              days,
                              max_attempts = 3) {
  if (length(coin_id) > 5L) {
    rlang::abort("The max allowed length of `coin_id` is 5")
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

  if (is.na(days) ||
    is.na(suppressWarnings(as.numeric(days))) &&
      days != "max") {
    rlang::abort("`days` only accepts coercible-to-numeric values or a character value \"max\"")
  }

  if (is.numeric(days) && !days %in% c(1, 7, 14, 30, 90, 180, 365)) {
    rlang::abort("`days` only accepts the following numeric values: 1, 7, 14, 30, 90, 180, 365")
  }

  results <-
    lapply(
      coin_id,
      function(coin) {
        query_params <- list(
          vs_currency = vs_currency,
          days = days
        )

        url <- build_get_request(
          base_url = "https://api.coingecko.com",
          path = c("api", "v3", "coins", coin, "ohlc"),
          query_parameters = query_params
        )

        r <- api_request(url = url, max_attempts = max_attempts)

        if (is.null(r)) {
          return(NULL)
        }

        prices <- lapply(r, function(x) {
          tibble::tibble(
            timestamp = as.POSIXct(x[[1]] / 1000,
              origin = as.Date("1970-01-01"),
              tz = "UTC", format = "%Y-%m-%d %H:%M:%S"
            ),
            coin_id = coin,
            vs_currency = vs_currency,
            price_open = x[[2]],
            price_high = x[[3]],
            price_low = x[[4]],
            price_close = x[[5]]
          )
        })

        result <- dplyr::bind_rows(prices)

        is_na <- apply(result, 2, anyNA)

        if (any(is_na)) {
          rlang::warn(
            message = c(
              "Missing values found in column(s)",
              names(is_na)[is_na]
            )
          )
        }

        return(result)
      }
    )

  results <- dplyr::bind_rows(results)

  if (nrow(results) == 0) {
    return(NULL)
  } else {
    return(results)
  }
}
