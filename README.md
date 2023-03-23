
<!-- README.md is generated from README.xcvRmd. Please edit that file -->

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

`geckor` is an R client for the *free* version of the [CoinGecko
API](https://www.coingecko.com/en/api#explore-api). This package
implements several endpoints offered by that API, allowing users to
collect the current and historical market data on thousands of
cryptocurrencies from hundreds of exchanges. Results are returned in a
tabular form (as [tibbles](https://tibble.tidyverse.org/)), ready for
any downstream analyses.

## Installation

A stable version of the package can be installed from
[CRAN](https://CRAN.R-project.org/package=geckor) the usual way:

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

# check if the CoinGecko service is available (this command can be
# particularly useful to check if the API rate limit has been exceeded):
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
#> # A tibble: 9 × 7
#>   coin_id   price vs_currency   market_cap   vol_24h price…¹ last_updated_at    
#>   <chr>     <dbl> <chr>              <dbl>     <dbl>   <dbl> <dttm>             
#> 1 cardano  0.372  usd         13028922854.    4.25e8    3.21 2023-03-23 21:41:42
#> 2 cardano  0.343  eur         12027532873.    3.92e8    3.46 2023-03-23 21:41:42
#> 3 cardano  0.303  gbp         10605569261.    3.46e8    3.05 2023-03-23 21:41:42
#> 4 polkadot 6.28   usd          7628067560.    1.87e8    3.37 2023-03-23 21:41:55
#> 5 polkadot 5.8    eur          7041781915.    1.72e8    3.62 2023-03-23 21:41:55
#> 6 polkadot 5.11   gbp          6209262250.    1.52e8    3.21 2023-03-23 21:41:55
#> 7 tron     0.0663 usd          6039369545.    7.31e8   10.0  2023-03-23 21:41:39
#> 8 tron     0.0612 eur          5575189641.    6.75e8   10.3  2023-03-23 21:41:39
#> 9 tron     0.0539 gbp          4916058889.    5.95e8    9.85 2023-03-23 21:41:39
#> # … with abbreviated variable name ¹​price_percent_change_24h

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
#> $ last_updated_at                          <dttm> 2023-03-23 21:41:42, 2023-03-…
#> $ current_price                            <dbl> 0.371904, 6.280000, 0.066278
#> $ market_cap                               <dbl> 13028922854, 7628067560, 6039…
#> $ market_cap_rank                          <int> 7, 13, 16
#> $ fully_diluted_valuation                  <dbl> 16729952346, 8136302371, 6039…
#> $ total_volume                             <int> 424810272, 186571380, 7306878…
#> $ high_24h                                 <dbl> 0.387702, 6.430000, 0.066840
#> $ low_24h                                  <dbl> 0.357681, 6.040000, 0.059550
#> $ price_change_24h                         <dbl> 0.01157535, 0.20492900, 0.00…
#> $ price_change_percentage_24h              <dbl> 3.21245, 3.37299, 10.01566
#> $ market_cap_change_24h                    <int> 339334455, 239944930, 5255401…
#> $ market_cap_change_percentage_24h         <dbl> 2.67412, 3.24771, 9.53131
#> $ circulating_supply                       <dbl> 35045020830, 1214960962, 9113…
#> $ total_supply                             <dbl> 45000000000, 1295910095, 9113…
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 3.090000, 54.980000, 0.231673
#> $ ath_change_percentage                    <dbl> -87.95001, -88.60833, -71.379…
#> $ ath_date                                 <dttm> 2021-09-02 06:00:10, 2021-11-…
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001…
#> $ atl_change_percentage                    <dbl> 1832.0491, 132.1908, 3574.8213
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-…
#> $ price_change_percentage_1h_in_currency   <dbl> -0.20009262, -0.03360551, 0.9…
#> $ price_change_percentage_24h_in_currency  <dbl> 3.212445, 3.372992, 10.015660
#> $ price_change_percentage_7d_in_currency   <dbl> 14.2394740, 6.5719707, 0.9562…
#> $ price_change_percentage_14d_in_currency  <dbl> 16.808885, 12.067896, 1.409739
#> $ price_change_percentage_30d_in_currency  <dbl> -7.735007, -16.562608, -7.765…
#> $ price_change_percentage_200d_in_currency <dbl> -22.567116, -13.691255, 4.981…
#> $ price_change_percentage_1y_in_currency   <dbl> -61.885330, -69.161429, 4.456…

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

# Here we are querying the history of two coins simultaneously: "cardano"
# and "polkadot":
two_coins <- coin_history(coin_id = c("cardano", "polkadot"), 
                          vs_currency = "usd", 
                          days = 3)
two_coins$coin_id %>% unique()
#> [1] "cardano"  "polkadot"
```

> NOTE: As of v0.2.0, all `coin_history_*()` functions could retrieve
> data for up 30 coins in one call. However, this number had to be
> scaled down to 5 in v0.3.0 due to the significantly lower API rate
> limit imposed by CoinGecko.

## API rate limit

When this package was first released back in 2021, the free version of
the [CoinGecko API](https://www.coingecko.com/api/documentations/v3)
offered a rate limit of ca. 50 calls/minute. Unfortunately, since then
CoinGecko has reduced that rate dramatically in a push to commercialise
their product. As of March 2023, a realistic rate limit was around 10-15
calls/minute, making it rather hard to use the free API (and, therefore,
`geckor`) for any serious workloads. Please keep this in mind when
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

Copyright © 2023 [Next Game Solutions OÜ](http://nextgamesolutions.com)

------------------------------------------------------------------------

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct/).
By participating in this project you agree to abide by its terms.
