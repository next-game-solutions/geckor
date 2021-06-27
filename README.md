
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geckor

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/next-game-solutions/geckor/branch/main/graph/badge.svg)](https://codecov.io/gh/next-game-solutions/geckor?branch=main)
[![R-CMD-check](https://github.com/next-game-solutions/geckor/workflows/R-CMD-check/badge.svg)](https://github.com/next-game-solutions/geckor/actions)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`geckor` is an R client for the public [CoinGecko
API](https://www.coingecko.com/en/api#explore-api). This package
implements a number of major endpoints offered by that API and allows
one to collect the current and historical market data on over 7000
cryptocurrencies from more than 400 exchanges. Results are typically
returned in a tabular form as tibbles, ready for any downstream
analyses.

## Installation

At the moment, `geckor` is only available on GitHub and can be installed
with:

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
library(dplyr)
library(ggplot2)

# Get the current price of Cardano, Tron, and Polkadot,
# expressed in USD, EUR, and GBP:
current_price(coin_ids = c("cardano", "tron", "plokadot"),
              vs_currencies = c("usd", "eur", "gbp"))
#> # A tibble: 6 x 7
#>   coin_id  price vs_currency   market_cap     vol_24h price_percent_change_24h
#>   <chr>    <dbl> <chr>              <dbl>       <dbl>                    <dbl>
#> 1 cardano 1.25   usd         40017618066. 3484243698.                  -0.550 
#> 2 cardano 1.04   eur         33528601226. 2919259645.                  -0.544 
#> 3 cardano 0.897  gbp         28834254503. 2510533470.                  -0.503 
#> 4 tron    0.0618 usd          4435513075. 1201498053.                  -0.0976
#> 5 tron    0.0518 eur          3716276888. 1006670337.                  -0.0915
#> 6 tron    0.0445 gbp          3195960156.  865726205.                  -0.0509
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
#> $ last_updated_at                          <dttm> 2021-06-27 11:23:04, 2021-06-~
#> $ current_price                            <dbl> 1.250000, 14.360000, 0.061766
#> $ market_cap                               <dbl> 40017618066, 14465484379, 443~
#> $ market_cap_rank                          <int> 5, 9, 23
#> $ fully_diluted_valuation                  <dbl> 56158263385, NA, NA
#> $ total_volume                             <dbl> 3484243698, 663157395, 120149~
#> $ high_24h                                 <dbl> 1.310000, 14.900000, 0.063764
#> $ low_24h                                  <dbl> 1.220000, 13.820000, 0.060592
#> $ price_change_24h                         <dbl> -6.884638e-03, -9.132260e-02,~
#> $ price_change_percentage_24h              <dbl> -0.54979, -0.63182, -0.09762
#> $ market_cap_change_24h                    <dbl> -278036994, -98694038, 16981~
#> $ market_cap_change_percentage_24h         <dbl> -0.68999, -0.67765, 0.38434
#> $ circulating_supply                       <dbl> 32066390668, 1005140770, 7166~
#> $ total_supply                             <dbl> 45000000000, 1086089903, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -48.97066, -70.88924, -73.282~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 6381.7339, 432.5709, 3330.3982
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> -1.7225333, -0.9426484, -0.76~
#> $ price_change_percentage_24h_in_currency  <dbl> -0.54978951, -0.63182108, -0.~
#> $ price_change_percentage_7d_in_currency   <dbl> -10.42133, -29.53431, -10.129~
#> $ price_change_percentage_14d_in_currency  <dbl> -16.022974, -31.105760, -9.54~
#> $ price_change_percentage_30d_in_currency  <dbl> -24.54826, -40.14117, -22.301~
#> $ price_change_percentage_200d_in_currency <dbl> 781.0511, 203.0435, 121.6229
#> $ price_change_percentage_1y_in_currency   <dbl> 1444.4650, NA, 289.6866

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

## Getting help

If you encounter a clear bug, please file an issue with a minimal
reproducible example on
[GitHub](https://github.com/next-game-solutions/geckor/issues).

## License

This package is licensed to you under the terms of the MIT License.

Copyright (c) 2021 [Next Game Solutions
OÜ](http://nextgamesolutions.com)

------------------------------------------------------------------------

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct/).
By participating in this project you agree to abide by its terms.
