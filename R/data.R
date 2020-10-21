#' Data on the COVID-19 pandemic for the US and individual states.
#' 
#' The dataset contains monthly test data on the COVID-19 pandemic for the US on individual state level .
#'
#' @format A data frame with 402  rows and 6 variables:
#' \describe{
#'    \item{month}{Month}
#'  
#'    \item{monthnum}{Month of the year}
#'    \item{state_name}{Name of the state in US.}
#'    \item{tests}{Number of tests conducted}
#'    \item{test_positive}{Number of tests that came positive.}
#'    \item{test_negative}{Number of tests that came negative.}
#'   
#' 
#' 
#' 
#' 
#' 
#' 
#' }  
#' @source \url{https://covidtracking.com/data/download}
"months_tests"

#' Data on the names of countries and its two digit state code
#'
#' @format A data frame with 249  rows and 2 variables:
#' \describe{
#'   \item{Name}{Name of the country}
#'   \item{Code}{Alpha 2 country code}
#'  
#' }
#' 
"codes"

#' Data on the cumulative COVID-19 positive cases for the US and individual states.
#' 
#' The dataset contains data on the cumulative COVID-19 positive cases for the US on individual state level .
#'
#' @format A data frame with 50 rows and 2 variables:
#' \describe{
#'   
#'    \item{state_name}{Name of the state in US.}
#'    \item{positive_cases}{Number of COVID-19 positive cases.}

#'   
#' 
#' 
#' 
#' 
#' 
#' 
#' }  
#' @source \url{https://covidtracking.com/data/download}
"positive_cases"



