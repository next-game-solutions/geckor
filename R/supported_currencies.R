#' Get CoinGecko currencies
#'
#' Retrieves a list of base currencies currently supported by the CoinGecko API
#'
#' @eval function_params("max_attempts")
#'
#' @return Character vector with abbreviated names of the currencies.
#' @export
#'
#' @examples
#' r <- supported_currencies()
#' print(r)
supported_currencies <- function(max_attempts = 3L) {
  validate_arguments(arg_max_attempts = max_attempts)

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "simple", "supported_vs_currencies"),
    query_parameters = list()
  )

  supported_currencies <- api_request(
    url = url,
    max_attempts = max_attempts
  )

  return(unlist(supported_currencies))
}
