# Release summary

This is a new version of the package - v0.2.0.


## R CMD check results

errors 0 | warnings 0 | notes 1


## Test environments

* Local Windows 10 Pro, R 4.2.2
* GitHub Actions (https://github.com/next-game-solutions/geckor/actions):
  * Ubuntu 20.04, R-devel and R-release
  * Mac OS latest, R-release
  * Windows latest, R-release
* CRAN Win Builder: https://win-builder.r-project.org/ECSTaB98UOwa/
* R-hub:
  * Platform:	Windows Server 2022, R-devel, 64 bit: https://builder.r-hub.io/status/geckor_0.2.0.tar.gz-de917681cbe34093906972be0ab43e38
  * Ubuntu Linux 20.04.1 LTS, R-release, GCC: https://builder.r-hub.io/status/geckor_0.3.0.tar.gz-ae763ab957e648f6b24274c70b322d0f
  * Fedora Linux, R-devel, clang, gfortran: https://builder.r-hub.io/status/geckor_0.3.0.tar.gz-bf07528876c642f0b80f6bb50ca2f4e3
  
## Notes

There is one note, observed in all test environments. That note mentions `no visible binding` for a number of variables. This is a false positive though, which is related to how the respective variables are referred to in `dplyr` commands.

In previous versions of `geckor`, those variables were referred to using the `.data$<variable name>` tidyselect syntax. However, use of `.data` has recently been deprecated in tidyselect expressions, leading to the warning messages that I started receiving when developing the new version of `geckor`. Here is an example of such a message: 

```
Use of .data in tidyselect expressions was deprecated in tidyselect 1.2.0.
i Please use `"price_change_percentage_1h_in_currency"` instead of `.data$price_change_percentage_1h_in_currency`
```

I followed the above advice and removed `.data$` in relevant places of the codebase. This change lead to the note under discussion. This note is a false positive because it is not affecting the functioning of this package in any way, as evidenced by all tests passing without any errors or warnings.


## Reverse dependencies

There are currently no reverse dependencies for this package.


## Changes made to mitigate error in re-building vignettes

On 20 March 2023, I was notified by Prof. Brian D. Ripley regarding the failure of a recent CRAN check run, which was related to going over the rate limit of an external API that this package is based on and that is used in all examples. The rate limit of that API has been recently severely reduced by its provider. To cater for that reduction, which is out of my control, I disabled all examples in the package documentation using the `@examplesIf FALSE` statement in `roxygen` documentation. Similarly, all examples were disabled in vignettes using the `eval = FALSE` option in R code chunks.
