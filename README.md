
# uscovid
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



``` r
#launching the app
library(uscovid)
launch_app()

```
 
The function _selectin()_ displays the COVID-19 cases around the world and the testing rates in US states depending on the parameter selected.

```r
# Displays the COVID-19 cases around the world 
selectin("world",monthlist)

# Display the testing rates in US states depending on the parameter selected
selectin("usa",statelist)

```

### Other functions 


``` r
# creates a drop down menu from which values passed by user can be selected
sinput("monthname","select a month",monthlist)

# prints text
printext("text to be printed")

# returns a tibble with code of Afghanistan
choosevar(codes,Afghanistan,Code)

```

### Available datasets

``` r
# data on the cumulative COVID-19 positive cases for the US states
uscovid::positive_cases

# Data on the names of countries and its two digit state code
uscovid::codes

# monthly test data on the COVID-19 pandemic for the US states
uscovid::months_tests

```

## If issues arise during installation 

If any issues arise during installation of the package regarding the tidycovid19 and its dependent wbstats package, it is advisable to try installing these locally first as wbstats package is temporarily taken off from CRAN. 

``` r
remotes::install_github("joachim-gassen/tidycovid19")
remotes::install_github('nset-ornl/wbstats')

```
