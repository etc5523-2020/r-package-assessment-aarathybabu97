
#' server stuff
#'
#'
#' random stuff
#' 
#'
#' @export
printext <- function(text){
  
  paste(text)
}



#' server stuff 2
#'
#'
#' random stuff 2
#' 
#'
#' @export
choosedat <- function(a,num,dat_para){ 
    a %>%
    dplyr::filter(id %in% num) %>%
    ungroup() %>%
    dplyr::select(dat_para)
}

