
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geckor

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/next-game-solutions/geckor/branch/main/graph/badge.svg)](https://codecov.io/gh/next-game-solutions/geckor?branch=main)
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
#> 1 cardano 1.25   usd         40075115727. 3259233757.                     1.80
#> 2 cardano 1.05   eur         33576775411. 2730735966.                     1.80
#> 3 cardano 0.902  gbp         28875683811. 2348405032.                     1.85
#> 4 tron    0.0619 usd          4431159600. 1221125644.                     3.08
#> 5 tron    0.0519 eur          3712629346. 1023115236.                     3.09
#> 6 tron    0.0446 gbp          3192823307.  879868650.                     3.13
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
#> $ last_updated_at                          <dttm> 2021-06-27 10:54:23, 2021-06-~
#> $ current_price                            <dbl> 1.250000, 14.390000, 0.061919
#> $ market_cap                               <dbl> 40075115727, 14444065430, 443~
#> $ market_cap_rank                          <int> 5, 9, 23
#> $ fully_diluted_valuation                  <dbl> 56238952066, NA, NA
#> $ total_volume                             <dbl> 3259233757, 673879461, 122112~
#> $ high_24h                                 <dbl> 1.310000, 14.900000, 0.063764
#> $ low_24h                                  <dbl> 1.220000, 13.820000, 0.060069
#> $ price_change_24h                         <dbl> 0.02210491, 0.29046200, 0.001~
#> $ price_change_percentage_24h              <dbl> 1.79791, 2.06005, 3.07943
#> $ market_cap_change_24h                    <int> 644657573, 268673145, 125908~
#> $ market_cap_change_percentage_24h         <dbl> 1.63492, 1.89535, 2.92453
#> $ circulating_supply                       <dbl> 32066390668, 1005140770, 7166~
#> $ total_supply                             <dbl> 45000000000, 1086089903, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -48.74185, -70.86124, -73.300~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 6410.7978, 433.0831, 3328.1335
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> -0.2923862, -0.4038939, 0.458~
#> $ price_change_percentage_24h_in_currency  <dbl> 1.797906, 2.060046, 3.079429
#> $ price_change_percentage_7d_in_currency   <dbl> -9.972566, -29.398366, -9.907~
#> $ price_change_percentage_14d_in_currency  <dbl> -15.602276, -30.972852, -9.32~
#> $ price_change_percentage_30d_in_currency  <dbl> -24.17027, -40.02569, -22.110~
#> $ price_change_percentage_200d_in_currency <dbl> 785.4649, 203.6281, 122.1695
#> $ price_change_percentage_1y_in_currency   <dbl> 1452.2023, NA, 290.6478

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
