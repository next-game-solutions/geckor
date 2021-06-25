test_that("trending_coins returns correct results", {
  r <- trending_coins(max_attempts = 3L)

  expect_s3_class(r, "tbl")
  expect_named(r, c(
    "timestamp", "popularity_rank_24h",
    "coin_id", "name",
    "symbol", "market_cap_rank",
    "price_btc"
  ))
  expect_s3_class(r$timestamp, "POSIXct")
  expect_type(r$popularity_rank_24h, "integer")
  expect_type(r$coin_id, "character")
  expect_type(r$name, "character")
  expect_type(r$symbol, "character")
  expect_type(r$market_cap_rank, "integer")
  expect_type(r$price_btc, "double")
})
