exchange_rate <- function(currency = NULL,
                          max_attempts = 3L) {
  validate_arguments(
    arg_vs_currencies = currency,
    arg_max_attempts = max_attempts
  )

  url <- build_get_request(
    base_url = "https://api.coingecko.com",
    path = c("api", "v3", "exchange_rates"),
    query_parameters = NULL
  )

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
    dplyr::select(-unit)

  return(
    dplyr::bind_cols(id = names(r), result) %>%
      dplyr::arrange(id)
  )
}
