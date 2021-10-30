#' Get historical market data
#'
#' Retrieves coin-specific market data for a range of historical dates
#'
#' @eval function_params(c("coin_id", "vs_currency"))
#' @param from (POSIXct): timestamp of the beginning of the period of interest
#' (`YYYY-MM-DD HH:MM:SS`).
#' @param to (POSIXct): timestamp of the end of the period of interest
#' (`YYYY-MM-DD HH:MM:SS`).
#' @eval function_params(c("max_attempts"))
#'
#' @details This function returns hourly data for periods of up to 90 days
#'     and daily data for periods that are longer than 90 days.
#'
#' Sometimes, the retrieved data will contain missing values. In such
#'     cases, the function will issue a warning and show a list
#'     of column with missing values.
#'
#' @eval function_params("api_note")
#'
#' @return A tibble with the following columns:
#' * `timestamp` (POSIXct);
#' * `coin_id` (character): same as the argument `coin_id`;
#' * `vs_currency` (character): same as the argument `vs_currency`;
#' * `price` (double): coin price as of `timestamp`;
#' * `total_volume` (double): a 24 hours rolling-window trading volume, as
#' of `timestampt`;
#' * `market_cap` (double): market capitalisation, as of `timestamp`.
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' \donttest{
#' r <- coin_history_range(
#'   coin_id = "cardano",
#'   vs_currency = "usd",
#'   from = as.POSIXct("2021-01-01 13:00:00", tz = "UTC"),
#'   to = as.POSIXct("2021-01-01 18:00:00", tz = "UTC")
#' )
#' print(r)
#' }
coin_history_range <- function(coin_id,
                               vs_currency = "usd",
                               from,
                               to,
                               max_attempts = 3) {
  if (length(coin_id) > 30L) {
    rlang::abort("The max allowed length of `coin_id` is 30")
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
    rlang::abort("`from` and `to` must be of class POSIXct")
  }

  results <-
    lapply(
      coin_id,
      function(coin) {
        query_params <- list(
          vs_currency = vs_currency,
          from = as.numeric(from),
          to = as.numeric(to)
        )

        url <- build_get_request(
          base_url = "https://api.coingecko.com",
          path = c("api", "v3", "coins", coin, "market_chart", "range"),
          query_parameters = query_params
        )

        r <- api_request(url = url, max_attempts = max_attempts)

        if (length(r$prices) == 0) {
          message("No data found. Check if the query parameters are specified correctly")
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
