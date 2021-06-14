#' Current market status
#'
#' Metrics describing the current market status of a set of coins
#'
#' @param coin_ids (character): a vector with IDs of the cryptocurrencies of
#'     interest. An up-to-date list of supported cryptocurrencies and their
#'     IDs can be retrieved with the [supported_coins()] function. Can be
#'     of length 1.
#' @param vs_currency (character): a single character value specifying the
#' name of the base currency to benchmark against, e.g. `"usd"`. An up-to-date
#' list of supported currencies (both fiat and cryptocurrencies) can be
#' retrieved with the [supported_currencies()] function. If `vs_currency`
#' contains an unsupported currency, the call will fail with the respective
#' error message.
#'
#' @eval function_params(c("max_attempts", "api_note"))
#'
#' @details If no data can be retrieved (e.g. because of the misspecified
#'    query parameters), this function will return nothing (`NULL`).
#'
#' @return If the requested data exist, this function will return a tibble with
#'    with as many rows as the length of `coin_ids` and the following columns:
#' * `coin_id` (character): coin IDs, ordered by `market_cap` (see below);
#' * `symbol` (character): coin symbol;
#' * `name` (character): coin common name;
#' * `last_updated_at` (POSIXct, UTC timezone): timestamp of the last update;
#' * `current_price` (double): current price (as of `last_updated_at`),
#' expressed in `vs_currency`;
#' * `market_cap` (double): current market capitalisation;
#' * `market_cap_rank` (integer): current rank of the coin in terms of its
#' market capitalisation;
#' * `fully_diluted_valuation` (double): fully diluted valuation of the coin'
#' project;
#' * `total_volume` (double): total trading volume in the last 24 hours;
#' * `high_24h` (double): max price recorded in the last 24 hours;
#' * `low_24h` (double): min price recorded in the last 24 hours;
#' * `price_change_24h` (double): price change as compared to 24 hours ago;
#' * `price_change_percentage_24h` (double): percentage change of the price as
#' compared to 24 hours ago;
#' * `circulating_supply` (double): coin supply currently in circulation;
#' * `total_supply` (double): total supply that can potentially be circulated;
#' * `max_supply` (double): max possible supply that can be circulated;
#' * `ath` (double): all-time high price;
#' * `ath_change_percentage` (double): percentage change of the all-time high
#' price compared to the current price;
#' * `ath_date` (POSIXct, UTC timezone): timestamp of when the all-time high
#' price has been recorded;
#' * `atl` (double): all-time low price;
#' * `atl_change_percentage` (double): percentage change of the all-time low
#' price compared to the current price;
#' * `atl_date` (POSIXct, UTC timezone): timestamp of when the all-time low
#' price has been recorded;
#' * `price_change_percentage_<time>_in_currency`: columns containing the
#' percentage change in price as compared to various periods in the past
#' (in particular, 1 hour, 24 hours, 7 days, 14 days, 30 days, 200 days,
#' and 1 year).
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @keywords internal
#'
#' @examples
#' r <- current_market(coin_ids = c("bitcoin", "ethereum", "cardano"),
#'                     vs_currency = "usd")
#' print(r)
#'
current_market <- function(coin_ids,
                           vs_currency,
                           max_attempts = 3L) {
  validate_arguments(
    arg_coin_ids = coin_ids,
    arg_vs_currencies = vs_currency,
    arg_max_attempts = max_attempts
  )

  n_coins <- length(coin_ids)

  data <- list()
  p <- 1L

  query_parameters <- list(
    ids = paste(coin_ids, collapse = ","),
    vs_currency = vs_currency,
    order = "market_cap_desc",
    price_change_percentage = "1h,24h,7d,14d,30d,200d,1y",
    per_page = 50L,
    sparkline = tolower(FALSE)
  )

  pb <- progress::progress_bar$new(
    total = NA,
    clear = TRUE,
    force = TRUE,
    format = ":spin Fetching data... Elapsed time: :elapsedfull"
  )

  pb$tick(0)

  while (TRUE) {
    query_parameters$page <- p

    url <- build_get_request(
      base_url = "https://api.coingecko.com",
      path = c("api", "v3", "coins", "markets"),
      query_parameters = query_parameters
    )

    r <- api_request(url = url, max_attempts = max_attempts)

    if (is.null(r)) {
      message("No data found. Check if the query parameters are specified correctly")
      return(NULL)
    }

    data <- c(data, r)

    if (length(data) == length(coin_ids)) {
      break
    }

    p <- p + 1

    pb$tick()
  }

  data_parsed <- lapply(
    data, function(x) {
      x[which(sapply(x, is.null))] <- NA
      x$roi <- NULL
      x$image <- NULL

      x %>%
        tibble::as_tibble() %>%
        dplyr::rename(
          coin_id = .data$id,
          last_updated_at = .data$last_updated
        ) %>%
        dplyr::mutate(vs_currency = vs_currency) %>%
        dplyr::relocate(.data$vs_currency, .after = .data$name) %>%
        dplyr::relocate(.data$last_updated_at, .after = vs_currency) %>%
        dplyr::relocate(.data$price_change_percentage_1h_in_currency,
          .after = .data$atl_date
        ) %>%
        dplyr::relocate(.data$price_change_percentage_24h_in_currency,
          .after = .data$price_change_percentage_1h_in_currency
        ) %>%
        dplyr::relocate(.data$price_change_percentage_7d_in_currency,
          .after = .data$price_change_percentage_24h_in_currency
        ) %>%
        dplyr::relocate(.data$price_change_percentage_14d_in_currency,
          .after = .data$price_change_percentage_7d_in_currency
        ) %>%
        dplyr::relocate(.data$price_change_percentage_30d_in_currency,
          .after = .data$price_change_percentage_14d_in_currency
        ) %>%
        dplyr::relocate(.data$price_change_percentage_200d_in_currency,
          .after = .data$price_change_percentage_30d_in_currency
        ) %>%
        dplyr::mutate_at(
          .vars = dplyr::vars(tidyselect::contains("date")),
          .funs = ~ as.POSIXct(gsub("T", " ", .x),
            origin = as.Date("1970-01-01"),
            tz = "UTC",
            format = "%Y-%m-%d %H:%M:%S"
          )
        )
    }
  ) %>%
    dplyr::bind_rows()

  return(data_parsed)
}
