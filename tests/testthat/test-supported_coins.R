test_that("supported_coins returns correct objects", {
  if (!ping()) {Sys.sleep(60)}

  r <- supported_coins(max_attempts = 2L)

  Sys.sleep(1)

  expect_s3_class(r, "tbl")
  expect_named(r, c("coin_id", "symbol", "name"))
  expect_type(r$coin_id, "character")
  expect_type(r$symbol, "character")
  expect_type(r$name, "character")
})
