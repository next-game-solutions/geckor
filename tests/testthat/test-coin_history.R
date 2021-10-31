test_that("coin_history returns correct results", {
  skip_if_offline("api.coingecko.com")
  skip_on_cran()
  if (!ping()) {Sys.sleep(60)}

  r <- coin_history(
    coin_id = "bitcoin",
    vs_currency = "usd",
    days = 7L
  )

  skip_if(is.null(r), "Data could not be retrieved")

  r2 <- coin_history(
    coin_id = c("bitcoin", "ethereum", "polkadot"),
    vs_currency = "usd",
    days = 7L
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
  expect_true(all(unique(r2$coin_id) %in% c("bitcoin", "ethereum", "polkadot")))
})
