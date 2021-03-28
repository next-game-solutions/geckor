test_that("build_get_request returns correct value", {
  r <- build_get_request("https://api.coingecko.com",
    path = c("api", "v3", "ping"),
    query_parameters = NULL
  )
  expect_identical(r, "https://api.coingecko.com/api/v3/ping")
})
