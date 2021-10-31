test_that("coin_history_ohlc returns correct results", {
  if (!ping()) {Sys.sleep(60)}

  r <- coin_history_ohlc(
    coin_id = "cardano",
    vs_currency = "usd",
    days = 7L,
    max_attempts = 1L
  )

  r2 <- coin_history_ohlc(
    coin_id = c("bitcoin", "polkadot", "tron"),
    vs_currency = "usd",
    days = 7L,
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

  expect_setequal(unique(r2$coin_id), c("bitcoin", "polkadot", "tron"))
})
