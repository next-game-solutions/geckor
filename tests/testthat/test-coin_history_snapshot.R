test_that("history_snapshot returns correct results", {
  expect_error(coin_history_snapshot(
    coin_id = c("abscde"),
    date = as.Date("2021-05-01"),
    vs_currencies = c("usd", "gbp"),
    max_attempts = 1L
  ))

  expect_error(coin_history_snapshot(
    coin_id = c("cardano"),
    date = as.Date("2021-05-01"),
    vs_currencies = c("abcde", "gbp"),
    max_attempts = 1L
  ))

  expect_null(coin_history_snapshot(
    coin_id = c("cardano"),
    date = as.Date("1900-05-01"),
    vs_currencies = c("usd", "gbp"),
    max_attempts = 1L
  ))

  r <- coin_history_snapshot(
    coin_id = "cardano",
    date = as.Date("2021-05-01"),
    vs_currencies = c("usd", "eth")
  )

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
})
