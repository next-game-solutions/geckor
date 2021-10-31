test_that("supported_coins returns correct objects", {
  skip_if_offline("api.coingecko.com")
  skip_on_cran()
  if (!ping()) {Sys.sleep(60)}

  r <- supported_coins(max_attempts = 3L)
  skip_if(is.null(r), "Data could not be retrieved")

  Sys.sleep(2)

  expect_s3_class(r, "tbl")
  expect_named(r, c("coin_id", "symbol", "name"))
  expect_type(r$coin_id, "character")
  expect_type(r$symbol, "character")
  expect_type(r$name, "character")
})
