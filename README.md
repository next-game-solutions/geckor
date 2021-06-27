
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
one to collect the current and historical market data on over 8000
cryptocurrencies from more than 300 exchanges. Results are typically
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
#> 1 cardano 1.27   usd         40596536977. 3302980962.                    0.869
#> 2 cardano 1.06   eur         34013646120. 2767389387.                    0.875
#> 3 cardano 0.914  gbp         29251388157. 2379926600.                    0.916
#> 4 tron    0.0625 usd          4470794105. 1151300232.                    0.881
#> 5 tron    0.0524 eur          3745836957.  964612294.                    0.887
#> 6 tron    0.0450 gbp          3221381513.  829556718.                    0.928
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
#> $ last_updated_at                          <dttm> 2021-06-27 12:34:37, 2021-06-~
#> $ current_price                            <dbl> 1.270000, 14.490000, 0.062487
#> $ market_cap                               <dbl> 40596536977, 14560978113, 447~
#> $ market_cap_rank                          <int> 5, 9, 24
#> $ fully_diluted_valuation                  <dbl> 56970682571, NA, NA
#> $ total_volume                             <dbl> 3302980962, 668989702, 115130~
#> $ high_24h                                 <dbl> 1.310000, 14.900000, 0.063764
#> $ low_24h                                  <dbl> 1.220000, 13.820000, 0.060592
#> $ price_change_24h                         <dbl> 0.01092106, -0.04060287, 0.00~
#> $ price_change_percentage_24h              <dbl> 0.86872, -0.27940, 0.88113
#> $ market_cap_change_24h                    <int> 344463275, 30822234, 37955182
#> $ market_cap_change_percentage_24h         <dbl> 0.85577, 0.21213, 0.85623
#> $ circulating_supply                       <dbl> 32066390668, 1005141640, 716~
#> $ total_supply                             <dbl> 45000000000, 1086090772, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -48.27778, -70.71820, -73.165~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 6469.744, 435.700, 3345.467
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> -0.1110681, -0.8749760, 0.266~
#> $ price_change_percentage_24h_in_currency  <dbl> 0.8687166, -0.2794001, 0.8811~
#> $ price_change_percentage_7d_in_currency   <dbl> -8.786840, -28.901347, -9.080~
#> $ price_change_percentage_14d_in_currency  <dbl> -14.490698, -30.486918, -8.48~
#> $ price_change_percentage_30d_in_currency  <dbl> -23.17154, -39.60348, -21.394~
#> $ price_change_percentage_200d_in_currency <dbl> 797.1271, 205.7655, 124.2103
#> $ price_change_percentage_1y_in_currency   <dbl> 1472.6459, NA, 294.2361

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
