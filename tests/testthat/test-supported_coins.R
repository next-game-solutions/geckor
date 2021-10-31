test_that("supported_coins returns correct objects", {
  r <- supported_coins(max_attempts = 3L)

  Sys.sleep(5)

  expect_s3_class(r, "tbl")
  expect_named(r, c("coin_id", "symbol", "name"))
  expect_type(r$coin_id, "character")
  expect_type(r$symbol, "character")
  expect_type(r$name, "character")
})
