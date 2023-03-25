#' CoinGecko exchanges
#'
#' Retrieves a list of exchanges supported by the CoinGecko API
#'
#' @eval function_params(c("max_attempts", "api_note"))
#'
#' @return A tibble with the following columns:
#'
#' * `exchange_id` (character): exchange ID;
#' * `name` (character): common name of the exchange;
#' * `year_established` (integer): year when the exchange was established;
#' * `country` (character): country where the exchange is registered and / or
#' has its headquarters;
#' * `url` (character): web address of the exchange;
#' * `trust_score` (integer): an indicator of how much an exchange can be
#' trusted (ranges from 1 to 10; see
#' [Methodology](https://www.coingecko.com/en/methodology) on the CoinGecko
#' website);
#' * `trading_volume_24h_btc` (double): trading volume in the last 24 hours,
#' expressed in Bitcoin.
#'
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @examples FALSE
#' r <- supported_exchanges()
#' print(r)
#'
supported_exchanges <- function(max_attempts = 3) {
  validate_arguments(arg_max_attempts = max_attempts)

  data <- list()
  p <- 1L

  query_parameters <- list(per_page = 100L)

  while (TRUE) {
    query_parameters$page <- p

    url <- build_get_request(
      base_url = "https://api.coingecko.com",
      path = c("api", "v3", "exchanges"),
      query_parameters = query_parameters
    )

    r <- api_request(url = url, max_attempts = max_attempts)

    if (length(r) == 0) {
      break
    }

    data <- c(data, r)

    p <- p + 1
  }

  data_parsed <- lapply(
    data, function(x) {
      x[which(sapply(x, is.null))] <- NA
      x[c(
        "description", "image",
        "trust_score_rank", "has_trading_incentive",
        "trade_volume_24h_btc_normalized"
      )] <- NULL
      x$url <- ifelse(nchar(x$url) == 0, NA, x$url)

      result <- tibble::as_tibble(x) %>%
        dplyr::rename(
          exchange_id = .data$id,
          trading_volume_24h_btc = .data$trade_volume_24h_btc
        )
    }
  ) %>%
    dplyr::bind_rows()

  return(data_parsed)
}
