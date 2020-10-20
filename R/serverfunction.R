
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
#' Selects a particular variable in a data frame after filtering observations to match a particular value.
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

