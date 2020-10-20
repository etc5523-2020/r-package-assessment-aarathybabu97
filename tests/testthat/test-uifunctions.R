

x <- as.tibble(c(1:3))
y <- as.tibble(c(1:5))

shinyApp(
  ui = fluidPage(fluidRow(
    sinput("testname", "name label", x$value),
    
    selectInput("testname", "name label", x$value)
  )),
  
  server = function(input, output, session) {
    
  }
)



test_that("ui_check()", {
  expect_equal(
    sinput("testname", "name label", x$value),
    selectInput("testname", "name label", x$value)
  )
  #expect_equal(sinput("testname","name label",x$value),selectInput("testname","name label",y$value))
  
})
