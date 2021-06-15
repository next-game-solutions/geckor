test_that("coin_history_range returns correct results", {
  from <- as.POSIXct("2021-01-01 13:00:00", tz = "UTC")
  to <- as.POSIXct("2021-01-01 18:00:00", tz = "UTC")

  expect_error(coin_history_range(
    coin_id = "abcde",
    vs_currency = "usd",
    from = from,
    to = to,
    max_attempts = 1L
  ))

  expect_error(coin_history_range(
    coin_id = "cardano",
    vs_currency = "abcde",
    from = from,
    to = to,
    max_attempts = 1L
  ))

  expect_error(coin_history_range(
    coin_id = c("cardano", "bitcoin"),
    vs_currency = "usd",
    from = from,
    to = to,
    max_attempts = 1L
  ))

  expect_error(coin_history_range(
    coin_id = c("cardano"),
    vs_currency = c("usd", "eur"),
    from = from,
    to = to,
    max_attempts = 1L
  ))

  r <- coin_history_range(
    coin_id = c("cardano"),
    vs_currency = "usd",
    from = from,
    to = to,
    max_attempts = 1L
  )

  expect_named(r, c(
    "timestamp", "vs_currency", "price",
    "total_volume", "market_cap"
  ))

  expect_s3_class(r$timestamp, "POSIXct")
  expect_type(r$vs_currency, "character")
  expect_type(r$price, "double")
  expect_type(r$total_volume, "double")
  expect_type(r$market_cap, "double")
})
