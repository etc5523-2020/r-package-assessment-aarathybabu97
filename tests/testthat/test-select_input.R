test_that("selectinput_check()", {
  expect_error(sinput(id=NULL))
  expect_error(printer(id=NULL))
  expect_error(sinput(choice=NULL))
})
