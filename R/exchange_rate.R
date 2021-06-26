#' Exchange rates
#'
#' Retrieves current exchange rate for a crypto- of fiat currency in Bitcoin
#' @param currency (character or `NULL`): a vector with abbreviated names of the
#'     currencies of interest. An up-to-date list of supported currencies (both
#'     fiat and cryptocurrencies) can be retrieved with the [supported_currencies()]
#'     function. If an unsupported `currency` is requested, the call will fail
#'     with the respective error message. If `currency = NULL` (default), the
#'     function will return exchange rates for all supported currencies.
#'
#' @eval function_params(c("max_attempts", "api_note"))
#'
#' @return A tibble with the following columns:
#'
#' * `timestamp` (POSIXct): date and time of the API request;
#' * `currency` (character): abbreviated name of the currency;
#' * `name` (character): common name of the currency;
#' * `price_in_btc` (double): price in Bitcoin;
#' * `type` (character): type of the currency (`"fiat"` or `"crypto"`).
#'
#' @export
#'
#' @examples
#' # get exchange rates for all supported currencies
#' r1 <- exchange_rate()
#' print(r1)
#'
#' # get exchange rates for a set of currencies:
#' r2 <- exchange_rate(currency = c("usd", "eur", "gbp"))
#' print(r2)
exchange_rate <- function(currency = NULL,
                          max_attempts = 3) {
  validate_arguments(
    arg_vs_currencies = currency,
    arg_max_attempts = max_attempts
  )

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "exchange_rates"),
    query_parameters = NULL
  )

  ts <- Sys.time()

  r <- api_request(
    url = url,
    max_attempts = max_attempts
  )$rates

  if (!is.null(currency)) {
    r <- r[currency]
  }

  result <- r %>%
    lapply(tibble::as_tibble) %>%
    dplyr::bind_rows() %>%
    dplyr::select(-.data$unit) %>%
    dplyr::rename(price_in_btc = .data$value)

  return(
    dplyr::bind_cols(
      timestamp = ts,
      currency = names(r),
      result
    ) %>%
      dplyr::arrange(currency)
  )
}
