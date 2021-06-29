
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geckor <img src='man/figures/logo.png' align="right" height="169" />

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/next-game-solutions/geckor/branch/main/graph/badge.svg)](https://codecov.io/gh/next-game-solutions/geckor?branch=main)
[![R-CMD-check](https://github.com/next-game-solutions/geckor/workflows/R-CMD-check/badge.svg)](https://github.com/next-game-solutions/geckor/actions)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

`geckor` is an R client for the public [CoinGecko
API](https://www.coingecko.com/en/api#explore-api). This package
implements several endpoints offered by that API, allowing users to
collect the current and historical market data on over 8000
cryptocurrencies from more than 300 exchanges. Results are returned in a
tabular form (as [tibbles](https://tibble.tidyverse.org/)), ready for
any downstream analyses.

## Installation

At the moment, `geckor` is only available on GitHub and can be installed
with:

``` r
# install.packages("devtools")
devtools::install_github("next-game-solutions/geckor")

library(geckor)
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
current_price(coin_ids = c("cardano", "tron", "plokadot"),
              vs_currencies = c("usd", "eur", "gbp"))
#> # A tibble: 6 x 7
#>   coin_id  price vs_currency   market_cap     vol_24h price_percent_change_24h
#>   <chr>    <dbl> <chr>              <dbl>       <dbl>                    <dbl>
#> 1 cardano 1.34   usd         42603376273. 3404352588.                     5.74
#> 2 cardano 1.12   eur         35726850515. 2854862845.                     5.83
#> 3 cardano 0.962  gbp         30698416617. 2453050514.                     5.75
#> 4 tron    0.0660 usd          4713849525. 1143880379.                     7.05
#> 5 tron    0.0553 eur          3952996501.  959248935.                     7.15
#> 6 tron    0.0475 gbp          3396625555.  824237878.                     7.06
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
#> $ last_updated_at                          <dttm> 2021-06-28 19:35:22, 2021-06-~
#> $ current_price                            <dbl> 1.340000, 15.480000, 0.065951
#> $ market_cap                               <dbl> 42603376273, 15425308159, 471~
#> $ market_cap_rank                          <int> 5, 9, 24
#> $ fully_diluted_valuation                  <dbl> 59786957381, NA, NA
#> $ total_volume                             <dbl> 3404352588, 743269807, 114388~
#> $ high_24h                                 <dbl> 1.360000, 15.910000, 0.067296
#> $ low_24h                                  <dbl> 1.250000, 14.190000, 0.061434
#> $ price_change_24h                         <dbl> 0.07251500, 1.27000000, 0.004~
#> $ price_change_percentage_24h              <dbl> 5.74358, 8.91461, 7.05259
#> $ market_cap_change_24h                    <int> 2018775387, 1120761134, 3018~
#> $ market_cap_change_percentage_24h         <dbl> 4.97424, 7.83500, 6.84101
#> $ circulating_supply                       <dbl> 32066390668, 1005617291, 7166~
#> $ total_supply                             <dbl> 45000000000, 1086567782, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -45.68448, -68.90076, -71.588~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 6799.1444, 468.9495, 3547.9437
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> 0.9058240, 1.2867787, 0.74332~
#> $ price_change_percentage_24h_in_currency  <dbl> 5.743583, 8.914610, 7.052595
#> $ price_change_percentage_7d_in_currency   <dbl> -6.943390, -25.377910, -3.043~
#> $ price_change_percentage_14d_in_currency  <dbl> -14.792300, -29.918767, -7.71~
#> $ price_change_percentage_30d_in_currency  <dbl> -11.89987, -27.87901, -8.89946
#> $ price_change_percentage_200d_in_currency <dbl> 800.5472, 218.2963, 129.3543
#> $ price_change_percentage_1y_in_currency   <dbl> 1623.6568, NA, 326.7531

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

Copyright (c) 2021 [Next Game Solutions
OÜ](http://nextgamesolutions.com)

------------------------------------------------------------------------

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct/).
By participating in this project you agree to abide by its terms.
