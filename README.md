
<!-- README.md is generated from README.Rmd. Please edit that file -->

# groupie

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/groupie)](https://cran.r-project.org/package=groupie)
[![Travis build
status](https://travis-ci.org/nacnudus/groupie.svg?branch=master)](https://travis-ci.org/nacnudus/groupie)
[![Codecov test
coverage](https://codecov.io/gh/nacnudus/groupie/branch/master/graph/badge.svg)](https://codecov.io/gh/nacnudus/groupie?branch=master)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/nacnudus/groupie?branch=master&svg=true)](https://ci.appveyor.com/project/nacnudus/groupie)
<!-- badges: end -->

The groupie package provides `groups_split()` to create copies of a data
frame with different combinations of grouping variables. This is useful
for summarising data several ways in one go.

## Installation

You can install the development version of groupie from github with

``` r
# install.packages("remotes") # if not already installed
remotes::install_github("nacnudus/groupie")
```

## Example

``` r
library(groupie)

library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(purrr)
```

Summarise by

  - `cyl`
  - `cyl` and `am`
  - `cyl`, `am` and `mpg`

<!-- end list -->

``` r
mtcars %>%
  group_by(cyl, am, gear) %>%
  groups_split(hierarchy) %>%
  map(summarise, mpg = mean(mpg))
#> [[1]]
#> # A tibble: 3 x 2
#>     cyl   mpg
#>   <dbl> <dbl>
#> 1     4  26.7
#> 2     6  19.7
#> 3     8  15.1
#> 
#> [[2]]
#> # A tibble: 6 x 3
#> # Groups:   cyl [3]
#>     cyl    am   mpg
#>   <dbl> <dbl> <dbl>
#> 1     4     0  22.9
#> 2     4     1  28.1
#> 3     6     0  19.1
#> 4     6     1  20.6
#> 5     8     0  15.0
#> 6     8     1  15.4
#> 
#> [[3]]
#> # A tibble: 10 x 4
#> # Groups:   cyl, am [6]
#>      cyl    am  gear   mpg
#>    <dbl> <dbl> <dbl> <dbl>
#>  1     4     0     3  21.5
#>  2     4     0     4  23.6
#>  3     4     1     4  28.0
#>  4     4     1     5  28.2
#>  5     6     0     3  19.8
#>  6     6     0     4  18.5
#>  7     6     1     4  21  
#>  8     6     1     5  19.7
#>  9     8     0     3  15.0
#> 10     8     1     5  15.4
```

Summarise by each one of `cyl`, `am` and `mpg`.

``` r
mtcars %>%
  group_by(cyl, am, gear) %>%
  groups_split(k_combinations, 1L) %>%
  map(summarise, mpg = mean(mpg))
#> [[1]]
#> # A tibble: 3 x 2
#>     cyl   mpg
#>   <dbl> <dbl>
#> 1     4  26.7
#> 2     6  19.7
#> 3     8  15.1
#> 
#> [[2]]
#> # A tibble: 2 x 2
#>      am   mpg
#>   <dbl> <dbl>
#> 1     0  17.1
#> 2     1  24.4
#> 
#> [[3]]
#> # A tibble: 3 x 2
#>    gear   mpg
#>   <dbl> <dbl>
#> 1     3  16.1
#> 2     4  24.5
#> 3     5  21.4
```

Summarise by all pairs of `cyl`, `am` and `mpg`.

``` r
mtcars %>%
  group_by(cyl, am, gear) %>%
  groups_split(k_combinations, 2L) %>%
  map(summarise, mpg = mean(mpg))
#> [[1]]
#> # A tibble: 6 x 3
#> # Groups:   cyl [3]
#>     cyl    am   mpg
#>   <dbl> <dbl> <dbl>
#> 1     4     0  22.9
#> 2     4     1  28.1
#> 3     6     0  19.1
#> 4     6     1  20.6
#> 5     8     0  15.0
#> 6     8     1  15.4
#> 
#> [[2]]
#> # A tibble: 8 x 3
#> # Groups:   cyl [3]
#>     cyl  gear   mpg
#>   <dbl> <dbl> <dbl>
#> 1     4     3  21.5
#> 2     4     4  26.9
#> 3     4     5  28.2
#> 4     6     3  19.8
#> 5     6     4  19.8
#> 6     6     5  19.7
#> 7     8     3  15.0
#> 8     8     5  15.4
#> 
#> [[3]]
#> # A tibble: 4 x 3
#> # Groups:   am [2]
#>      am  gear   mpg
#>   <dbl> <dbl> <dbl>
#> 1     0     3  16.1
#> 2     0     4  21.0
#> 3     1     4  26.3
#> 4     1     5  21.4
```

## Contribute

Please note that the ‘groupie’ project is released with a [Contributor
Code of Conduct](.github/CODE_OF_CONDUCT.md). By contributing to this
project, you agree to abide by its terms.
