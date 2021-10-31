
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geckor <img src="man/figures/logo.png" align="right" height="169"/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/next-game-solutions/geckor/workflows/R-CMD-check/badge.svg)](https://github.com/next-game-solutions/geckor/actions)
[![Codecov test
coverage](https://codecov.io/gh/next-game-solutions/geckor/branch/main/graph/badge.svg)](https://codecov.io/gh/next-game-solutions/geckor?branch=main)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/grand-total/geckor)](https://cran.r-project.org/package=geckor)

<!-- badges: end -->

`geckor` is an R client for the public [CoinGecko
API](https://www.coingecko.com/en/api#explore-api). This package
implements several endpoints offered by that API, allowing users to
collect the current and historical market data on thousands of
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
#> 1 cardano   1.94   usd         61940989996. 1850534392.                    -2.48
#> 2 cardano   1.68   eur         53609802960. 1601633815.                    -2.42
#> 3 cardano   1.42   gbp         45261953797. 1352235444.                    -2.48
#> 4 polkadot 41.4    usd         43169302615. 1141449953.                    -4.01
#> 5 polkadot 35.9    eur         37362945075.  987922652.                    -3.96
#> 6 polkadot 30.3    gbp         31544974992.  834088300.                    -4.01
#> 7 tron      0.0989 usd          7118584479. 2524930683.                    -2.69
#> 8 tron      0.0856 eur          6161120629. 2185322456.                    -2.64
#> 9 tron      0.0722 gbp          5201741880. 1845035023.                    -2.69
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
#> $ last_updated_at                          <dttm> 2021-10-31 13:47:47, 2021-10-~
#> $ current_price                            <dbl> 1.940000, 41.430000, 0.098853
#> $ market_cap                               <dbl> 61940989996, 43169302615, 711~
#> $ market_cap_rank                          <int> 5, 8, 29
#> $ fully_diluted_valuation                  <dbl> 86924174868, NA, NA
#> $ total_volume                             <dbl> 1850534392, 1141449953, 25249~
#> $ high_24h                                 <dbl> 2.010000, 43.420000, 0.102361
#> $ low_24h                                  <dbl> 1.93000, 41.33000, 0.09815
#> $ price_change_24h                         <dbl> -0.04922088, -1.73286271, -0.~
#> $ price_change_percentage_24h              <dbl> -2.47851, -4.01494, -2.69494
#> $ market_cap_change_24h                    <dbl> -1519718166, -2122275474, -1~
#> $ market_cap_change_percentage_24h         <dbl> -2.39474, -4.68581, -2.05226
#> $ circulating_supply                       <dbl> 32066390668, 1045208242, 7166~
#> $ total_supply                             <dbl> 45000000000, 1126157374, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 3.090000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -37.41761, -16.25055, -57.317~
#> $ ath_date                                 <dttm> 2021-09-02 06:00:10, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 9934.219, 1432.166, 5380.268
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> -0.05802379, -0.41113167, 0.6~
#> $ price_change_percentage_24h_in_currency  <dbl> -2.478513, -4.014941, -2.6949~
#> $ price_change_percentage_7d_in_currency   <dbl> -10.922508, -6.116299, -2.365~
#> $ price_change_percentage_14d_in_currency  <dbl> -11.4549672, -1.2885884, -0.3~
#> $ price_change_percentage_30d_in_currency  <dbl> -8.502541, 44.759685, 10.4517~
#> $ price_change_percentage_200d_in_currency <dbl> 36.151474, -4.152306, -32.810~
#> $ price_change_percentage_1y_in_currency   <dbl> 1978.1985, 912.7174, 286.3815

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

``` r
# As of v0.2.0 (NOT yet on CRAN), all `coin_history_*`
# functions can retrieve data for multiple coins (up to 30) 
# in one call, e.g.:
two_coins <- coin_history(coin_id = c("cardano", "polkadot"), 
                          vs_currency = "usd", 
                          days = 3)
two_coins$coin_id %>% unique()
#> [1] "cardano"  "polkadot"
```

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
