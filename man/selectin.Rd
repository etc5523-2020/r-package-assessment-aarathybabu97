% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/select_input.R
\name{selectin}
\alias{selectin}
\title{Display of COVID-19 cases around the world and the testing rates in USA}
\usage{
selectin(id, choice)
}
\arguments{
\item{id}{The name of the figures to be displayed in string format. For example, "world" or "usa"}

\item{choice}{The required list of possible choices of months (monthlist) and states in US (statelist), the user could select from to display either the table depicting figures on COVID cases worldwide or the testing rates in a state of US.}
}
\value{
The function deploys a shiny app which the user can interact with
}
\description{
Displays the COVID-19 cases around the world and the testing rates in US states depending on the parameter selected.
}
\details{
The parameters required for the function to display the global COVID-19 cases for each month is "world" along with monthlist where as parameters "usa" along with statelist displays the testing rates over the months in each state of US.
}
