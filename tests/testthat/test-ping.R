test_that("ping returns correct results", {
  skip_if_offline("api.coingecko.com")
  skip_on_cran()
  Sys.sleep(60)
  expect_type(ping(), "logical")
})
