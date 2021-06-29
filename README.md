
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
#> 1 cardano   1.4    usd         44605116586. 3419036716.                     6.06
#> 2 cardano   1.17   eur         37537703494. 2877105721.                     6.43
#> 3 cardano   1.01   gbp         32271489614. 2472192621.                     6.68
#> 4 polkadot 16.5    usd         16580630959.  879207932.                    10.7 
#> 5 polkadot 13.9    eur         13955519143.  739849958.                    11.1 
#> 6 polkadot 12.0    gbp         11993201469.  635726242.                    11.3 
#> 7 tron      0.0690 usd          4934773661. 1341662975.                     6.34
#> 8 tron      0.0581 eur          4152888383. 1129004027.                     6.71
#> 9 tron      0.0499 gbp          3570274200.  970112222.                     6.96
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
#> $ last_updated_at                          <dttm> 2021-06-29 13:18:12, 2021-06-~
#> $ current_price                            <dbl> 1.40000, 16.52000, 0.06902
#> $ market_cap                               <dbl> 44605116586, 16580630959, 493~
#> $ market_cap_rank                          <int> 5, 9, 25
#> $ fully_diluted_valuation                  <dbl> 62596076595, NA, NA
#> $ total_volume                             <dbl> 3419036716, 879207932, 134166~
#> $ high_24h                                 <dbl> 1.410000, 16.650000, 0.069439
#> $ low_24h                                  <dbl> 1.310000, 14.860000, 0.064551
#> $ price_change_24h                         <dbl> 0.0797480, 1.5900000, 0.00411~
#> $ price_change_percentage_24h              <dbl> 6.06287, 10.67601, 6.33968
#> $ market_cap_change_24h                    <dbl> 2325404612, 1556544571, 2810~
#> $ market_cap_change_percentage_24h         <dbl> 5.50005, 10.36033, 6.03955
#> $ circulating_supply                       <dbl> 32066390668, 1005654884, 7166~
#> $ total_supply                             <dbl> 45000000000, 1086602026, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -42.78741, -66.48518, -70.178~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 7167.1294, 513.1417, 3729.0062
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> 0.4082493, 0.1070918, 0.12309~
#> $ price_change_percentage_24h_in_currency  <dbl> 6.062872, 10.676007, 6.339683
#> $ price_change_percentage_7d_in_currency   <dbl> 17.913246, 4.683768, 27.272511
#> $ price_change_percentage_14d_in_currency  <dbl> -11.390807, -36.299467, -4.42~
#> $ price_change_percentage_30d_in_currency  <dbl> -1.4547539, -17.0573031, -0.7~
#> $ price_change_percentage_200d_in_currency <dbl> 881.2004, 244.2297, 145.1555
#> $ price_change_percentage_1y_in_currency   <dbl> 1636.904, NA, 337.854

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
