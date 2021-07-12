test_that("coin_history returns correct results", {
  r <- coin_history(
    coin_id = "bitcoin",
    vs_currency = "usd",
    days = 7L
  )

  expect_named(r, c(
    "timestamp", "coin_id", "vs_currency", "price",
    "total_volume", "market_cap"
  ))

  expect_s3_class(r$timestamp, "POSIXct")
  expect_type(r$coin_id, "character")
  expect_type(r$vs_currency, "character")
  expect_type(r$price, "double")
  expect_type(r$total_volume, "double")
  expect_type(r$market_cap, "double")
})