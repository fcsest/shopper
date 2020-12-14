
<!-- README.md is generated from README.Rmd. Please edit that file -->

# 🛍 shopper <a href='https:/shopper.github.io'><img src='man/figures/icon.png' align="right" height="135" /></a>

<!-- badges: start -->

[![R build
status](https://github.com/r-lib/vroom/workflows/R-CMD-check/badge.svg)](https://github.com/r-lib/vroom)
[![Codecov test
coverage](https://codecov.io/gh/r-lib/vroom/branch/master/graph/badge.svg)](https://codecov.io/gh/r-lib/vroom?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/vroom)](https://cran.r-project.org/package=vroom)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![R build
status](https://github.com/r-lib/vroom/workflows/R-CMD-check/badge.svg)](https://github.com/r-lib/vroom/actions)
<!-- badges: end -->

The fastest delimited reader for R.

<img src="https://media.giphy.com/media/KxtMLfh8k8GEJHpBVi/giphy.gif" align="right" padding-left = "10 px" width = "30%"/>

But that’s impossible! How can it be so fast?

vroom doesn’t stop to actually read all of your data, it simply indexes
where each record is located so it can be read later. The vectors
returned use the Altrep framework to lazily load the data on-demand when
it is accessed, so you only pay for what you use. This lazy access is
done automatically, so no changes to your R data-manipulation code are
needed.

vroom also uses multiple threads for indexing, materializing
non-character columns, and when writing to further improve performance.

## Installation

You can install the released version of shopper from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("shopper")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("fcsest/shopper")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
# library(shopper)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist                    
#>  Min.   : 4.0   Min.   :  2.000000000000000  
#>  1st Qu.:12.0   1st Qu.: 26.000000000000000  
#>  Median :15.0   Median : 36.000000000000000  
#>  Mean   :15.4   Mean   : 42.979999999999997  
#>  3rd Qu.:19.0   3rd Qu.: 56.000000000000000  
#>  Max.   :25.0   Max.   :120.000000000000000
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub!
