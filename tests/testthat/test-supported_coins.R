test_that("supported_coins returns correct objects", {
  skip_on_cran()
  Sys.sleep(60)
  skip_if_not(ping(), message = "Skipping test as the API call rate has been exceeded")

  r <- supported_coins()
  skip_if(is.null(r), "Data could not be retrieved")

  expect_s3_class(r, "tbl")
  expect_named(r, c("coin_id", "symbol", "name"))
  expect_type(r$coin_id, "character")
  expect_type(r$symbol, "character")
  expect_type(r$name, "character")
})
