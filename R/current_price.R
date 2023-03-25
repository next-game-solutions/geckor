#' Current coin prices
#'
#' Retrieves current prices of supported coins
#'
#' @eval function_params(c("coin_ids", "vs_currencies", "include_market_cap",
#'                         "include_24h_vol", "include_24h_change",
#'                         "max_attempts", "api_note"))
#'
#' @details If no data can be retrieved (e.g. because of a misspecified
#'    query parameter), nothing (`NULL`) will be returned.
#'
#' @return If the API call succeeds, the function returns a tibble, which by
#' default will contain the following columns (use arguments
#' `include_market_cap`, `include_24h_vol` and `include_24h_change`
#' to control the inclusion of the corresponding columns):
#' * `coin_id` (character): coin IDs, ordered alphabetically;
#' * `price` (double): coin price;
#' * `vs_currency` (character): reference currency, in which the price of
#' `coin_id` is expressed;
#' * `market_cap` (double): current market capitalisation;
#' * `vol_24h` (double): trading volume in the last 24 hours;
#' * `price_percent_change_24h` (double): percentage change of the price as
#' compared to 24 hours ago;
#' * `last_updated_at` (POSIXct, UTC time zone): timestamp of the last price
#' update.
#'
#' If no data can be retrieved (e.g., because of going over the API
#' rate limit or mis-specifying the query parameters), the function
#' returns nothing (`NULL`).
#'
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @examplesIf FALSE
#' r <- current_price(
#'   coin_ids = c("aave", "tron", "bitcoin"),
#'   vs_currencies = c("usd", "eur", "gbp")
#' )
#' print(r)
#'
current_price <- function(coin_ids,
                          vs_currencies = c("usd"),
                          include_market_cap = TRUE,
                          include_24h_vol = TRUE,
                          include_24h_change = TRUE,
                          max_attempts = 3) {
  validate_arguments(
    arg_coin_ids = coin_ids,
    arg_vs_currencies = vs_currencies,
    arg_include_market_cap = include_market_cap,
    arg_include_24h_vol = include_24h_vol,
    arg_include_24h_change = include_24h_change,
    arg_max_attempts = max_attempts
  )

  query_params <- list(
    ids = paste(coin_ids, collapse = ","),
    vs_currencies = paste0(vs_currencies, collapse = ","),
    include_market_cap = tolower(include_market_cap),
    include_24hr_vol = tolower(include_24h_vol),
    include_24hr_change = tolower(include_24h_change),
    include_last_updated_at = tolower(TRUE)
  )

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "simple", "price"),
    query_parameters = query_params
  )

  r <- api_request(url = url, max_attempts = max_attempts)

  if (is.null(r)) {
    message("\nNo data could be retrieved.")
    return(NULL)
  }

  result <- lapply(r, function(x) {
    if (include_market_cap) {
      market_cap <- as.numeric(
        x[paste(vs_currencies, "market_cap", sep = "_")]
      )
    } else {
      market_cap <- NULL
    }

    if (include_24h_vol) {
      vol_24h <- as.numeric(
        x[paste(vs_currencies, "24h_vol", sep = "_")]
      )
    } else {
      vol_24h <- NULL
    }

    if (include_24h_change) {
      change_24h <- as.numeric(
        x[paste(vs_currencies, "24h_change", sep = "_")]
      )
    } else {
      change_24h <- NULL
    }

    tibble::tibble(
      price = as.numeric(x[vs_currencies]),
      vs_currency = vs_currencies
    ) %>%
      dplyr::mutate(
        market_cap = market_cap,
        vol_24h = vol_24h,
        price_percent_change_24h = change_24h,
        last_updated_at = as.POSIXct(x$last_updated_at,
          origin = as.Date("1970-01-01"),
          tz = "UTC",
          format = "%Y-%m-%d %H:%M:%S"
        )
      )
  }) %>%
    dplyr::bind_rows(.id = "coin_id") %>%
    dplyr::arrange(.data$coin_id)

  return(result)
}
