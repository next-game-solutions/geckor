test_that("trending_coins returns correct results", {
  skip_on_cran()
  Sys.sleep(10)

  r <- trending_coins()
  skip_if(is.null(r), "Data could not be retrieved")

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
