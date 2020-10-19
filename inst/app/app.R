

allstates <- readr::read_csv(here::here("extdata/allstates.csv"))
statesabb <- USAboundaries::state_codes
ccode <- readr::read_csv(here::here("extdata/codes.csv"))
Gender <- readr::read_csv(here::here("extdata/gender.csv"))
Age <- readr::read_csv(here::here("extdata/agegroups.csv"))
Race <- readr::read_csv(here::here("extdata/race.csv"))
df <- tidycovid19::download_merged_data(cached = TRUE, silent = TRUE)

df$country<- dplyr::recode(df$country,
                    "Curaçao"="Curacao",
                    "Côte d’Ivoire"="Cote dIvoire")
cols2 <- c("#233d4d", "#fe7f2d", "#fcca46","#a1c181","#083d77","#513b56","#98ce00","#348aa7","#840032","#db3a34")


Gender <- Gender %>%
  rename(category = Sex)
Age <- Age %>%
  rename(category = "Age Group")
Race <-  Race %>%
  rename(category = `Race/Ethnicity`)

choices <- c("Gender", "Age", "Race")

pop <- read_csv(here::here("extdata/pop.csv"))

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


states <- here::here("extdata/us.geojson") %>% sf::st_read()

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

pal <- leaflet::colorNumeric("viridis", domain = states$density)
labels <- sprintf("<strong>%s</strong><br/>%g Cases",
                  states$name,
                  states$density) %>% lapply(htmltools::HTML)






map <- leaflet::leaflet(states, options = leafletOptions(minZoom = 3)) %>%
  setView(-110.233256, 40, 4) %>%
  addProviderTiles("MapBox",
                   options = providerTileOptions(
                     id = "mapbox.light",
                     accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')
                   )) %>%
  
  addPolygons(
    fillColor = ~ pal(density),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE
    ),
    label = labels,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto"
    )
  ) %>%
  addLegend(
    pal = pal,
    values = ~ density,
    opacity = 0.9,
    title = "Positive Cases",
    position = "bottomright"
  )


