# Release summary

This is a new version of the package - v0.2.0.


## R CMD check results

errors 0 | warnings 0 | notes 0


## Test environments

* Local Windows 10 Pro, R 4.1.0
* Via the Github Actions:
  * Ubuntu 20.04, R-devel and R-release;
  * Mac OS latest, R-release;
  * Windows latest, R-release.
  
See latest results at: https://github.com/next-game-solutions/geckor/actions


## Reverse dependencies

There are currently no reverse dependencies for this package.


## Changes made to mitigate error in re-building vignettes

On 29 October 2021, I was notified by Prof. Brian D. Ripley regarding the failure of a recent CRAN check run due to the `Error(s) in re-building vignettes`. A closer examination on my end revealed that this was due to the rate limit imposed by the external API used in the package. In this new version of the package, the issue has been rectified by modifying the underlying code in a way that ensures more graceful failures.
