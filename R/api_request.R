#' Make an API call
#'
#' Performs `GET` requests, with a built-in exponential backoff mechanism for retries
#'
#' @param url (character): URL to call.
#' @eval function_params(c("max_attempts"))
#'
#' @return A named list, the structure of which will vary depending on the
#'     actual `GET` request made.
#'
#' @details This function only performs `GET` requests. The `url` is
#'    expected to be built properly before passing onto this function.
#'    The returned data are expected to be in JSON format. This function
#'    will automatically parse the response object and return a named R list
#'    with the respective elements. If no data can be retrieved (e.g. because
#'    of a misspecified query parameter), the function will return nothing
#'    (`NULL`).
#'
#' @keywords internal
#'
api_request <- function(url, max_attempts = 3) {
  if (!curl::has_internet()) {
    message("No internet connection")
    return(invisible(NULL))
  }

  if (!is.character(url)) {
    rlang::abort("`url` must be a character value")
  }

  validate_arguments(arg_max_attempts = max_attempts)

  ua <- httr::user_agent(
    sprintf(
      "geckor/%s (R client for the CoinGecko API; https://github.com/next-game-solutions/geckor)",
      utils::packageVersion("geckor")
    )
  )

  for (attempt in seq_len(max_attempts)) {
    r <- httr::GET(url, ua, httr::timeout(15))

    if (httr::http_error(r)) {
      message("\nFailed to call ", url)
      httr::message_for_status(r)
      delay <- 2^attempt
      message("\nRetrying after ", round(delay, 2), " seconds...")
      Sys.sleep(delay)
    } else {
      break
    }
  }

  if (httr::http_error(r)) {
    message("\nAll calls to ", url, " failed")
    httr::message_for_status(r)
    return(invisible(NULL))
  }

  if (httr::http_type(r) != "application/json") {
    rlang::abort("Returned data are not JSON-formatted")
  }

  parsed <- jsonlite::fromJSON(
    httr::content(r, "text"),
    simplifyVector = FALSE
  )

  if (length(parsed) == 0) {return(NULL)}

  return(parsed)
}
