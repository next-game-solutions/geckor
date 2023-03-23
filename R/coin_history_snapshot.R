#' History snapshot for a coin
#'
#' Coin-specific market data for a given historical date
#'
#' @eval function_params(c("coin_id"))
#' @param date (Date): date of interest. If no data exist for the requested
#'     date, nothing (`NULL`) will be returned.
#' @eval function_params(c("vs_currencies", "max_attempts"))
#'
#' @eval function_params("api_note")
#'
#' @return A tibble with the following columns:
#' * `coin_id` (character): same as the argument `coin_id`;
#' * `symbol` (character): symbol of the coin;
#' * `name` (character): common name of the coin;
#' * `date` (Date): same as the argument `date`;
#' * `vs_currency` (character): reference currency, in which the `price`
#' is expressed (ordered alphabetically);
#' * `price` (double): price of the coin;
#' * `market_cap` (double): market capitalisation of the coin;
#' * `total_volume` (double): total trading volume recorded on that `date`.
#'
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @examplesIf ping()
#' r <- coin_history_snapshot(
#'   coin_id = "cardano",
#'   date = as.Date("2021-05-01"),
#'   vs_currencies = c("usd", "eth")
#' )
#' print(r)
#'
coin_history_snapshot <- function(coin_id,
                                  date,
                                  vs_currencies = "usd",
                                  max_attempts = 3) {
  if (length(coin_id) > 5L) {
    rlang::abort("The max allowed length of `coin_id` is 5")
  }

  if (length(date) > 1L) {
    rlang::abort("Only one `date` is allowed")
  }

  validate_arguments(
    arg_coin_ids = coin_id,
    arg_date = date,
    arg_vs_currencies = vs_currencies,
    arg_max_attempts = max_attempts
  )

  results <-
    lapply(
      coin_id,
      function(coin) {
        query_parameters <- list(
          date = format(date, "%d-%m-%Y"),
          localization = tolower(FALSE)
        )

        url <- build_get_request(
          base_url = "https://api.coingecko.com",
          path = c("api", "v3", "coins", coin, "history"),
          query_parameters = query_parameters
        )

        r <- api_request(url = url, max_attempts = max_attempts)

        if (is.null(r) | !"market_data" %in% names(r)) {
          message("\nNo data could be retrieved.")
          return(NULL)
        }

        price <- r$market_data$current_price %>%
          tibble::as_tibble() %>%
          tidyr::pivot_longer(
            cols = tidyselect::everything(),
            names_to = "vs_currency",
            values_to = "price"
          ) %>%
          dplyr::filter(.data$vs_currency %in% vs_currencies)

        market_cap <- r$market_data$market_cap %>%
          tibble::as_tibble() %>%
          tidyr::pivot_longer(
            cols = tidyselect::everything(),
            names_to = "vs_currency",
            values_to = "market_cap"
          ) %>%
          dplyr::filter(.data$vs_currency %in% vs_currencies)

        total_volume <- r$market_data$total_volume %>%
          tibble::as_tibble() %>%
          tidyr::pivot_longer(
            cols = tidyselect::everything(),
            names_to = "vs_currency",
            values_to = "total_volume"
          ) %>%
          dplyr::filter(.data$vs_currency %in% vs_currencies)

        result <- dplyr::inner_join(price, market_cap, by = "vs_currency") %>%
          dplyr::inner_join(total_volume, by = "vs_currency")

        result <- dplyr::bind_cols(tibble::tibble(
          coin_id = r$id,
          symbol = r$symbol,
          name = r$name,
          date = date
        ), result) %>%
          dplyr::arrange(.data$vs_currency)

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
