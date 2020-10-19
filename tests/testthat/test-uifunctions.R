test_that("ui_check()", {
  expect_error(sinput(id=NULL))
  expect_error(sinput(label=NULL))
  expect_error(sinput(choice=NULL))
})