ui <- fluidPage(

  navbarPage(
    theme = shinytheme("superhero"),
    "COVID-19 in United States",
    id = "main",tabPanel("About",fluidRow(
      h2("About the App"),
      h3("Creater : Aarathy Babu"),
      fluidRow(
        align="center",width="450px",
        img(src = "picture.png", width = "450px", height = "250px" ,alt="Image Source: The Economic Times",style="text-align: center;"),
        verbatimTextOutput("source")),
      br(),
      p("This Shiny App aims to showcase an overview of the data on COVID-19 on a global scale and explores the test results as well as different dimensions of the effect of the pandemic in the United States of America.The different dimensions include the demographic patterns such as Age,Gender and Race in the affected cases.
           In order to make navigation easier,suggestions are provided throughout the course of App. The data is mainly sourced from the tidycovi19 R package ,The COVID Tracking Project and Centers for Disease Control and Prevention, COVID-19 Response Database. The COVID-19 data discussed through the app has the list of cases and it's related informated,from January till October 2020.",
        style = "text-align:justify;color:black;background-color:white;padding:50px;border-radius:20px"
      ),
      br()
    )),
    
    tabPanel(
      "World",
      fluidRow(
        sidebarLayout(
          sidebarPanel(h3("COVID-19 Cases Worldwide"),
                       sinput(
                         "monthname",
                         "Select Month",
                         list$month
                       ), 
                       br(),p(
                         "The interactive table represents the worldwide COVID-19 cases,deaths and recoveries each month and allows the user to search for the country and month of their choice \n as well as arrange them in the order using the parameters of their choice. For example, Confirmed Cases.\n User can also view some information like life expectancy, population density etc on the countries by selecting them.",
                         style = "text-align:justify;color:black;background-color:white;padding:15px;border-radius:15px"
                       ),
                       br(),
                       br(),p(
                         "The year 2020 began with China having the most number of COVID-19 but as the year progresses it can be seen that confirmed cases in China reduced where as countries like United States, Brazil, India rose to the top.",
                         style = "text-align:justify;color:black;background-color:white;padding:15px;border-radius:15px"
                       ),
                       br()
          ),
          mainPanel( 
            
            reactableOutput("table"),
            h4("Some Info on the Selected Country"),
            verbatimTextOutput("selected")
          )))
    ),
    navbarMenu(
      "USA",
      tabPanel(
        "COVID-19 Testing",
        headerPanel("Coronavirus in United States"),
        fluidRow(

          leafletOutput("leafmap", height = "600px")),
        fluidRow(
          column(6,
            sinput(
              "statename",
              "Select State",
              positive_cases$state_name 
            ),
            br(),
            p("The interactive map showcases the total number of positive cases in each state of United States by hovering over each state where as the point graph depicts the COVID-19 tests conducted in each state during a month.The user can see the percentage of positive cases in that state and during a particular month by clicking on its corresponding point and choosing a state.",
              style = "text-align:justify;color:black;background-color:white;padding:15px;border-radius:15px"  ),
            br(),
            
            plotlyOutput("facetline")),
          column(6,
                 plotlyOutput("sub_category"),
            br(),
            p("In US, California has the most number of COVID-19 positive cases, followed by Texas and Florida.Since the occurence of first COVID-19 positive case, the US states started testing more throughout the months.",
              style = "text-align:justify;color:black;background-color:white;padding:15px;border-radius:15px"  ),
            br(),
            verbatimTextOutput("tests")
            #verbatimTextOutput("info"),
           
          )
        )# sidelayout
      ),
      tabPanel(
        "Demographic Trends",
        headerPanel("Demographic Trends in COVID-19 Positive Cases"),
        sidebarLayout(sidebarPanel(
          br(),p(
            "The chart represents the gender,racial identity as well as the age group under which the COVID-19 positive patients fall. The User can explore by selecting a demographic parameter of their choice.",
            style = "text-align:justify;color:black;background-color:white;padding:15px;border-radius:15px"
          ),
          br()
          
        ),
        mainPanel(
          sinput("dataset", "Select a parameter", as.list(choices)),
          plotOutput("chart"),
          verbatimTextOutput("second"),
          plotOutput("secondplot")))
      )),
    
    tabPanel("References",
             includeMarkdown(here::here("extdata/about.md")))
    
    
    ,
    includeCSS(here::here("extdata/style.css"))
    
  )
)



