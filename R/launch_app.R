
#' COVID-19 in United States 
#'
#'
#' Launches a shiny web application showcasing an overview of COVID-19 on a global scale and explores the test results as well as different dimensions of the effect of the pandemic in the United States of America.
#' 
#'
#' @export
launch_app <- function() {
  appDir <- system.file("app","app.R", package = "uscovid")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `uscovid`.", call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}

"launch_app"
