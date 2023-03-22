test_that("api_request returns correct objects", {
  skip_on_cran()
  Sys.sleep(80)
  skip_if_not(ping(), message = "Skipping test as the API call rate has been exceeded")

  base_url <- "https://api.coingecko.com"
  url <- httr::modify_url(base_url, path = c("api", "v3", "ping"))

  r <- api_request(url = url, max_attempts = 3L)
  data <- r$gecko_says

  expect_identical(data, "(V3) To the Moon!")
})
