test_that("current_price returns correct results", {
  r <- current_price(
    coin_ids = c("aave", "tron", "bitcoin"),
    vs_currencies = c("usd", "eur", "gbp"),
    include_market_cap = TRUE,
    include_24h_vol = TRUE,
    include_24h_change = TRUE,
    max_attempts = 1L
  )

  expect_s3_class(r, "tbl")

  expect_named(r, c(
    "coin_id", "price", "vs_currency",
    "market_cap", "vol_24h", "price_percent_change_24h",
    "last_updated_at"
  ))

  expect_equal(unique(r$coin_id), c("aave", "bitcoin", "tron"))

  expect_equal(unique(r$vs_currency), c("usd", "eur", "gbp"))

  expect_s3_class(r$last_updated_at, "POSIXct")
})