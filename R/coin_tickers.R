#' Exchange tickers
#'
#' Retrieves the most recent tickers for a coin
#'
#' @eval function_params("coin_id")
#' @param exchange_id (character): ID of the exchange to retrive the data from.
#'     An up-to-date list of supported exchanges and their IDs can be retrieved
#'     with the [supported_exchanges()] function.
#' @eval function_params(c("max_attempts", "api_note"))
#'
#' @return A tibble with the following columns:
#'
#' * `exchange_id` (character): exchange ID;
#' * `exchange_name` (character): common name of the exchange;
#' * `coin_id` (character): coin ID;
#' * `name` (character): common name of the coin;
#' * `base` (character): symbol of the base currency in the trading pair;
#' * `target` (character): symbol of the target currency in the trading pair;
#' * `trust_score` (character): trust score of this trading pair at this exchange
#' (`"green"`, `"orange"`, `"red"`; see
#' [this](https://blog.coingecko.com/trust-score/) and
#' [this](https://blog.coingecko.com/trust-score-2/) articles on the CoinGecko
#' website);
#' * `last_price` (double): last price reported by this exchange for this
#' trading pair;
#' * `last_fetch_at` (POSIXct, UTC time zone): timestamp of when `last_price`
#' was recorded;
#' * `last_traded_at` (POSIXct, UTC time zone): timestamp of the most recent
#' trade;
#' * `bid_ask_spread_percentage` (double): percentage difference between
#' the ask price (lowest price a seller is willing to sell) and the bid price
#' (highest price a buyer is willing to buy; see
#' [Investopedia](https://www.investopedia.com/terms/b/bid-askspread.asp) for
#' details);
#' `trading_volume_24` (double): trading volume (in `target` currency)
#' recorded in the last 24 hours (as of `last_traded_at`);
#' * `last_price_btc` (double): last price reported by this exchange for this
#' `coin_id`, expressed in Bitcoin;
#' * `last_price_eth` (double): last price reported by this exchange for this
#' `coin_id`, expressed in Ethereum;
#' * `last_price_usd` (double): last price reported by this exchange for this
#' * `coin_id`, expressed in US dollars;
#' * `trading_volume_24h_btc` (double): 24-hours trading volume expressed in
#' Bitcoin (as of `last_traded_at`);
#' * `trading_volume_24h_eth` (double): 24-hours trading volume expressed in
#' Ethereum;
#' * `trading_volume_24h_usd` (double): 24-hours trading volume expressed in
#' US dollars;
#' * `cost_to_move_up_2percent_usd` and `cost_to_move_down_2percent_usd`
#' (double): 2% market depth (see
#' [this](https://blog.coingecko.com/trust-score/) article on the CoinGecko
#' website for details);
#' * `is_anomaly` (logical): an indicator of whether the ticker's price is an
#' outlier (see "Outlier detection" in
#' [Methodology](https://www.coingecko.com/en/methodology) on the GoinGecko
#' website);
#' * `is_stale` (logical): an indicator of whether the ticker's price nos not
#' been updated for a while (see "Outlier detection" in
#' [Methodology](https://www.coingecko.com/en/methodology) on the GoinGecko
#' website);
#' * `trade_url` (character): URL to this trading pair's page.
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' r <- coin_tickers(coin_id = "cardano", exchange_id = "binance")
#' print(r)
coin_tickers <- function(coin_id,
                         exchange_id,
                         max_attempts = 3) {
  if (length(coin_id) > 1L) {
    rlang::abort("Only one `coin_id` is allowed")
  }

  if (length(exchange_id) > 1L) {
    rlang::abort("Only one `exchange_id` is allowed")
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
    include_exchange_logo = tolower(FALSE)
  )

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
  }

  data_parsed <- lapply(data$tickers, function(x) {
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
        format = "%Y-%m-%d %H:%M:%S"
      ),
      last_traded_at = as.POSIXct(gsub("T", " ", x$last_traded_at),
        origin = as.Date("1970-01-01"),
        tz = "UTC",
        format = "%Y-%m-%d %H:%M:%S"
      ),
      bid_ask_spread_percentage = x$bid_ask_spread_percentage,
      trading_volume_24h = x$volume,
      last_price_btc = x$converted_last$btc,
      last_price_eth = x$converted_last$eth,
      last_price_usd = x$converted_last$usd,
      trading_volume_24h_btc = x$converted_volume$btc,
      trading_volume_24h_eth = x$converted_volume$eth,
      trading_volume_24h_usd = x$converted_volume$usd,
      cost_to_move_up_2percent_usd = x$cost_to_move_up_usd,
      cost_to_move_down_2percent_usd = x$cost_to_move_down_usd,
      is_anomaly = x$is_anomaly,
      is_stale = x$is_stale,
      trade_url = x$trade_url
    )
    return(result)
  }) %>%
    dplyr::bind_rows()

  return(data_parsed)
}
