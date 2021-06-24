trending_coins <- function(max_attempts = 3L) {
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
      search_popularity_rank_24h = x$score + 1,
      coin_id = x$id,
      name = x$name,
      symbol = x$symbol,
      slug = x$slug,
      market_cap_rank = x$market_cap_rank,
      price_btc = x$price_btc
    )
  }) %>%
    dplyr::bind_rows()

  return(result)
}
