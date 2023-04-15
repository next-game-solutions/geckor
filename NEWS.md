# geckor 0.3.0

As v0.3.0, `geckor` is no longer published on CRAN. 

## Major changes

CoinGecko significantly reduced the rate limit of the free version of its API - from 50 to ca. 10-30 calls/minute. This had a dramatic effect on how `geckor` functions and how much data can be retrieved using its functions. In particular, the following changes had to be introduced in v0.3.0:

* All of the `coin_history_*` functions now accept a much smaller number of coin IDs to process simultaneously (5 vs 30 in v0.2.0).
* The `coin_tickers()` function retrieves up to 5 pages of data.
* Examples in the package documentation now won't execute when running `R CMD check`.
* Examples in vignettes are not evaluated any more.

## Minor changes

* Package documentation modified according to the introduced changes. 


# geckor 0.2.0

## Major changes

* Significant speed-up (at least 3x) of the `coin_history()` and `coin_history_range()` functions.
* All of the `coin_history_*` functions have been re-written so that they can retrieve data for multiple coins (up to 30) in one call.
* The internal `api_request()` function has been modified to fail more gracefully when the API calls time out or errors occur.

## Minor changes

* Modified vignettes to reflect major changes in the package.
* Modified vignettes to avoid hard failures during their build (caused by going over the API rate limit).
* Minor improvements and edits in the package documentation.


# geckor 0.1.1

## Minor changes

* Minor improvements and edits in the package documentation.
* Added `cran-comments.md` and made other preparations for CRAN release.


# geckor 0.1.0 - initial release
