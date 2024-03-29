% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/current_market.R
\name{current_market}
\alias{current_market}
\title{Current market data}
\usage{
current_market(coin_ids, vs_currency = "usd", max_attempts = 3)
}
\arguments{
\item{coin_ids}{(character): a vector with IDs of the coins of
interest. An up-to-date list of supported coins and their
IDs can be obtained with the \code{\link[=supported_coins]{supported_coins()}} function.}

\item{vs_currency}{(character): name of the reference currency to
express the price in. An up-to-date list of supported reference currencies (both
fiat and cryptocurrencies) can be obtained with the \code{\link[=supported_currencies]{supported_currencies()}}
function. If an unsupported \code{vs_currency} is requested, the call will
fail with the respective error message.}

\item{max_attempts}{(double, positive): specifies the
maximum number of attempts to call the CoinGecko API (e.g., if
the first call fails for some reason). Additional attempts are
implemented with an exponential backoff. Defaults to 3.}
}
\value{
If the API call succeeds and the requested data exist, this function
will return a tibble with as many rows as the length of \code{coin_ids} and the
following columns:
\itemize{
\item \code{coin_id} (character): coin IDs, ordered by \code{market_cap} (see below);
\item \code{symbol} (character): symbol of the coin;
\item \code{name} (character): common name of the coin;
\item \code{vs_currency} (character): same as the argument \code{vs_currency};
\item \code{last_updated_at} (POSIXct, UTC time zone): timestamp of the last update;
\item \code{current_price} (double): current price (as of \code{last_updated_at})
expressed in \code{vs_currency};
\item \code{market_cap} (double): current market capitalisation;
\item \code{market_cap_rank} (integer): current rank of the coin in terms of its
market capitalisation;
\item \code{fully_diluted_valuation} (double):
\href{https://handbook.clerky.com/fundraising/fully-diluted-capitalization}{fully diluted valuation}
of the coin's project;
\item \code{total_volume} (double): total trading volume in the last 24 hours;
\item \code{high_24h} (double): max price recorded in the last 24 hours;
\item \code{low_24h} (double): min price recorded in the last 24 hours;
\item \code{price_change_24h} (double): price change as compared to 24 hours ago;
\item \code{price_change_percentage_24h} (double): percentage change of the price as
compared to 24 hours ago;
\item \code{market_cap_change_24h} (double): market cap change as compared to 24 hours
ago;
\code{market_cap_change_percentage_24h} (double): percentage change of the market
cap as compared to 24 hours ago;
\item \code{circulating_supply} (double): coin supply currently in circulation;
\item \code{total_supply} (double): total supply that can potentially be circulated;
\item \code{max_supply} (double): max possible supply;
\item \code{ath} (double): all-time high price;
\item \code{ath_change_percentage} (double): percentage change of the all-time high
price compared to the current price;
\item \code{ath_date} (POSIXct, UTC time zone): timestamp of when the all-time high
price was recorded;
\item \code{atl} (double): all-time low price;
\item \code{atl_change_percentage} (double): percentage change of the all-time low
price compared to the current price;
\item \code{atl_date} (POSIXct, UTC timezone): timestamp of when the all-time low
price was recorded;
\item \verb{price_change_percentage_<time>_in_currency}: columns containing the
percentage change in price as compared to various points in the past
(in particular, 1 hour, 24 hours, 7 days, 14 days, 30 days, 200 days,
and 1 year).
}

If no data can be retrieved (e.g., because of going over the API
rate limit or mis-specifying the query parameters), the function
returns nothing (\code{NULL}).
}
\description{
Retrieves current market data for a set of coins
}
\details{
If no data can be retrieved (e.g., because of a misspecified
query parameter), nothing (\code{NULL}) will be returned.

This function is based on the public
\href{https://www.coingecko.com/api/documentations/v3}{CoinGecko API},
which has a rate limit of 10-30 calls per minute. Please
keep this limit in mind when developing your applications.
}
\examples{
\dontshow{if (ping()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
r <- current_market(
  coin_ids = c("bitcoin", "ethereum", "cardano"),
  vs_currency = "usd"
)
print(r)
\dontshow{\}) # examplesIf}
}
