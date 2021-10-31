test_that("supported_currencies returns correct results", {
  if (!ping()) {Sys.sleep(60)}

  r <- supported_currencies(max_attempts = 1)

  Sys.sleep(1)

  expect_type(r, "character")
  expect_true(is.vector(r))
  expect_true(length(r) > 0)
  expect_true(all(c("usd", "gbp", "eur", "btc", "eth") %in% r))
})
