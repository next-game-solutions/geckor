test_that("coin_tickers returns correct results", {
  skip_on_cran()
  Sys.sleep(10)

  r <- coin_tickers(
    coin_id = "cardano",
    exchange_id = "binance"
  )

  skip_if(is.null(r), "Data could not be retrieved")

  expect_named(r, c(
    "exchange_id", "exchange_name",
    "coin_id", "name",
    "base", "target",
    "trust_score", "last_price",
    "last_fetch_at", "last_traded_at",
    "bid_ask_spread_percentage", "trading_volume_24h",
    "last_price_btc", "last_price_eth",
    "last_price_usd", "trading_volume_24h_btc",
    "trading_volume_24h_eth", "trading_volume_24h_usd",
    "cost_to_move_up_2percent_usd", "cost_to_move_down_2percent_usd",
    "is_anomaly", "is_stale", "trade_url"
  ))

  expect_s3_class(r, "tbl")
  expect_type(r$exchange_id, "character")
  expect_type(r$exchange_name, "character")
  expect_type(r$coin_id, "character")
  expect_type(r$name, "character")
  expect_type(r$base, "character")
  expect_type(r$target, "character")
  expect_type(r$trust_score, "character")
  expect_type(r$last_price, "double")
  expect_s3_class(r$last_fetch_at, "POSIXct")
  expect_s3_class(r$last_traded_at, "POSIXct")
  expect_type(r$bid_ask_spread_percentage, "double")
  expect_type(r$trading_volume_24h, "double")
  expect_type(r$last_price_btc, "double")
  expect_type(r$last_price_eth, "double")
  expect_type(r$last_price_usd, "double")
  expect_type(r$cost_to_move_up_2percent_usd, "double")
  expect_type(r$cost_to_move_down_2percent_usd, "double")
  expect_type(r$is_anomaly, "logical")
  expect_type(r$is_stale, "logical")
})
