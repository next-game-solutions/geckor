test_that("current_market returns correct results", {
  skip_on_cran()
  Sys.sleep(10)

  r <- current_market(
    coin_ids = c("aave", "tron", "bitcoin"),
    vs_currency = "usd"
  )

  skip_if(is.null(r), "Data could not be retrieved")

  expect_s3_class(r, "tbl")

  expect_named(r, c(
    "coin_id",
    "symbol",
    "name",
    "vs_currency",
    "last_updated_at",
    "current_price",
    "market_cap",
    "market_cap_rank",
    "fully_diluted_valuation",
    "total_volume",
    "high_24h",
    "low_24h",
    "price_change_24h",
    "price_change_percentage_24h",
    "market_cap_change_24h",
    "market_cap_change_percentage_24h",
    "circulating_supply",
    "total_supply",
    "max_supply",
    "ath",
    "ath_change_percentage",
    "ath_date",
    "atl",
    "atl_change_percentage",
    "atl_date",
    "price_change_percentage_1h_in_currency",
    "price_change_percentage_24h_in_currency",
    "price_change_percentage_7d_in_currency",
    "price_change_percentage_14d_in_currency",
    "price_change_percentage_30d_in_currency",
    "price_change_percentage_200d_in_currency",
    "price_change_percentage_1y_in_currency"
  ))

  expect_true(all(unique(r$coin_id) %in% c("aave", "bitcoin", "tron")))

  expect_equal(unique(r$vs_currency), "usd")

  expect_s3_class(r$last_updated_at, "POSIXct")
  expect_s3_class(r$ath_date, "POSIXct")
  expect_s3_class(r$atl_date, "POSIXct")
})
