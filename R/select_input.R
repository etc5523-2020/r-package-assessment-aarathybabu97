#' refactor ui
#'
#'
#' random
#' 
#'
#' @export
selectin <- function(id,label,choice) {
  
  library(tidyverse)
  library(readr)
  library(plotly)
  library(reactable)
  library(shiny)
  library(leaflet)
  library(shinythemes)
  library(USAboundaries)
  library(tidycovid19)
  library(htmltools)
  library(readxl)
  library(geojsonR)
  library(lubridate)
  
  
  #state <- read_csv(here::here("data/overall-state.csv.gz"))
  allstates <- read_csv(here::here("data/allstates.csv"))
  statesabb <- USAboundaries::state_codes
  ccode <- read_csv(here::here("data/codes.csv"))
  Gender <- read_csv(here::here("data/gender.csv"))
  Age <- read_csv(here::here("data/agegroups.csv"))
  Race <- read_csv(here::here("data/race.csv"))
  df <- download_merged_data(cached = TRUE, silent = TRUE)
  
  
  cols2 <- c("#233d4d", "#fe7f2d", "#fcca46","#a1c181","#083d77","#513b56","#98ce00","#348aa7","#840032","#db3a34")
  
  
  Gender <- Gender %>%
    rename(category = Sex)
  Age <- Age %>%
    rename(category = "Age Group")
  Race <-  Race %>%
    rename(category = `Race/Ethnicity`)
  
  
  pop <- read_csv(here::here("data/pop.csv"))
  
  pop_data <- Race %>%
    left_join(pop,by=c("category"="race")) %>%
    mutate(prop=(Count/population)*100)
  
  df <- df %>%
    mutate(month=month(date,label = T),
           year=year(date))
  
  
  allworld <- df %>%
    filter(year=="2020")%>%
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
    
    group_by(country,month) %>%
    filter(!is.na(confirmed)) %>%
    summarise(
      Confirmed = max(confirmed),
      Recovered = max(recovered),
      Deaths = max(deaths)
    ) %>%
    arrange(desc(Confirmed))
  
  
  
  a <-  allworld %>%
    group_by(country,month,
             life_expectancy,
             income,
             region,
             pop_density,
             population,
             gdp_capita) %>%
    filter(!is.na(confirmed)) %>%
    summarise(
      Confirmed = max(confirmed),
      Recovered = max(recovered),
      Deaths = max(deaths)
    ) %>%
    arrange(desc(Confirmed))
  a$id  <- 1:nrow(a)
  
  
  # map
  
  
  states <- here::here("data/us.geojson") %>% sf::st_read()
  
  positive_cases <- allstates %>%
    select(date, state, positive, positiveIncrease) %>%
    group_by(state) %>%
    filter(!is.na(positive)) %>%
    summarise(positive_cases = max(positive)) %>%
    ungroup() %>%
    mutate(sum = sum(positive_cases))
  
  f_statesabb <- statesabb %>%
    filter(jurisdiction_type == "state")
  
  positive_cases <- positive_cases %>%
    left_join(f_statesabb, by = c("state" = "state_abbr")) %>%
    filter(!is.na(state_name)) %>%
    select(state_name, positive_cases)
  
  plot2 <- allstates %>%
    left_join(f_statesabb, by = c("state" = "state_abbr")) %>%
    filter(!is.na(state_name))
  
  months_tests <- plot2 %>%
    mutate(month = month(date, label = T),
           monthnum = month(date)) %>%
    group_by(month, monthnum, state_name) %>%
    filter(!is.na(positive)) %>%
    summarise(
      tests = max(totalTestResults, na.rm = T),
      test_positive = max(positive, na.rm = T),
      test_negative = max(negative, na.rm = T)
    ) %>%
    mutate(month = as.character(month))
  
  list <- world %>%
    ungroup()%>%
    select(month)%>%
    distinct(month)
  
  
  
  #map

  
  
  library(leaflet)
  
  
  
  
  
  cmonth <- c("Jan", "Feb", "Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
cstate <-  as.list( positive_cases$state_name)



sinput <- function(id,label,choice){
  
  selectInput(id,label, choice)
  
  
}
   
printer <- function(id){
 print(id)
}

  
show <- function(id){
 return(id)
}
showname <- show(id)
  



  shinyApp(
    
  
  ui = fluidPage(
    
    fluidRow(
      sidebarLayout(
        sidebarPanel(
         
          if (showname=="monthname")
          {
          sinput(id,label,cmonth)}
          
          else 
          sinput(id,label,cstate)
          
        ),
        mainPanel (
          
          reactableOutput("table"),
          plotlyOutput("facetline"),
          plotOutput("chart")
          
        )
        
        
        ))
       

      
    ),
  
  
  
  server =function(input, output, session) {
    
  pr <-  printer(id)
    
   if (pr=="monthname")
   {
    
     output$table <- renderReactable({
       
       newworld <-   world %>%
         filter(month==input$monthname)%>%
         select(-month)
    reactable(
         newworld,
         resizable = TRUE,
         showPageSizeOptions = TRUE,
         onClick = "select",
         pagination = T,
         defaultSelected = 1,
         selection = "single",
         defaultSorted = "Confirmed",
         defaultSortOrder = "desc",
         defaultColDef = colDef(headerClass = "header", align = "left"),
         columns = list(
           country = colDef(
             name = "Country",
             width = 150,
             filterable = TRUE
           ) ,
           Confirmed = colDef(
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
           Recovered = colDef(
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
           Deaths = colDef(
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
     if (pr=="statename")
     {
       
       output$facetline <- renderPlotly({
         
         options(scipen = 999)
         figure <- months_tests %>% filter(state_name == input$statename) %>%
           
           ggplot(aes(x = reorder(month, monthnum), y = tests)) +
           geom_point(color = "steelblue") + xlab("Month") +
           scale_y_log10() +
           ylab("Cumulative Tests (log10)") + ggtitle("Total COVID-19 Tests") +
           theme_minimal() +
           theme(plot.title = element_text(hjust = 0.5))
         
         ggplotly(figure)
         
         
       })
     }
  
    
    
  
    
    
  }
  
  
  
  
  )
  
}

"selectin"


