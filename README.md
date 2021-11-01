
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
#> 1 cardano   1.97   usd         62961901389. 1940791497.                    0.860
#> 2 cardano   1.7    eur         54371190678. 1674148094.                    0.524
#> 3 cardano   1.44   gbp         46001413279. 1418054833.                    0.851
#> 4 polkadot 48.3    usd         50311554475. 2693545486.                   14.6  
#> 5 polkadot 41.7    eur         43427424476. 2323481965.                   14.2  
#> 6 polkadot 35.3    gbp         36748012192. 1968060558.                   14.6  
#> 7 tron      0.101  usd          7223493095. 1910845542.                    1.06 
#> 8 tron      0.0869 eur          6231064602. 1648316384.                    0.724
#> 9 tron      0.0736 gbp          5277903018. 1396174582.                    1.05 
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
#> $ last_updated_at                          <dttm> 2021-11-01 15:48:08, 2021-11-~
#> $ current_price                            <dbl> 1.970000, 48.310000, 0.100767
#> $ market_cap                               <dbl> 62961901389, 50311554475, 722~
#> $ market_cap_rank                          <int> 5, 8, 30
#> $ fully_diluted_valuation                  <dbl> 88356859112, NA, NA
#> $ total_volume                             <dbl> 1940791497, 2693545486, 19108~
#> $ high_24h                                 <dbl> 2.000000, 48.410000, 0.102011
#> $ low_24h                                  <dbl> 1.920000, 42.030000, 0.098313
#> $ price_change_24h                         <dbl> 0.01677742, 6.17000000, 0.001~
#> $ price_change_percentage_24h              <dbl> 0.86021, 14.62898, 1.06102
#> $ market_cap_change_24h                    <dbl> 610156041, 6522760033, 38887~
#> $ market_cap_change_percentage_24h         <dbl> 0.97857, 14.89596, 0.54125
#> $ circulating_supply                       <dbl> 32066390668, 1046044876, 7166~
#> $ total_supply                             <dbl> 45000000000, 1126994753, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 3.090000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -36.23617, -2.22400, -56.48172
#> $ ath_date                                 <dttm> 2021-09-02 06:00:10, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 10123.646, 1688.777, 5487.633
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> 0.1230227, 1.1920305, 0.23085~
#> $ price_change_percentage_24h_in_currency  <dbl> 0.8602142, 14.6289814, 1.0610~
#> $ price_change_percentage_7d_in_currency   <dbl> -7.582491, 13.610124, 1.104214
#> $ price_change_percentage_14d_in_currency  <dbl> -8.836149, 14.671681, 1.913567
#> $ price_change_percentage_30d_in_currency  <dbl> -12.445201, 51.072102, 6.2964~
#> $ price_change_percentage_200d_in_currency <dbl> 35.09699, 13.67883, -28.68343
#> $ price_change_percentage_1y_in_currency   <dbl> 2018.190, 1056.317, 289.712

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
# As of v0.2.0, all `coin_history_*`
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
