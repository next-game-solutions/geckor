test_that("ping returns correct results", {
  skip_if_offline("api.coingecko.com")
  skip_on_cran()
  expect_type(ping(), "logical")
})
