test_that("coin_history_ohlc returns correct results", {
  expect_error(coin_history_ohlc(
    coin_id = "abcde",
    vs_currency = "usd",
    days = 7,
    max_attempts = 1L
  ))

  expect_error(coin_history_ohlc(
    coin_id = "cardano",
    vs_currency = "abcde",
    days = 7,
    max_attempts = 1L
  ))

  expect_error(coin_history_ohlc(
    coin_id = "cardano",
    vs_currency = "usd",
    days = 11,
    max_attempts = 1L
  ))

  r <- coin_history_ohlc(
    coin_id = "cardano",
    vs_currency = "usd",
    days = 7,
    max_attempts = 1L
  )

  expect_named(r, c(
    "timestamp", "coin_id", "vs_currency", "price_open",
    "price_high", "price_low", "price_close"
  ))

  expect_s3_class(r, "tbl")
  expect_s3_class(r$timestamp, "POSIXct")
  expect_type(r$coin_id, "character")
  expect_type(r$vs_currency, "character")
  expect_type(r$price_open, "double")
  expect_type(r$price_high, "double")
  expect_type(r$price_low, "double")
  expect_type(r$price_close, "double")
})
