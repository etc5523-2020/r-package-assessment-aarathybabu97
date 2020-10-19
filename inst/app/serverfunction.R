printext <- function(text){
  
  paste(text)
}

choosedat <- function(a,num,dat_para){ 
    a %>%
    dplyr::filter(id %in% num) %>%
    ungroup() %>%
    dplyr::select(dat_para)
}
