#' Get trending coins
#'
#' Retrieves a list of top-7 coins on CoinGecko according to their search popularity
#'
#' @eval function_params(c("max_attempts", "api_note"))
#'
#' @details Popularity of a coin is determined based on the search patterns at the
#' CoinGecko website over the last 24 hours.
#'
#' @return A tibble with the following columns:
#' * `timestamp` (POSIXct): date and time of the API request;
#' * `popularity_rank_24h` (integer): popularity rank in the last 24 hours;
#' * `coin_id` (character): coin ID;
#' * `name` (character): common name of the coin;
#' * `symbol` (character): symbol of the coin;
#' * `market_cap_rank` (integer): market capitalisation rank of the coin;
#' * `price_btc` (double): price of the coin, expressed in Bitcoin.
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' r <- trending_coins()
#' print(r)
trending_coins <- function(max_attempts = 3) {
  validate_arguments(arg_max_attempts = max_attempts)

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "search", "trending"),
    query_parameters = NULL
  )

  r <- api_request(url = url, max_attempts = max_attempts)

  result <- lapply(r$coins, function(x) {
    x <- x$item
    tibble::tibble(
      timestamp = Sys.time(),
      popularity_rank_24h = as.integer(x$score + 1),
      coin_id = x$id,
      name = x$name,
      symbol = x$symbol,
      market_cap_rank = x$market_cap_rank,
      price_btc = x$price_btc
    )
  }) %>%
    dplyr::bind_rows()

  return(result)
}
