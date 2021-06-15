#' History snapshot for a coin
#'
#' Historical market data on a given date for a coin
#'
#' @param coin_id (character): ID of the coin of interest. An up-to-date list of
#'     supported coins and their IDs can be retrieved with the
#'     [supported_coins()] function.
#' @param date (Date): date of interest. If no data exist for the requested
#'     date, nothing (`NULL`) will be returned.
#' @eval function_params(c("vs_currencies", "max_attempts", "api_note"))
#'
#' @details If no data can be retrieved (e.g. because of the misspecified
#'    query parameters), this function will return nothing (`NULL`).
#'
#' @return If the requested data exist, this function will return a tibble with
#'    with as many rows as the length of `vs_currencies` and the following
#'    columns:
#' * `coin_id` (character): coin ID;
#' * `symbol` (character): coin symbol;
#' * `name` (character): coin common name;
#' * `date` (Date): historical date;
#' * `vs_currency` (character): currency, in which the coin's `price` is
#' expressed (ordered alphabetically);
#' * `price` (double): price of the coin;
#' * `market_cap` (double): market capitalisation;
#' * `total_volume` (double): total trading volume recorded on that `date`.
#'
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @examples
#' r <- coin_history_snapshot(
#'   coin_id = "cardano",
#'   date = as.Date("2021-05-01"),
#'   vs_currencies = c("usd", "eth")
#' )
#' print(r)
coin_history_snapshot <- function(coin_id,
                                  date,
                                  vs_currencies,
                                  max_attempts = 3L) {
  if (length(coin_id) > 1L) {
    rlang::abort("Only one `coin_id` is allowed")
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

  query_parameters <- list(
    date = format(date, "%d-%m-%Y"),
    localization = tolower(FALSE)
  )

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "coins", coin_id, "history"),
    query_parameters = query_parameters
  )

  r <- api_request(url = url, max_attempts = max_attempts)

  if (is.null(r) | !"market_data" %in% names(r)) {
    message("No data found. Check if the query parameters are specified correctly")
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

  return(result)
}