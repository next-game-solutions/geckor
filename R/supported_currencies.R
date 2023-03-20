#' CoinGecko currencies
#'
#' Retrieves a list of base currencies currently supported by the CoinGecko API
#'
#' @eval function_params(c("max_attempts", "api_note"))
#'
#' @return Character vector with abbreviated names of the currencies.
#' @export
#'
#' @examplesIf ping()
#' r <- supported_currencies()
#' print(r)
#'
supported_currencies <- function(max_attempts = 3) {
  validate_arguments(arg_max_attempts = max_attempts)

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "simple", "supported_vs_currencies"),
    query_parameters = NULL
  )

  supported_currencies <- api_request(
    url = url,
    max_attempts = max_attempts
  )

  return(unlist(supported_currencies))
}
