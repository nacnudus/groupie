
<!-- README.md is generated from README.Rmd. Please edit that file -->

# groupie

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#retired)
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

## Caveat

This package is almost certainly overkill. You can easily implement the
functions yourself.

The trick is to treat sets of grouping variables as ‘data’, map over
them to create copies of your actual data grouped by each set of
variables, and then map again with a `summarise()` function or whatever.

``` r
library(dplyr)
library(purrr)

grouping_vars <- c("vs", "am", "carb")
map(grouping_vars, group_by_at, .tbl = mtcars) %>%
  map(summarise,
      '6 cylinder' = sum(cyl == 6),
      'Large disp' = sum(disp >= 100),
      'low gears' = sum(gear <= 4))
#> [[1]]
#> # A tibble: 2 x 4
#>      vs `6 cylinder` `Large disp` `low gears`
#>   <dbl>        <int>        <int>       <int>
#> 1     0            3           18          14
#> 2     1            4            9          13
#> 
#> [[2]]
#> # A tibble: 2 x 4
#>      am `6 cylinder` `Large disp` `low gears`
#>   <dbl>        <int>        <int>       <int>
#> 1     0            4           19          19
#> 2     1            3            8           8
#> 
#> [[3]]
#> # A tibble: 6 x 4
#>    carb `6 cylinder` `Large disp` `low gears`
#>   <dbl>        <int>        <int>       <int>
#> 1     1            2            4           7
#> 2     2            0            8           8
#> 3     3            0            3           3
#> 4     4            4           10           9
#> 5     6            1            1           0
#> 6     8            0            1           0
```

This package also wraps the
[arrangements](https://cran.r-project.org/package=arrangements) package
to create sets of grouping variables. This again is very simple to do
yourself.

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
library(purrr)
```

Summarise by

  - `cyl`
  - `am`
  - `mpg`

<!-- end list -->

``` r
mtcars %>%
  group_by(cyl, am, gear) %>%
  groups_split(individuals) %>%
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
