% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ping.R
\name{ping}
\alias{ping}
\title{API health check}
\usage{
ping()
}
\value{
Returns \code{TRUE} if the service is available and \code{FALSE} otherwise.
}
\description{
Pings the CoinGecko API to check if the service is available
}
\details{
This function has no arguments.
}
\examples{
\dontshow{if (FALSE) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
ifelse(ping(), "API is available", "API is not available")
\dontshow{\}) # examplesIf}
}
