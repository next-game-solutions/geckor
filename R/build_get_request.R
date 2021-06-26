#' Build URLs for `GET` requests
#'
#' Returns a URL properly formatted for a `GET` request
#'
#' @param base_url (character): API's base URL (host). Defaults to
#'     `"https://api.coingecko.com"`.
#' @param path (character): vector, whose elements form the path of the
#'     respective API endpoint. The order of these elements is important. For
#'     example, if the path is `api/v3/ping`, then this vector must be
#'     `path = c("api", "v3", "ping")`. Can be a `NULL` value.
#' @param query_parameters (named list): contains parameters of the request.
#'     Can be a `NULL` value.
#'
#' @details No validation of the base URL is performed by this function,
#'     so users are advised to ensure that the base URL is correctly
#'     formatted and encoded.
#'
#' @return A URL that is ready to be used in a `GET` request.
#'
#' @keywords internal
#'
build_get_request <- function(base_url = "https://api.coingecko.com",
                              path,
                              query_parameters) {
  if (!is.character(base_url)) {
    rlang::abort("`base_url` must be a character value")
  }

  if (!is.character(path) & !is.null(path)) {
    rlang::abort("`path` must be a character vector or NULL")
  }

  if (!is.list(query_parameters) & !is.null(query_parameters)) {
    rlang::abort("`query_parameters` must be a named list or NULL")
  }


  url <- httr::modify_url(base_url, path = path)
  url <- httr::parse_url(url)
  url$query <- query_parameters
  url <- httr::build_url(url)

  return(url)
}
