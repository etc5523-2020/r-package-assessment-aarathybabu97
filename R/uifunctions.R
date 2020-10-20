#' User controlled drop down menu 
#'
#'
#' Calls selectInput() function from shiny r package where necessary which in turn creates a drop down menu from which values can be selected. 
#' The function is relative to the shiny app enclosed in the package, therefore it is not advisable for the package user to interact with it.
#' 
#' @param id The input id that can be used to contain the value selected.
#' @param label The label displayed over the menu. Use NULL for no label.
#' @param choice The list of values to be selected from.
#' 
#'
#'  
#'@return Returns a drop down menu compatible with shiny r package.
#'
#'@export
sinput <- function(id,label,choice){
  
  selectInput(id,label, choice)
  
  
}

