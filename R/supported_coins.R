#' CoinGecko coins
#'
#' Retrieves a list of coins currently supported by the CoinGecko API
#'
#' @eval function_params(c("max_attempts", "api_note"))
#'
#' @return A tibble with three columns:
#' * `coin_id` (character): coin IDs, ordered alphabetically;
#' * `symbol` (character): coin symbols;
#' * `name` (character): common names of the coins.
#'
#' @export
#'
#' @examplesIf ping()
#' r <- supported_coins()
#' head(r, 10)
#'
supported_coins <- function(max_attempts = 3) {
  validate_arguments(arg_max_attempts = max_attempts)

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "coins", "list"),
    query_parameters = list(include_platform = tolower(FALSE))
  )

  r <- api_request(
    url = url,
    max_attempts = max_attempts
  )

  result <- lapply(r, function(x) {
    tibble::tibble(
      coin_id = x$id,
      symbol = x$symbol,
      name = x$name
    )
  })

  return(dplyr::bind_rows(result))
}
