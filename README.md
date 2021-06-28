
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geckor

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/next-game-solutions/geckor/branch/main/graph/badge.svg)](https://codecov.io/gh/next-game-solutions/geckor?branch=main)
[![R-CMD-check](https://github.com/next-game-solutions/geckor/workflows/R-CMD-check/badge.svg)](https://github.com/next-game-solutions/geckor/actions)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

`geckor` is an R client for the public [CoinGecko
API](https://www.coingecko.com/en/api#explore-api). This package
implements a number of major endpoints offered by that API and allows
one to collect the current and historical market data on over 8000
cryptocurrencies from more than 300 exchanges. Results are typically
returned in a tabular form as [tibbles](https://tibble.tidyverse.org/),
ready for any downstream analyses.

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
#> 1 cardano 1.32   usd         42393668447. 3207079276.                     4.64
#> 2 cardano 1.11   eur         35540308006. 2686467683.                     4.62
#> 3 cardano 0.951  gbp         30500972637. 2306281263.                     4.43
#> 4 tron    0.0652 usd          4674171048. 1148268802.                     4.52
#> 5 tron    0.0547 eur          3918544556.  962639667.                     4.58
#> 6 tron    0.0469 gbp          3362925844.  826144955.                     4.36
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
#> $ last_updated_at                          <dttm> 2021-06-28 14:51:13, 2021-06-~
#> $ current_price                            <dbl> 1.320000, 15.100000, 0.065227
#> $ market_cap                               <dbl> 42393668447, 15176046975, 467~
#> $ market_cap_rank                          <int> 5, 9, 25
#> $ fully_diluted_valuation                  <dbl> 59492666319, NA, NA
#> $ total_volume                             <dbl> 3207079276, 641322934, 114826~
#> $ high_24h                                 <dbl> 1.360000, 15.400000, 0.066355
#> $ low_24h                                  <dbl> 1.24000, 14.09000, 0.06089
#> $ price_change_24h                         <dbl> 0.05861200, 0.75707100, 0.002~
#> $ price_change_percentage_24h              <dbl> 4.63962, 5.27673, 4.51861
#> $ market_cap_change_24h                    <int> 1719139926, 738230401, 19449~
#> $ market_cap_change_percentage_24h         <dbl> 4.22658, 5.11317, 4.34182
#> $ circulating_supply                       <dbl> 32066390668, 1005450935, 7166~
#> $ total_supply                             <dbl> 45000000000, 1086400068, 1008~
#> $ max_supply                               <dbl> 4.5e+10, NA, NA
#> $ ath                                      <dbl> 2.450000, 49.350000, 0.231673
#> $ ath_change_percentage                    <dbl> -45.88214, -69.41315, -71.858~
#> $ ath_date                                 <dttm> 2021-05-16 07:44:28, 2021-05-~
#> $ atl                                      <dbl> 0.01925275, 2.70000000, 0.001~
#> $ atl_change_percentage                    <dbl> 6774.0374, 459.5754, 3513.3241
#> $ atl_date                                 <dttm> 2020-03-13 02:22:55, 2020-08-~
#> $ price_change_percentage_1h_in_currency   <dbl> 0.701320, 1.598119, 1.047024
#> $ price_change_percentage_24h_in_currency  <dbl> 4.639624, 5.276730, 4.518614
#> $ price_change_percentage_7d_in_currency   <dbl> -7.859923, -27.189564, -4.107~
#> $ price_change_percentage_14d_in_currency  <dbl> -15.63153, -31.62018, -8.72399
#> $ price_change_percentage_30d_in_currency  <dbl> -12.767589, -29.629944, -9.89~
#> $ price_change_percentage_200d_in_currency <dbl> 791.6775, 210.5688, 126.8368
#> $ price_change_percentage_1y_in_currency   <dbl> 1606.6802, NA, 322.0687

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
API](https://www.coingecko.com/api/documentations/v3), has a limit of 50
calls per minute. Please keep this limit in mind when developing your
applications using the `geckor` package.

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
