test_that("exchange_rates returns correct results", {
  r1 <- exchange_rate(currency = NULL, max_attempts = 1L)
  r2 <- exchange_rate(currency = c("usd", "eur", "gbp"),
                      max_attempts = 1L)

  expect_s3_class(r1, "tbl")
  expect_s3_class(r2, "tbl")

  tbl_names <- c("timestamp", "currency", "name", "price_in_btc", "type")
  expect_named(r1, tbl_names)
  expect_named(r2, tbl_names)

  expect_true(nrow(r1) > 3)
  expect_equal(nrow(r2), 3)

  expect_s3_class(r1$timestamp, "POSIXct")
  expect_type(r1$currency, "character")
  expect_type(r1$name, "character")
  expect_type(r1$price_in_btc, "double")
  expect_type(r1$type, "character")
})
