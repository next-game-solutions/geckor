test_that("supported_exchanges returns correct results", {
  skip_on_cran()
  Sys.sleep(30)

  r <- supported_exchanges()
  skip_if(is.null(r), "Data could not be retrieved")

  Sys.sleep(2)

  expect_named(r, c(
    "exchange_id",
    "name",
    "year_established",
    "country",
    "url",
    "trust_score",
    "trading_volume_24h_btc"
  ))

  expect_s3_class(r, "tbl")
  expect_type(r$exchange_id, "character")
  expect_type(r$name, "character")
  expect_type(r$year_established, "integer")
  expect_type(r$url, "character")
  expect_type(r$trust_score, "integer")
  expect_type(r$trading_volume_24h_btc, "double")
})
