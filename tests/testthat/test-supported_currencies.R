test_that("supported_currencies returns correct results", {
  result <- supported_currencies()
  expect_type(result, "character")
  expect_true(is.vector(result))
  expect_true(length(result) > 0)
  expect_true(all(c("usd", "gbp", "eur", "btc", "eth") %in% result))
})
