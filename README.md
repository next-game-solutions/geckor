
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
#>   coin_id    price vs_currency   market_cap    vol_24h price_percent_change_24h
#>   <chr>      <dbl> <chr>              <dbl>      <dbl>                    <dbl>
#> 1 cardano   1.34   usd         42989716886. 771105827.                     1.50
#> 2 cardano   1.13   eur         36201855538. 649363639.                     1.52
#> 3 cardano   0.967  gbp         30930886351. 554951755.                     1.56
#> 4 polkadot 15.5    usd         15653516672. 329847459.                     2.67
#> 5 polkadot 13.1    eur         13181904657. 277766194.                     2.68
#> 6 polkadot 11.2    gbp         11265569839. 237385609.                     2.72
#> 7 tron      0.0620 usd          4436415762. 730312375.                     1.81
#> 8 tron      0.0523 eur          3735927895. 615010657.                     1.82
#> 9 tron      0.0447 gbp          3191978959. 525593401.                     1.86
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
#> $ last_updated_at                          <dttm> 2021-07-11 20:16:16, 2021-07-~
#> $ current_price                            <dbl> 1.340000, 15.520000, 0.062049
#> $ market_cap                               <dbl> 42989716886, 15653516672, 443~
#> $ market_cap_rank                          <int> 5, 9, 25
#> $ fully_diluted_valuation                  <dbl> 60329124031, NA, NA
#> $ total_volume                             <int> 771105827, 329847459, 7303123~
#> $ high_24h                                 <dbl> 1.350000, 15.700000, 0.062388
#> $ low_24h                                  <dbl> 1.320000, 15.090000, 0.060897
#> $ price_change_24h                         <dbl> 0.01991248, 0.40289000, 0.001~
#> $ price_change_percentage_24h              <dbl> 1.50433, 2.66593, 1.80548
#> $ market_cap_change_24h                    <int> 212993273, 290070712, 33790531
#> $ market_cap_change_percentage_24h         <dbl> 0.49792, 1.88806, 0.76751
#> $ circulating_supply                       <dbl> 32066390668, 1009377617, 716~
#> $ total_supply                             <dbl> 45000000000, 1090320501, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -45.16077, -68.62412, -73.276~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 6865.6659, 474.0105, 3331.2470
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> 0.06875506, -0.15974418, -0.0~
#> $ price_change_percentage_24h_in_currency  <dbl> 1.504335, 2.665929, 1.805479
#> $ price_change_percentage_7d_in_currency   <dbl> -4.68421811, 0.04893231, -7.2~
#> $ price_change_percentage_14d_in_currency  <dbl> 7.6521848, 7.6021371, -0.8142~
#> $ price_change_percentage_30d_in_currency  <dbl> -12.29674, -31.58984, -14.659~
#> $ price_change_percentage_200d_in_currency <dbl> 755.3527, 201.0754, 114.2272
#> $ price_change_percentage_1y_in_currency   <dbl> 1034.3943, NA, 242.0198

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
