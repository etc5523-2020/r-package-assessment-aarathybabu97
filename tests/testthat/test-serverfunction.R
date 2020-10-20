


test_that("server_check()", {
  expect_match(printext("0"), "0")
  #expect_match(printext("0"), "2")
})




example <- tibble(
  id = 1:5, 
  y = 1, 
  z = id^2
)


test_that("choosevar_check()", {
  
  expect_equal(choosevar(example,2,"z"), tibble(z=4))
  #expect_equal(choosevat(example,2,"z"), tibble(z=6))
  
})








