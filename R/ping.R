#' API health check
#'
#' Pings the CoinGecko API to check if the service is available
#'
#' @details This function has no arguments.
#'
#' @return Returns `TRUE` if the service is available and `FALSE` otherwise.
#' @export
#'
#' @examplesIf FALSE
#' ifelse(ping(), "API is available", "API is not available")
#'
ping <- function() {
  base_url <- "https://api.coingecko.com"
  url <- httr::modify_url(base_url, path = c("api", "v3", "ping"))
  ua <- httr::user_agent(
    sprintf(
      "geckor/%s (R client for the CoinGecko API; https://github.com/next-game-solutions/geckor)",
      utils::packageVersion("geckor")
    )
  )
  tryCatch(
    {
      r <- httr::GET(url, ua, httr::timeout(10))
      httr::status_code(r) == 200
    },
    error = function(e) {
      return(FALSE)
    }
  )
}
