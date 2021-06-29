
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
current_price(coin_ids = c("cardano", "tron", "plokadot"),
              vs_currencies = c("usd", "eur", "gbp"))
#> # A tibble: 6 x 7
#>   coin_id  price vs_currency   market_cap     vol_24h price_percent_change_24h
#>   <chr>    <dbl> <chr>              <dbl>       <dbl>                    <dbl>
#> 1 cardano 1.41   usd         44952839241. 3437763496.                     7.13
#> 2 cardano 1.18   eur         37817789738. 2892482639.                     7.38
#> 3 cardano 1.02   gbp         32518704096. 2486565277.                     7.69
#> 4 tron    0.0694 usd          4966706018. 1336877419.                     7.54
#> 5 tron    0.0584 eur          4178375539. 1124828607.                     7.80
#> 6 tron    0.0502 gbp          3592895266.  966975469.                     8.11
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
#> $ last_updated_at                          <dttm> 2021-06-29 12:45:24, 2021-06-~
#> $ current_price                            <dbl> 1.410000, 16.680000, 0.069439
#> $ market_cap                               <dbl> 44952839241, 16725825246, 496~
#> $ market_cap_rank                          <int> 5, 9, 23
#> $ fully_diluted_valuation                  <dbl> 63084049177, NA, NA
#> $ total_volume                             <dbl> 3437763496, 910873192, 133687~
#> $ high_24h                                 <dbl> 1.400000, 16.630000, 0.069309
#> $ low_24h                                  <dbl> 1.310000, 14.860000, 0.064551
#> $ price_change_24h                         <dbl> 0.09350700, 1.81000000, 0.004~
#> $ price_change_percentage_24h              <dbl> 7.12874, 12.15055, 7.54462
#> $ market_cap_change_24h                    <dbl> 2836331351, 1737462921, 3387~
#> $ market_cap_change_percentage_24h         <dbl> 6.73449, 11.59208, 7.31923
#> $ circulating_supply                       <dbl> 32066390668, 1005652893, 7166~
#> $ total_supply                             <dbl> 45000000000, 1086602026, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -42.67513, -66.29639, -70.083~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 7181.3909, 516.5954, 3741.2409
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> 0.9209138, 0.9541387, 0.68761~
#> $ price_change_percentage_24h_in_currency  <dbl> 7.128737, 12.150554, 7.544617
#> $ price_change_percentage_7d_in_currency   <dbl> 18.768047, 5.680616, 28.044625
#> $ price_change_percentage_14d_in_currency  <dbl> -10.748443, -35.692881, -3.84~
#> $ price_change_percentage_30d_in_currency  <dbl> -0.7403595, -16.2674841, -0.1~
#> $ price_change_percentage_200d_in_currency <dbl> 888.3135, 247.5076, 146.6428
#> $ price_change_percentage_1y_in_currency   <dbl> 1649.4958, NA, 340.5103

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
