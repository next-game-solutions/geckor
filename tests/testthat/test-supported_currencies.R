test_that("supported_currencies returns correct results", {
  skip_on_cran()
  Sys.sleep(61)

  r <- supported_currencies()
  skip_if(is.null(r), "Data could not be retrieved")

  expect_type(r, "character")
  expect_true(is.vector(r))
  expect_true(length(r) > 0)
  expect_true(all(c("usd", "gbp", "eur", "btc", "eth") %in% r))
})
