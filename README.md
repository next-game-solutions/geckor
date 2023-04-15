
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geckor <a href="https://next-game-solutions.github.io/geckor/"><img src="man/figures/logo.png" align="right" height="170" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/next-game-solutions/geckor/workflows/R-CMD-check/badge.svg)](https://github.com/next-game-solutions/geckor/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/geckor)](https://cran.r-project.org/package=geckor)
[![Codecov test
coverage](https://codecov.io/gh/next-game-solutions/geckor/branch/main/graph/badge.svg)](https://codecov.io/gh/next-game-solutions/geckor?branch=main)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)

<!-- badges: end -->

`geckor` is an R client for the *free* version of the [CoinGecko
API](https://www.coingecko.com/en/api#explore-api). This package
implements several endpoints offered by that API, allowing users to
collect the current and historical market data on thousands of
cryptocurrencies from hundreds of exchanges. Results are returned in a
tabular form (as [tibbles](https://tibble.tidyverse.org/)), ready for
any downstream analyses.

## Installation

As of v0.3.0, `geckor` is no longer published on CRAN.

To install the package from GitHub, use the following command(s):

``` r
# install.packages("devtools")
devtools::install_github("next-game-solutions/geckor")
```

## Examples

Detailed examples of how to use `geckor` can be found in its [online
documentation](https://next-game-solutions.github.io/geckor/). Provided
below are just a few common queries:

``` r
library(geckor)
#> R client for the CoinGecko API
#> Developed by Next Game Solutions (http://nextgamesolutions.com)

# check if the CoinGecko service is available (this command can be
# particularly useful to check if the API rate limit has been exceeded):
ping()
#> [1] TRUE
```

``` r
library(dplyr)
library(ggplot2)

# Get the current price of Cardano, Tron, and Polkadot,
# expressed in USD, EUR, and GBP:
current_price(
  coin_ids = c("cardano", "tron", "polkadot"),
  vs_currencies = c("usd", "eur", "gbp")
)
#> # A tibble: 9 × 7
#>   coin_id   price vs_currency   market_cap   vol_24h price…¹ last_updated_at    
#>   <chr>     <dbl> <chr>              <dbl>     <dbl>   <dbl> <dttm>             
#> 1 cardano  0.451  usd         15837697908.    5.56e8   3.39  2023-04-15 21:07:54
#> 2 cardano  0.407  eur         14264982830.    5.01e8   2.56  2023-04-15 21:07:54
#> 3 cardano  0.363  gbp         12748697470.    4.48e8   3.40  2023-04-15 21:07:54
#> 4 polkadot 6.77   usd          8267452378.    1.96e8   0.466 2023-04-15 21:07:59
#> 5 polkadot 6.09   eur          7446477822.    1.76e8  -0.341 2023-04-15 21:07:59
#> 6 polkadot 5.45   gbp          6654960199.    1.58e8   0.475 2023-04-15 21:07:59
#> 7 tron     0.0661 usd          6004155496.    2.71e8  -0.473 2023-04-15 21:07:55
#> 8 tron     0.0595 eur          5407930847.    2.44e8  -1.36  2023-04-15 21:07:55
#> 9 tron     0.0532 gbp          4833099004.    2.18e8  -0.473 2023-04-15 21:07:55
#> # … with abbreviated variable name ¹​price_percent_change_24h

# Get a more comprehensive view of the current Cardano, Tron, and
# Polkadot markets:
current_market(
  coin_ids = c("cardano", "tron", "polkadot"),
  vs_currency = "usd"
) %>%
  glimpse()
#> Rows: 3
#> Columns: 32
#> $ coin_id                                  <chr> "cardano", "polkadot", "tron"
#> $ symbol                                   <chr> "ada", "dot", "trx"
#> $ name                                     <chr> "Cardano", "Polkadot", "TRON"
#> $ vs_currency                              <chr> "usd", "usd", "usd"
#> $ last_updated_at                          <dttm> 2023-04-15 21:07:54, 2023-04-…
#> $ current_price                            <dbl> 0.451337, 6.770000, 0.066087
#> $ market_cap                               <dbl> 15837697908, 8267452378, 6004…
#> $ market_cap_rank                          <int> 7, 12, 17
#> $ fully_diluted_valuation                  <dbl> 20336595299, 8815092886, 6004…
#> $ total_volume                             <int> 555995806, 195933965, 2711042…
#> $ high_24h                                 <dbl> 0.461386, 6.860000, 0.066406
#> $ low_24h                                  <dbl> 0.433541, 6.650000, 0.065706
#> $ price_change_24h                         <dbl> 0.0148089400, 0.0314165600, …
#> $ price_change_percentage_24h              <dbl> 3.39244, 0.46648, -0.47265
#> $ market_cap_change_24h                    <dbl> 538138558, 42175955, -26009412
#> $ market_cap_change_percentage_24h         <dbl> 3.51735, 0.51276, -0.43132
#> $ circulating_supply                       <dbl> 35045020830, 1222024275, 9081…
#> $ total_supply                             <dbl> 45000000000, 1302971823, 9081…
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 3.090000, 54.980000, 0.231673
#> $ ath_change_percentage                    <dbl> -85.35035, -87.69465, -71.429…
#> $ ath_date                                 <dttm> 2021-09-02 06:00:10, 2021-11-…
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001…
#> $ atl_change_percentage                    <dbl> 2248.8684, 150.8139, 3568.3223
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-…
#> $ price_change_percentage_1h_in_currency   <dbl> 0.1800281, -0.3640175, -0.185…
#> $ price_change_percentage_24h_in_currency  <dbl> 3.3924391, 0.4664765, -0.4726…
#> $ price_change_percentage_7d_in_currency   <dbl> 17.4481845, 9.3653120, -0.163…
#> $ price_change_percentage_14d_in_currency  <dbl> 12.9854039, 6.6405967, 0.6041…
#> $ price_change_percentage_30d_in_currency  <dbl> 38.6393053, 14.8147770, 0.665…
#> $ price_change_percentage_200d_in_currency <dbl> 1.022590, 3.502597, 11.015018
#> $ price_change_percentage_1y_in_currency   <dbl> -51.643189, -62.314239, 9.762…

# Collect all historical data on the price of Cardano (expressed in EUR),
# and plot the result:
cardano_history <- coin_history(
  coin_id = "cardano",
  vs_currency = "eur",
  days = "max"
)

cardano_history %>%
  ggplot(aes(timestamp, price)) +
  geom_line() +
  theme_minimal()
```

<img src="man/figures/README-example-1.png" width="100%" style="display: block; margin: auto;" />

``` r

# Here we are querying the history of two coins simultaneously:
# "cardano" and "polkadot":
two_coins <- coin_history(
  coin_id = c("cardano", "polkadot"),
  vs_currency = "usd",
  days = 3
)
two_coins$coin_id %>% unique()
#> [1] "cardano"  "polkadot"
```

> NOTE: As of v0.2.0, all `coin_history_*()` functions could retrieve
> data for up 30 coins in one call. However, this number had to be
> scaled down to 5 in the current version, v0.3.0, due to the
> significantly lower API rate limit imposed by CoinGecko.

## API rate limit

When this package was first released back in 2021, the free version of
the [CoinGecko API](https://www.coingecko.com/api/documentations/v3)
offered a rate limit of ca. 50 calls/minute. Unfortunately, since then
CoinGecko has reduced that rate dramatically in a push to commercialise
their product. As of March 2023, a realistic rate limit was around 10-15
calls/minute, making it rather hard to use the free API (and, therefore,
`geckor`) for any serious workloads. Please keep this in mind when
developing your applications using the `geckor` package.

## Getting help

If you encounter a clear bug, please file an issue with a minimal
reproducible example on
[GitHub](https://github.com/next-game-solutions/geckor/issues).

## Licensing

This package is licensed to you under the terms of the MIT License.

The gecko silhouette image used in the hexagon logo of this package has
been downloaded from
[Clipartkey.com](https://www.clipartkey.com/view/hmTimm_geckos-png-transparent-gecko-icon-transparent/)
and is believed to be in the public domain. The logo has been created
using the [hexmake app](https://connect.thinkr.fr/hexmake/).

Copyright © 2023 [Next Game Solutions OÜ](http://nextgamesolutions.com)

------------------------------------------------------------------------

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct/).
By participating in this project you agree to abide by its terms.
