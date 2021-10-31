# geckor 0.2.0

## Major changes

* Significant speed-up (at least 3x) of the `coin_history()` and `coin_range()` functions.
* All of the `coin_history_*` functions have been re-written and now they can retrieve data for multiple coins (up to 30) in one call.
* The internal `api_request()` function has been modified to fail more gracefully when the API calls time out or errors occur.

## Minor changes

* Modified vignettes to reflect major changes in the package.
* Modified vignettes to avoid hard failures during their build (caused by going over the API rate limit).
* Minor improvements and edits in the package documentation.


# geckor 0.1.1

## Minor changes

* Minor improvements and edits in the package documentation.
* Added `cran-comments.md` and made other preparations for CRAN release.


# geckor 0.1.0 - initial release
