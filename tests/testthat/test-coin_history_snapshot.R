test_that("history_snapshot returns correct results", {
  skip_on_cran()
  Sys.sleep(10)

  r <- coin_history_snapshot(
    coin_id = "cardano",
    date = as.Date("2021-05-01"),
    vs_currencies = c("usd", "eth")
  )

  skip_if(is.null(r), "Data could not be retrieved")

  r2 <- coin_history_snapshot(
    coin_id = c("bitcoin", "polkadot", "tron"),
    date = as.Date("2021-05-01"),
    vs_currencies = c("usd", "eth")
  )

  skip_if(is.null(r2), "Data could not be retrieved")

  expect_s3_class(r, "tbl")

  expect_named(r, c(
    "coin_id",
    "symbol",
    "name",
    "date",
    "vs_currency",
    "price",
    "market_cap",
    "total_volume"
  ))

  expect_equal(unique(r$coin_id), "cardano")
  expect_equal(unique(r$symbol), "ada")
  expect_equal(unique(r$name), "Cardano")
  expect_equal(unique(r$date), as.Date("2021-05-01"))

  expect_setequal(r$vs_currency, c("eth", "usd"))

  expect_type(r$price, "double")
  expect_type(r$market_cap, "double")
  expect_type(r$total_volume, "double")

  expect_equal(nrow(r2), 6)
  expect_setequal(unique(r2$coin_id), c("bitcoin", "polkadot", "tron"))
})
