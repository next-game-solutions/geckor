#' Trending coins
#'
#' Retrieves top-7 coins on CoinGecko according to their search popularity
#'
#' @eval function_params("max_attempts")
#'
#' @details Popularity of a coin is determined from search patterns at the
#' CoinGecko website over the last 24 hours.
#'
#' @eval function_params("api_note")
#'
#' @return If the API call succeeds, the function returns a tibble with the
#' following columns:
#' * `timestamp` (POSIXct): date and time of the API request;
#' * `popularity_rank_24h` (integer): popularity rank in the last 24 hours;
#' * `coin_id` (character): coin ID;
#' * `name` (character): common name of the coin;
#' * `symbol` (character): symbol of the coin;
#' * `market_cap_rank` (integer): market capitalisation rank;
#' * `price_btc` (double): price expressed in Bitcoin.
#'
#' @export
#'
#' @examples
#' r <- trending_coins()
#' print(r)
#'
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
  })

  return(dplyr::bind_rows(result))
}
