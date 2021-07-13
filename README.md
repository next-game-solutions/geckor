
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
#> 1 cardano   1.27   usd         40566153610. 1050831768.                   -3.15 
#> 2 cardano   1.08   eur         34439690827.  892261254.                   -2.45 
#> 3 cardano   0.917  gbp         29365960297.  760749658.                   -2.63 
#> 4 polkadot 14.2    usd         14305263792.  394711644.                   -3.59 
#> 5 polkadot 12.0    eur         12144825633.  335149657.                   -2.90 
#> 6 polkadot 10.3    gbp         10355623375.  285751495.                   -3.08 
#> 7 tron      0.0596 usd          4268429142.  744148318.                   -1.02 
#> 8 tron      0.0506 eur          3623793899.  631856337.                   -0.309
#> 9 tron      0.0432 gbp          3089928661.  538726175.                   -0.492
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
#> $ last_updated_at                          <dttm> 2021-07-13 21:44:54, 2021-07-~
#> $ current_price                            <dbl> 1.27000, 14.19000, 0.05962
#> $ market_cap                               <dbl> 40566153610, 14305263792, 426~
#> $ market_cap_rank                          <int> 5, 9, 26
#> $ fully_diluted_valuation                  <dbl> 56928044422, NA, NA
#> $ total_volume                             <int> 1050831768, 394711644, 744148~
#> $ high_24h                                 <dbl> 1.320000, 15.090000, 0.060995
#> $ low_24h                                  <dbl> 1.250000, 14.080000, 0.059096
#> $ price_change_24h                         <dbl> -0.0411919069, -0.5285809229,~
#> $ price_change_percentage_24h              <dbl> -3.15068, -3.59132, -1.02108
#> $ market_cap_change_24h                    <dbl> -1335284910, -505165459, -35~
#> $ market_cap_change_percentage_24h         <dbl> -3.18673, -3.41088, -0.83531
#> $ circulating_supply                       <dbl> 32066390668, 1009861354, 7166~
#> $ total_supply                             <dbl> 45000000000, 1090810486, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -48.27021, -71.29259, -74.265~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 6470.7051, 425.1917, 3204.2278
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> 0.4737232, 0.7816781, 0.59454~
#> $ price_change_percentage_24h_in_currency  <dbl> -3.150684, -3.591319, -1.0210~
#> $ price_change_percentage_7d_in_currency   <dbl> -10.508334, -7.370925, -8.131~
#> $ price_change_percentage_14d_in_currency  <dbl> -4.929234, -10.054411, -8.932~
#> $ price_change_percentage_30d_in_currency  <dbl> -14.61656, -31.93480, -12.688~
#> $ price_change_percentage_200d_in_currency <dbl> 728.2967, 176.3093, 115.3589
#> $ price_change_percentage_1y_in_currency   <dbl> 897.9664, NA, 228.2605

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
