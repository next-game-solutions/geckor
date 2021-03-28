test_that("function_params works as expected", {
  expect_true(is.na(function_params(arguments = "abcs")))
  expect_type(function_params(arguments = "max_attempts"), "character")
  expect_true(grepl("@param", function_params(arguments = c("max_attempts"))))
  expect_true(grepl("max_attempts", function_params(arguments = c("max_attempts"))))
})
