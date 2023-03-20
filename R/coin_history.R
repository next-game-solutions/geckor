#' Get historical market data
#'
#' Retrieves coin-specific market data for the last _n_ days
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
#'
#' Sometimes, the retrieved data will contain missing values. In such
#'     cases, the function will issue a warning and show a list
#'     of columns that have missing values.
#'
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
#' @examplesIf ping()
#' r <- coin_history(coin_id = "bitcoin", vs_currency = "usd", days = 30)
#' print(r)
#'
coin_history <- function(coin_id,
                         vs_currency = "usd",
                         days,
                         interval = NULL,
                         max_attempts = 3) {
  if (length(coin_id) > 30L) {
    rlang::abort("The max allowed length of `coin_id` is 30")
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

  results <-
    lapply(
      coin_id,
      function(coin) {
        query_params <- list(
          vs_currency = vs_currency,
          days = days,
          interval = interval
        )

        url <- build_get_request(
          base_url = "https://api.coingecko.com",
          path = c("api", "v3", "coins", coin, "market_chart"),
          query_parameters = query_params
        )

        r <- api_request(url = url, max_attempts = max_attempts)

        if (length(r$prices) == 0) {
          message("\nNo data could be retrieved.")
          return(NULL)
        }

        replace_nulls <- function(x) {
          lapply(x, function(y) ifelse(is.null(y), NA, y))
        }

        prices <- lapply(r$prices, replace_nulls)
        market_caps <- lapply(r$market_caps, replace_nulls)
        total_volumes <- lapply(r$total_volumes, replace_nulls)

        prices <- do.call(rbind, lapply(prices, rbind))
        colnames(prices) <- c("timestamp", "price")

        prices <- tibble::tibble(
          timestamp = unlist(prices[, "timestamp"]),
          coin_id = coin,
          vs_currency = vs_currency,
          price = unlist(prices[, "price"])
        )

        market_caps <- do.call(rbind, lapply(market_caps, rbind))
        colnames(market_caps) <- c("timestamp", "market_cap")

        market_caps <- tibble::tibble(
          timestamp = unlist(market_caps[, "timestamp"]),
          market_cap = unlist(market_caps[, "market_cap"])
        )

        total_volumes <- do.call(rbind, lapply(total_volumes, rbind))
        colnames(total_volumes) <- c("timestamp", "total_volume")

        total_volumes <- tibble::tibble(
          timestamp = unlist(total_volumes[, "timestamp"]),
          total_volume = unlist(total_volumes[, "total_volume"])
        )

        result <-
          dplyr::full_join(
            dplyr::full_join(
              prices, total_volumes,
              by = "timestamp"
            ),
            market_caps,
            by = "timestamp"
          ) %>%
          dplyr::mutate(
            timestamp = as.POSIXct(
              .data$timestamp / 1000,
              origin = as.Date("1970-01-01"),
              tz = "UTC", format = "%Y-%m-%d %H:%M:%S"
            )
          )

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

  dplyr::bind_rows(results)
}
