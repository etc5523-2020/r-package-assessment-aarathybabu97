#' Data on the COVID-19 pandemic for the US and individual states.
#' 
#' The dataset contains data on the COVID-19 pandemic for the US and individual states.
#'
#' @format A data frame with 12,082  rows and 43 variables:
#' \describe{
#'   \item{positive}{Total number of confirmed plus probable cases of COVID-19 reported by the state or territory}
#'   \item{positiveIncrease}{Cases (confirmed plus probable) calculated based on the previous day value.}
#'   \item{probableCases}{Total number of probable cases of COVID-19 as reported by the state or territory}
#'   \item{positiveCasesViral}{Total number of unique people with a positive PCR or other approved nucleic acid amplification test (NAAT)}
#'   \item{negative}{Total number of unique people with a completed PCR test that returns negative}
#'   \item{negativeTestsViral}{Total number of completed PCR tests (or specimens tested) that return negative as reported by the state or territory. }
#'   \item{pending}{Total number of viral tests that have not been completed as reported by the state or territory.}
#'   \item{positiveTestsViral}{Total number of completed PCR tests (or specimens tested) that return positive as reported by the state or territory.}
#'   \item{totalTestsPeopleViral}{Total number of unique people tested at least once via PCR testing, as reported by the state or territory. }
#'   \item{totalTestsViral}{Total number of PCR tests (or specimens tested) as reported by the state or territory. }
#'   \item{totalTestEncountersViral}{Total number of people tested per day via PCR testing as reported by the state or territory.}
#'   \item{negativeTestsPeopleAntibody}{The total number of unique people with completed antibody tests that return negative as reported by the state or territory.}
#'   \item{negativeTestsAntibody}{The total number of completed antibody tests that return negative as reported by the state or territory.} 
#'   \item{positiveTestsAntibody}{Total number of completed antibody tests that return positive as reported by the state or territory.}
#'   \item{totalTestsPeopleAntibody}{The total number of unique people who have been tested at least once via antibody testing as reported by the state or territory.}
#'   \item{totalTestsAntibody}{Total number of completed antibody tests as reported by the state or territory.}
#'   \item{positiveTestsPeopleAntigen}{Total number of unique people with a completed antigen test that returned positive as reported by the state or territory.}
#'   \item{positiveTestsAntigen}{Total number of completed antigen tests that return positive as reported by the state or territory.}
#'   \item{totalTestsPeopleAntigen}{Total number of unique people who have been tested at least once via antigen testing, as reported by the state or territory.}
#'    \item{totalTestsAntigen}{Total number of completed antigen tests, as reported by the state or territory.}
#'    \item{hospitalizedCumulative}{Total number of individuals who have ever been hospitalized with COVID-19. }
#'    \item{inIcuCumulative}{Total number of individuals who have ever been hospitalized in the Intensive Care Unit with COVID-19.}
#'    \item{onVentilatorCumulative}{Total number of individuals who have ever been hospitalized under advanced ventilation with COVID-19. }
#'    \item{ hospitalizedCurrently}{Individuals who are currently hospitalized with COVID-19. }
#'    \item{inIcuCurrently}{Individuals who are currently hospitalized in the Intensive Care Unit with COVID-19.}
#'    \item{onVentilatorCurrently}{Individuals who are currently hospitalized under advanced ventilation with COVID-19.}
#'    \item{hospitalizedIncrease}{Daily increase in hospitalizedCumulative, calculated from the previous day’s value.}
#'    \item{death}{Total fatalities with confirmed OR probable COVID-19 case diagnosis }
#'    \item{deathConfirmed}{Total fatalities with confirmed COVID-19 case diagnosis}
#'    \item{deathProbable}{Total fatalities with probable COVID-19 case diagnosis }
#'    \item{deathIncrease}{Daily increase in death, calculated from the previous day’s value.}
#'    \item{recovered}{Total number of people that are identified as recovered from COVID-19.}
#'    \item{dataQualityGrade}{The COVID Tracking Project grade of the completeness of the data reporting by a state.}
#'    \item{date}{Date on which data was collected by The COVID Tracking Project.}
#'    \item{totalTestResultsIncrease}{Daily increase in totalTestResults, calculated from the previous days value. }
#'    \item{state}{Two-letter abbreviation for the state or territory.}
#'   
#' 
#' 
#' 
#' 
#' 
#' 
#' }  
#' @source \url{https://covidtracking.com/data/download}
"allstates"

#' Data on the countries of the world and its two digit state code
#'
#' @format A data frame with 249  rows and 2 variables:
#' \describe{
#'   \item{Name}{Name of the country}
#'   \item{Code}{Alpha 2 country code}
#'  
#' }
#' 
"ccode"



