
# Your Package Name
<!-- badges: start -->
[![R build status](https://github.com/etc5523-2020/r-package-assessment-aarathybabu97/workflows/R-CMD-check/badge.svg)](https://github.com/etc5523-2020/r-package-assessment-aarathybabu97/actions)
<!-- badges: end -->


The goal of _uscovid_ package is to launch the enclosed [shiny web application](https://aarathybabu.shinyapps.io/covid/) on COVID-19 in United States. The web application showcases an overview of the data on COVID-19 on a global scale and also explores the test results as well as different dimensions of the effect of the pandemic in the United States of America. The package makes it possible for a user to launch the app locally which would aid the user in reproducing the web application. 

## Installation

You can install the  _uscovid_ with:

``` r
# install.packages("devtools")
devtools::install_github("etc5523-2020/r-package-assessment-aarathybabu97")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(uscovid)
launch_app()

```

