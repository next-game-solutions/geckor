
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geckor <img src='man/figures/logo.png' align="right" height="169" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/next-game-solutions/geckor/workflows/R-CMD-check/badge.svg)](https://github.com/next-game-solutions/geckor/actions)
[![Codecov test
coverage](https://codecov.io/gh/next-game-solutions/geckor/branch/main/graph/badge.svg)](https://codecov.io/gh/next-game-solutions/geckor?branch=main)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/geckor)](https://cran.r-project.org/package=geckor)
<!-- badges: end -->

`geckor` is an R client for the public [CoinGecko
API](https://www.coingecko.com/en/api#explore-api). This package
implements several endpoints offered by that API, allowing users to
collect the current and historical market data on over 8000
cryptocurrencies from more than 300 exchanges. Results are returned in a
tabular form (as [tibbles](https://tibble.tidyverse.org/)), ready for
any downstream analyses.

## Installation

A stable version of this package can be installed from
[CRAN](https://cran.r-project.org/web/packages/geckor/index.html) the
usual way:

``` r
install.packages("geckor")
```

To install the development version from GitHub, use the following
command(s):

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

# check if the CoinGecko service is available:
ping()
#> [1] TRUE
```

``` r
library(dplyr)
library(ggplot2)

# Get the current price of Cardano, Tron, and Polkadot,
# expressed in USD, EUR, and GBP:
current_price(coin_ids = c("cardano", "tron", "polkadot"),
              vs_currencies = c("usd", "eur", "gbp"))
#> # A tibble: 9 x 7
#>   coin_id    price vs_currency   market_cap     vol_24h price_percent_change_24h
#>   <chr>      <dbl> <chr>              <dbl>       <dbl>                    <dbl>
#> 1 cardano   1.18   usd         37635678400. 1092824669.                    -3.26
#> 2 cardano   0.996  eur         31880054102.  925698993.                    -3.17
#> 3 cardano   0.854  gbp         27341567644.  793915266.                    -3.13
#> 4 polkadot 12.2    usd         12314379101.  591569021.                    -3.57
#> 5 polkadot 10.3    eur         10431141105.  501100371.                    -3.48
#> 6 polkadot  8.86   gbp          8946150130.  429763062.                    -3.44
#> 7 tron      0.0560 usd          4007555018.  870734186.                    -1.96
#> 8 tron      0.0475 eur          3394679629.  737572807.                    -1.87
#> 9 tron      0.0407 gbp          2911408569.  632570971.                    -1.83
#> # ... with 1 more variable: last_updated_at <dttm>

# Get a more comprehensive view of the current Cardano, Tron, and 
# Polkadot markets:
current_market(coin_ids = c("cardano", "tron", "polkadot"), 
               vs_currency = "usd") %>% 
  glimpse()
#> Rows: 3
#> Columns: 32
#> $ coin_id                                  <chr> "cardano", "polkadot", "tron"
#> $ symbol                                   <chr> "ada", "dot", "trx"
#> $ name                                     <chr> "Cardano", "Polkadot", "TRON"
#> $ vs_currency                              <chr> "usd", "usd", "usd"
#> $ last_updated_at                          <dttm> 2021-07-17 17:43:25, 2021-07-~
#> $ current_price                            <dbl> 1.180000, 12.200000, 0.056033
#> $ market_cap                               <dbl> 37635678400, 12314379101, 400~
#> $ market_cap_rank                          <int> 5, 9, 26
#> $ fully_diluted_valuation                  <dbl> 52815595790, NA, NA
#> $ total_volume                             <int> 1092824669, 591577455, 870734~
#> $ high_24h                                 <dbl> 1.220000, 12.680000, 0.057314
#> $ low_24h                                  <dbl> 1.150000, 11.770000, 0.054903
#> $ price_change_24h                         <dbl> -0.039593880, -0.451047843, -~
#> $ price_change_percentage_24h              <dbl> -3.25704, -3.56545, -1.95793
#> $ market_cap_change_24h                    <dbl> -1467819552, -535624640, -10~
#> $ market_cap_change_percentage_24h         <dbl> -3.75368, -4.16828, -2.48458
#> $ circulating_supply                       <dbl> 32066390668, 1010802686, 7166~
#> $ total_supply                             <dbl> 45000000000, 1091751819, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -51.97112, -75.27869, -75.844~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 6000.6166, 352.2675, 3001.4932
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> -0.29097701, -0.11889073, -0.~
#> $ price_change_percentage_24h_in_currency  <dbl> -3.257042, -3.565451, -1.9579~
#> $ price_change_percentage_7d_in_currency   <dbl> -13.29284, -22.45779, -10.463~
#> $ price_change_percentage_14d_in_currency  <dbl> -15.70123, -20.48468, -15.915~
#> $ price_change_percentage_30d_in_currency  <dbl> -20.51713, -46.57452, -18.465~
#> $ price_change_percentage_200d_in_currency <dbl> 561.82551, 84.58807, 89.45035
#> $ price_change_percentage_1y_in_currency   <dbl> 833.5575, NA, 226.7288

# Collect all historical data on the price of Cardano (expressed in EUR),
# and plot the result:
cardano_history <- coin_history(coin_id = "cardano", 
                                vs_currency = "eur", 
                                days = "max")

cardano_history %>% 
  ggplot(aes(timestamp, price)) +
  geom_line() + theme_minimal()
```

<img src="man/figures/README-example-1.png" width="100%" style="display: block; margin: auto;" />

## API rate limit

The public [CoinGecko
API](https://www.coingecko.com/api/documentations/v3) offers a rate
limit of 50 calls per minute. Please keep this limit in mind when
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

Copyright © 2021 [Next Game Solutions OÜ](http://nextgamesolutions.com)

------------------------------------------------------------------------

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct/).
By participating in this project you agree to abide by its terms.
