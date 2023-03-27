# Release summary

This is a new version of the package - v0.2.0.


## R CMD check results

errors 0 | warnings 0 | notes 0


## Test environments

* Local Windows 10 Pro, R 4.2.2
* Github Actions (https://github.com/next-game-solutions/geckor/actions):
  * Ubuntu 20.04, R-devel and R-release
  * Mac OS latest, R-release
  * Windows latest, R-release
* R-hub:
  * Fedora Linux, R-devel: https://builder.r-hub.io/status/geckor_0.2.0.tar.gz-677c2716af6a4df9a113029842359f92
  * Ubuntu Linux 20.04.1 LTS, R-release: https://builder.r-hub.io/status/geckor_0.2.0.tar.gz-dccad8119baf4800ad30fa2cbf532817
  * Windows Server 2008 R2 SP1, R-devel: https://builder.r-hub.io/status/geckor_0.2.0.tar.gz-de917681cbe34093906972be0ab43e38


## Reverse dependencies

There are currently no reverse dependencies for this package.


## Changes made to mitigate error in re-building vignettes

On 29 October 2021, I was notified by Prof. Brian D. Ripley regarding the failure of a recent CRAN check run due to the `Error(s) in re-building vignettes`. A closer examination on my end revealed that this was due to the rate limit imposed by the external API used in the package. In this new version of the package (this submission), the issue has been rectified by modifying the underlying code and tests in a way that ensures more graceful failures (if and when they occur).