server <- function(input, output, session) {
  
 
  
  output$source<- renderText({
    source <- printext("Image Source: The Economic Times")
    source})
  
  output$table <- renderReactable({
    
    newworld <-   world %>%
      filter(month==input$monthname)%>%
      select(-month)
    reactable::reactable(
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
  
  selected <- reactive(getReactableState("table", "selected"))
  
  
  output$selected <- renderText({
    
    
    a <-  allworld%>%
      
      filter(month==input$monthname)%>%
      group_by(country,
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
    
    
    num <- selected()
    region <- choosedat(a,num,"region")
    popdensity <- choosedat(a,num,"pop_density")
    popu <- choosedat(a,num,"population")
    countryname <-choosedat(a,num,"country")
    countrynlife <- choosedat(a,num,"life_expectancy")
    countrygdp <- choosedat(a,num,"gdp_capita")
    textregion <-
      paste(
        "The selected country,",
        countryname$country,
        "belongs to the region :",
        region$region,
        ".\nAccording to World Bank,as of 2018 the country has a population and a population density of ",
        popu$population,
        "and ",
        round(popdensity$pop_density, 2),
        " people per sq.km respectively.\nThe life expectancy of the country is ",
        round(countrynlife$life_expectancy, 2),
        " where as the GDP per capita is ",
        round(countrygdp$gdp_capita, 2)
      )
    
    
    textregion
    
  })
  
  output$leafmap <- renderLeaflet({
    map
    
  })
  
  
  output$facetline <- renderPlotly({
    options(scipen = 999)
    figure <-
      months_tests %>% filter(state_name == input$statename) %>%
      
      ggplot(aes(x = reorder(month, monthnum), y = tests)) +
      geom_point(color = "steelblue") + xlab("Month") +
      scale_y_log10() +
      ylab("Cumulative Tests (log10)") + ggtitle("Total COVID-19 Tests") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5))
    
    plotly::ggplotly(figure)
    
  })
  output$tests <- renderText({
    d <- event_data("plotly_click")
    if (is.null(d))
      return(NULL)
    
    printext("Out of all the tests conducted each month, the percentage of COVID-19\nnegative cases is more than that of positive cases.This shows that not all people who show\nsymptoms or come in risk of COVID-19 tests positive.")
    
    
  })
  
  output$sub_category <- renderPlotly({
    d <- event_data("plotly_click")
    if (is.null(d))
      return(NULL)
    
    data <- months_tests %>%
      filter(state_name == input$statename)
    
    data$id = seq.int(nrow(data))
    
    
    data <- data %>%
      mutate(
        positive = (test_positive / (test_positive + test_negative) * 100),
        negative = (test_negative / (test_negative + test_positive) *
                      100)
      ) %>%
      pivot_longer(cols = 8:9,
                   names_to = "covid",
                   values_to = "result")
    
    
    fig2 <-   data %>%
      filter(id %in% d$x) %>%
      ggplot(aes(
        x = reorder(month, id),
        y = result,
        fill = covid
      )) +
      geom_col(position = "dodge") + xlab("Month") +
      ylab("Percentage of Tests") + ggtitle("COVID-19 Tests Results") +
      scale_fill_manual(values = cols2)+
      ylim(0, 100) +
      theme(plot.title = element_text(hjust = 0.5)) 
    ggplotly(fig2)
  })
  
  
  
  output$chart <- renderPlot({
    dataset <- get(input$dataset)
    
      dataset %>%
      ggplot(aes(y=reorder(category,Percentage), x=Percentage,fill=category)) +
      geom_col()+
      scale_fill_manual(values = cols2)+
      theme(legend.position = "top",
            panel.background = element_rect(fill = "#edf2fb",
                                            color = "black", size = 1))+
      
      labs(title = "Race & Ethnicity of COVID-19 positive patients")+
      theme(plot.title = element_text(hjust = 0.5,face="bold", size=18))+
      ylab("\nRace & Ethnicity")+
      xlab("Percentage \n") +
      
     # theme(text = element_text(family = "segoe_font"))+
      theme(plot.background = element_rect(fill = "#edf2fb"))
    
    
  })
  
  output$second<- renderText({
    dataset <- get(input$dataset)
    
    if(all.equal(dataset,Race)==TRUE)(
      printext("People of White Non-Hispanic seem to be more among the COVID-19 positive cases but does this mean,\nWhite race is more affected by this pandemic? No.The white population constitute around 60 % of USA's population.\nThe chart below depicts the intensity of COVID-19 among each diverse population.\nIt can be seen that around 2% of Native Hawaiian community and\nmore than 1% each of Latino and Black community got more affected by COVID-19 compared to White community where\nless than 0.75% people were affected")
    )else if(all.equal(dataset,Gender)==TRUE)
      (
        printext("Among the COVID-19 positive patients,number of Females is slightly higher than that of men.")
        
      )
    else if(all.equal(dataset,Age)==TRUE)
      (
        printext("Around 23 % the COVID-19 positive cases are people between the age 18-29 years of age where as\naround 20% of the cases are of people of age group 50-64.")
        
      )

  })
  output$secondplot <- renderPlot({
    dataset <- get(input$dataset)
    
      if(all.equal(dataset,Race)==TRUE)(
        pop_data %>%
        ggplot(aes(y=reorder(category,prop), x=prop,fill=category)) +
        geom_col()+
        scale_fill_manual(values = cols2)+
        theme(legend.position = "top",
              panel.background = element_rect(fill = "#edf2fb",
                                              color = "black", size = 1))+
        
        labs(title = "Intensity of COVID-19 in different Ethnic groups")+
        theme(plot.title = element_text(hjust = 0.5,face="bold", size=18))+
        ylab("\nRace & Ethnicity")+
        xlab("Percentage \n") +
        
       # theme(text = element_text(family = "segoe_font"))+
        theme(plot.background = element_rect(fill = "#edf2fb"))
    )
    else return(NULL)
    
  })
  
  
}

# Run the application
shinyApp(ui = ui, server = server)
