

printext <- function(text){
  
  paste(text)
}


test_that("server_check()", {
  expect_match(printext("0"), "0")
  #expect_match(printext("0"), "2")
})



choosedat <- function(a,num,dat_para){ 
  a %>%
    dplyr::filter(id %in% num) %>%
    ungroup() %>%
    dplyr::select(dat_para)
}

example <- tibble(
  id = 1:5, 
  y = 1, 
  z = id^2
)
choosedat(example,2,"z")

test_that("choosedat_check()", {
  
  expect_equal(choosedat(example,2,"z"), tibble(z=4))
  #expect_equal(choosedat(example,2,"z"), tibble(z=6))
  
})








