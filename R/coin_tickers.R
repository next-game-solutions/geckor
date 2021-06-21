coin_tickers <- function(coin_id,
                         exchange_id,
                         max_attempts = 3L) {
  if (length(coin_id) > 1L) {
    rlang::abort("Only one `coin_id` is allowed")
  }

  validate_arguments(
    arg_coin_ids = coin_id,
    arg_exchange_id = exchange_id,
    arg_max_attempts = max_attempts
  )

  data <- list()
  p <- 1L

  query_parameters <- list(
    exchange_ids = exchange_id,
    depth = tolower(TRUE),
    include_exchange_logo = tolower(FALSE))

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
      path = c("api", "v3", "coins", coin_id, "tickers"),
      query_parameters = query_parameters
    )

    r <- api_request(url = url, max_attempts = max_attempts)

    if (length(r$tickers) == 0) {
      break
    }

    data <- c(data, r)

    p <- p + 1

    pb$tick()
  }

  data_parsed <- lapply(data$tickers, function(x){
    x[which(sapply(x, is.null))] <- NA
    result <- tibble::tibble(
      exchange_id = exchange_id,
      exchange_name = x$market$name,
      coin_id = coin_id,
      name = data$name,
      base = x$base,
      target = x$target,
      trust_score = x$trust_score,
      last_price = x$last,
      last_fetch_at = as.POSIXct(gsub("T", " ", x$last_fetch_at),
                                 origin = as.Date("1970-01-01"),
                                 tz = "UTC",
                                 format = "%Y-%m-%d %H:%M:%S"),
      last_traded_at = as.POSIXct(gsub("T", " ", x$last_traded_at),
                                  origin = as.Date("1970-01-01"),
                                  tz = "UTC",
                                  format = "%Y-%m-%d %H:%M:%S"),
      bid_ask_spread_percentage = x$bid_ask_spread_percentage,
      trading_volume_24h = x$volume,
      last_price_in_btc = x$converted_last$btc,
      last_price_in_eth = x$converted_last$eth,
      last_price_in_usd = x$converted_last$usd,
      trading_volume_24h_in_btc = x$converted_volume$btc,
      trading_volume_24h_in_eth = x$converted_volume$eth,
      trading_volume_24h_in_usd = x$converted_volume$usd,
      cost_to_move_up_2percent_in_usd = x$cost_to_move_up_usd,
      cost_to_move_down_2percent_in_usd = x$cost_to_move_down_usd,
      is_anomaly = x$is_anomaly,
      is_stale = x$is_stale,
      trade_url = x$trade_url
    )
    return(result)
  }
  ) %>%
    dplyr::bind_rows()

  return(data_parsed)
}
