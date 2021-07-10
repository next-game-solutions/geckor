
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geckor <img src='man/figures/logo.png' align="right" height="169" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/next-game-solutions/geckor/workflows/R-CMD-check/badge.svg)](https://github.com/next-game-solutions/geckor/actions)
[![Codecov test
coverage](https://codecov.io/gh/next-game-solutions/geckor/branch/main/graph/badge.svg)](https://codecov.io/gh/next-game-solutions/geckor?branch=main)
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
current_price(coin_ids = c("cardano", "tron", "polkadot"),
              vs_currencies = c("usd", "eur", "gbp"))
#> # A tibble: 9 x 7
#>   coin_id    price vs_currency   market_cap     vol_24h price_percent_change_24h
#>   <chr>      <dbl> <chr>              <dbl>       <dbl>                    <dbl>
#> 1 cardano   1.36   usd         43448664437. 1048797558.                 -0.574  
#> 2 cardano   1.14   eur         36582211304.  883049787.                 -0.642  
#> 3 cardano   0.975  gbp         31252407086.  754394839.                 -0.948  
#> 4 polkadot 15.7    usd         15514260550.  497608662.                  0.0597 
#> 5 polkadot 13.2    eur         13062448870.  418968580.                 -0.00896
#> 6 polkadot 11.3    gbp         11159330043.  357927423.                 -0.316  
#> 7 tron      0.0625 usd          4480180713.  761390993.                 -0.118  
#> 8 tron      0.0527 eur          3772150874.  641063806.                 -0.186  
#> 9 tron      0.0450 gbp          3222571586.  547664734.                 -0.493  
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
#> $ last_updated_at                          <dttm> 2021-07-10 16:41:35, 2021-07-~
#> $ current_price                            <dbl> 1.360000, 15.680000, 0.062533
#> $ market_cap                               <dbl> 43448664437, 15514260550, 448~
#> $ market_cap_rank                          <int> 5, 9, 25
#> $ fully_diluted_valuation                  <dbl> 60973182791, NA, NA
#> $ total_volume                             <int> 1048797558, 497608662, 761390~
#> $ high_24h                                 <dbl> 1.37000, 15.98000, 0.06317
#> $ low_24h                                  <dbl> 1.320000, 15.260000, 0.061552
#> $ price_change_24h                         <dbl> -7.825742e-03, 9.353460e-03, ~
#> $ price_change_percentage_24h              <dbl> -0.57416, 0.05968, -0.11791
#> $ market_cap_change_24h                    <dbl> -259094375, -312087162, -410~
#> $ market_cap_change_percentage_24h         <dbl> -0.59279, -1.97195, -0.09157
#> $ circulating_supply                       <dbl> 32066390668, 1009109392, 7166~
#> $ total_supply                             <dbl> 45000000000, 1090075223, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -45.35639, -68.81476, -73.234~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 6840.8178, 470.5228, 3336.5610
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> 1.4468335, 2.0290116, 0.90558~
#> $ price_change_percentage_24h_in_currency  <dbl> -0.57416326, 0.05968179, -0.1~
#> $ price_change_percentage_7d_in_currency   <dbl> -2.862573, 2.211478, -6.161329
#> $ price_change_percentage_14d_in_currency  <dbl> 6.1267332, 6.3331038, 0.24371~
#> $ price_change_percentage_30d_in_currency  <dbl> -16.44703, -32.39698, -17.209~
#> $ price_change_percentage_200d_in_currency <dbl> 781.7385, 220.5128, 112.4202
#> $ price_change_percentage_1y_in_currency   <dbl> 993.3799, NA, 238.5788

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
