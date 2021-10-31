test_that("coin_history_range returns correct results", {
  skip_on_cran()
  Sys.sleep(10)

  r <- coin_history_range(
    coin_id = c("cardano"),
    vs_currency = "usd",
    from = as.POSIXct("2021-01-01 13:00:00", tz = "UTC"),
    to = as.POSIXct("2021-01-01 18:00:00", tz = "UTC")
  )

  skip_if(is.null(r), "Data could not be retrieved")

  r2 <- coin_history_range(
    coin_id = c("bitcoin", "polkadot", "tron"),
    vs_currency = "usd",
    from = as.POSIXct("2021-10-27 00:00:00", tz = "UTC"),
    to = as.POSIXct("2021-10-29 00:00:00", tz = "UTC")
  )

  skip_if(is.null(r2), "Data could not be retrieved")

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
  expect_true(all(unique(r2$coin_id) %in% c("bitcoin", "polkadot", "tron")))
})
