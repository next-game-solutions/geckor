test_that("validate_arguments throws errors as expected", {
  expect_error(validate_arguments(arg_max_attempts = "1L"))
  expect_error(validate_arguments(arg_max_attempts = -1L))
})


test_that("validate_arguments returns nothing as expected", {
  expect_null(
    validate_arguments(
      arg_max_attempts = 3L
    )
  )
})
