test_that("ping returns correct results", {
  skip_if_offline("api.coingecko.com")
  expect_type(ping(), "logical")
})
