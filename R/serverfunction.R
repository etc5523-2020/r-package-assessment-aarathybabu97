
#' Print Strings
#'
#'
#' Prints strings as texts.
#' 
#' @param text The string required to be printed
#' 
#'
#' @export
printext <- function(text){
  
  paste(text)
}



#' Selects variable after filtering observations
#'
#' Selects a particular variable in a data frame after filtering observations to match a particular value.The function is relative to the shiny app enclosed in the package, therefore it is not advisable for the package user to interact with it.
#' 
#' @param frame The chosen data frame.
#' @param filterval The value filtered in the ID observation of the data frame.
#' @param variable The data frame variable to be selected.
#' 
#' 
#' @return A tibble with the chosen variable with filtered values.
#'
#' @export
choosevar <- function(frame,filterval,variable){ 
    frame %>%
    dplyr::filter(id %in% filterval) %>%
    ungroup() %>%
    dplyr::select(variable)
}

