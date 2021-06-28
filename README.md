
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geckor <img src='man/figures/logo.png' align="right" height="180" />

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/next-game-solutions/geckor/branch/main/graph/badge.svg)](https://codecov.io/gh/next-game-solutions/geckor?branch=main)
[![R-CMD-check](https://github.com/next-game-solutions/geckor/workflows/R-CMD-check/badge.svg)](https://github.com/next-game-solutions/geckor/actions)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

`geckor` is an R client for the public [CoinGecko
API](https://www.coingecko.com/en/api#explore-api). This package
implements a number of major endpoints offered by that API and allows
one to collect the current and historical market data on over 8000
cryptocurrencies from more than 300 exchanges. Results are typically
returned in a tabular form as [tibbles](https://tibble.tidyverse.org/),
ready for any downstream analyses.

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
#> 1 cardano 1.34   usd         42962987368. 3303979872.                     5.94
#> 2 cardano 1.12   eur         35998042671. 2768355175.                     5.95
#> 3 cardano 0.963  gbp         30915779043. 2377514180.                     5.80
#> 4 tron    0.0662 usd          4728310842. 1165759965.                     6.27
#> 5 tron    0.0554 eur          3961780730.  976772788.                     6.27
#> 6 tron    0.0476 gbp          3402449927.  838870379.                     6.13
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
#> $ last_updated_at                          <dttm> 2021-06-28 15:50:37, 2021-06-~
#> $ current_price                            <dbl> 1.340000, 15.360000, 0.066154
#> $ market_cap                               <dbl> 42962987368, 15316581566, 472~
#> $ market_cap_rank                          <int> 5, 9, 25
#> $ fully_diluted_valuation                  <dbl> 60291613470, NA, NA
#> $ total_volume                             <dbl> 3303979872, 699189813, 116575~
#> $ high_24h                                 <dbl> 1.360000, 15.400000, 0.066355
#> $ low_24h                                  <dbl> 1.24000, 14.09000, 0.06089
#> $ price_change_24h                         <dbl> 0.0750870, 1.0200000, 0.00390~
#> $ price_change_percentage_24h              <dbl> 5.94423, 7.07553, 6.27000
#> $ market_cap_change_24h                    <dbl> 2464952826, 906856328, 28614~
#> $ market_cap_change_percentage_24h         <dbl> 6.08660, 6.29336, 6.44146
#> $ circulating_supply                       <dbl> 32066390668, 1005453433, 7166~
#> $ total_supply                             <dbl> 45000000000, 1086400068, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -45.87946, -69.35936, -71.847~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 6774.3778, 460.5596, 3514.7608
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> 0.9880269, 1.7367217, 1.33679~
#> $ price_change_percentage_24h_in_currency  <dbl> 5.944231, 7.075532, 6.269996
#> $ price_change_percentage_7d_in_currency   <dbl> -6.719263, -25.949165, -2.745~
#> $ price_change_percentage_14d_in_currency  <dbl> -14.587077, -30.455260, -7.42~
#> $ price_change_percentage_30d_in_currency  <dbl> -11.687684, -28.431119, -8.61~
#> $ price_change_percentage_200d_in_currency <dbl> 802.7161, 215.8596, 130.0594
#> $ price_change_percentage_1y_in_currency   <dbl> 1627.808, NA, 328.065

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
API](https://www.coingecko.com/api/documentations/v3), has a limit of 50
calls per minute. Please keep this limit in mind when developing your
applications using the `geckor` package.

## Getting help

If you encounter a clear bug, please file an issue with a minimal
reproducible example on
[GitHub](https://github.com/next-game-solutions/geckor/issues).

## Licensing

This package is licensed to you under the terms of the MIT License.

The gecko silhouette image used in the package’s hexagon logo has been
downloaded from
[Clipartkey.com](https://www.clipartkey.com/view/hmTimm_geckos-png-transparent-gecko-icon-transparent/)
and is believed to be in the public domain. The logo has been created
using the [hexmake app](https://connect.thinkr.fr/hexmake/).

Copyright (c) 2021 [Next Game Solutions
OÜ](http://nextgamesolutions.com)

------------------------------------------------------------------------

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct/).
By participating in this project you agree to abide by its terms.
