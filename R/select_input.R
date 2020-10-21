#' Display of COVID-19 cases around the world and the testing rates in USA 
#'
#'
#' Displays the COVID-19 cases around the world and the testing rates in US states depending on the parameter selected. 
#' 
#' @details The parameters required for the function to display the global COVID-19 cases for each month is "world" along with monthlist where as parameters "usa" along with statelist displays the testing rates over the months in each state of US.
#' 
#' @param id The name of the figures to be displayed in string format. For example, "world" or "usa"
#' 
#' @param choice The required list of possible choices of months (monthlist) and states in US (statelist), the user could select from to display either the table depicting figures on COVID cases worldwide or the testing rates in a state of US.
#' 
#' @importFrom dplyr filter select mutate %>% rename group_by summarise full_join left_join 
#' 
#' 
#' @return The function deploys a shiny app which the user can interact with
#' 
#' @export
selectin <- function(id,choice) {
  
  
# load("data/allstates.rda")
  #allstates <- readr::read_csv(here::here("data/allstates.csv"))
  #statesabb <- USAboundaries::state_codes
  #ccode <- readr::read_csv(here::here("data/codes.csv"))
#load("data/ccode.rda")
load(file = "data/tests.rda")
load(file = "data/positive.rda")
  df <-tidycovid19::download_merged_data(cached = TRUE, silent = TRUE)
  
 

 
  Encoding(df$country) <- "latin1"

  

  df$country <- textclean::replace_non_ascii(df$country, remove.nonconverted = FALSE)
  

  cols2 <-
    c(
      "#233d4d",
      "#fe7f2d",
      "#fcca46",
      "#a1c181",
      "#083d77",
      "#513b56",
      "#98ce00",
      "#348aa7",
      "#840032",
      "#db3a34"
    )
  
  
 
  
  df <- df %>%
    mutate(month = month(date, label = T),
           year = year(date))
  
  
  allworld <- df %>%
    filter(year == "2020") %>%
    select(
      country,
      date,
      month,
      confirmed,
      recovered,
      deaths,
      region,
      population,
      income,
      pop_density,
      life_expectancy,
      gdp_capita
    ) %>%
    filter(!is.na(confirmed))
  
  
  world <-  allworld %>%
    
    group_by(country, month) %>%
    filter(!is.na(confirmed)) %>%
    summarise(
      Confirmed = max(confirmed),
      Recovered = max(recovered),
      Deaths = max(deaths)
    ) %>%
    arrange(desc(Confirmed))
  
  
  
  a <-  allworld %>%
    group_by(
      country,
      month,
      life_expectancy,
      income,
      region,
      pop_density,
      population,
      gdp_capita
    ) %>%
    filter(!is.na(confirmed)) %>%
    summarise(
      Confirmed = max(confirmed),
      Recovered = max(recovered),
      Deaths = max(deaths)
    ) %>%
    arrange(desc(Confirmed))
  a$id  <- 1:nrow(a)
  

  
  list <- world %>%
    ungroup() %>%
    select(month) %>%
    distinct(month)
  
  
  monthlist <-
    c("Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct")
  statelist <-  as.list(positive_cases$state_name)
  
  
  
  sinput <- function(id,choice) {
    selectInput(inputId=id, label=NULL,choices=choice)
    
    
  }
  
  printer <- function(id) {
    print(id)
  }
  
  
  show <- function(id) {
    return(id)
  }
  showname <- show(id)
  
  
  
  
  shinyApp(
    ui = fluidPage(fluidRow(
      sidebarLayout(
        sidebarPanel(if (showname == "world")
        {
          sinput(id,monthlist)
        }
        
        else
          sinput(id, statelist)),
        mainPanel (
          reactable::reactableOutput("table"),
          plotly::plotlyOutput("facetline"),
          plotOutput("chart")
          
        )
        
        
      )
    )),
    
    
    
    server = function(input, output, session) {
      pr <-  printer(id)
      
      if (pr == "world")
      {
        output$table <- reactable::renderReactable({
          newworld <-   world %>%
            filter(month == input$world) %>%
            select(-month)
          reactable::reactable(
            newworld,
            resizable = TRUE,
            showPageSizeOptions = TRUE,
            #onClick = "select",
            pagination = T,
            #defaultSelected = 1,
            #selection = "single",
            defaultSorted = "Confirmed",
            defaultSortOrder = "desc",
            defaultColDef = reactable::colDef(headerClass = "header", align = "left"),
            columns = list(
              country = reactable::colDef(
                name = "Country",
                width = 150,
                filterable = TRUE
              ) ,
              Confirmed = reactable::colDef(
                name = "Confirmed Cases",
                cell = function(value) {
                  width <- paste0(value * 100 / max(world$Confirmed), "%")
                  value <-
                    format(value, big.mark = ",")
                  value <-
                    format(value, width = 10, justify = "right")
                  bar <- div(
                    class = "bar-chart",
                    style = list(marginRight = "6px"),
                    div(
                      class = "bar",
                      style = list(width = width, backgroundColor = "#3F5661")
                    )
                  )
                  div(class = "bar-cell", span(class = "number", value), bar)
                }
              ),
              Recovered = reactable::colDef(
                name = "No. of Recovered Cases",
                cell = function(value) {
                  width <-
                    paste0(value * 100 / max(world$Recovered), "%")
                  value <-
                    format(value, big.mark = ",")
                  value <-
                    format(value, width = 10, justify = "right")
                  bar <- div(
                    class = "bar-chart",
                    style = list(marginRight = "6px"),
                    div(
                      class = "bar",
                      style = list(width = width, backgroundColor = "#d62828")
                    )
                  )
                  div(class = "bar-cell", span(class = "number", value), bar)
                }
              ),
              Deaths = reactable::colDef(
                name = "No. of Deaths",
                cell = function(value) {
                  width <-
                    paste0(value * 100 / max(world$Deaths), "%")
                  value <-
                    format(value, big.mark = ",")
                  value <-
                    format(value, width = 10, justify = "right")
                  bar <- div(
                    class = "bar-chart",
                    style = list(marginRight = "6px"),
                    div(
                      class = "bar",
                      style = list(width = width, backgroundColor = "#2a9d8f")
                    )
                  )
                  div(class = "bar-cell", span(class = "number", value), bar)
                }
              )
            )
          )
          
          
          
          
          
        })
        
      }
      if (pr == "usa")
      {
        output$facetline <- plotly::renderPlotly({
          options(scipen = 999)
          figure <-
            months_tests %>% filter(state_name == input$usa) %>%
            
            ggplot(aes(x = reorder(month, monthnum), y = tests)) +
            geom_point(color = "steelblue") + xlab("Month") +
            scale_y_log10() +
            ylab("Cumulative Tests (log10)") + ggtitle("Total COVID-19 Tests") +
            theme_minimal() +
            theme(plot.title = element_text(hjust = 0.5))
          
          plotly::ggplotly(figure)
          
          
        })
      }
      
      
      
      
      
      
    }
    
    
    
    
  )
  
}
