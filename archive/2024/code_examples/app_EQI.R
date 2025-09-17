library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(dplyr)
library(readr)
library(leaflet)
library(rnaturalearth)
library(sf)
library(summarytools)



# Define the UI
ui <- dashboardPage(
      dashboardHeader(title = "EQI"),
      dashboardSidebar(
        sidebarMenu(
          menuItem("Dataset Overview", tabName = "overview", icon = icon("info-circle")),
          menuItem("Map", tabName = "map", icon = icon("globe")),
          menuItem("Summary statistics", tabName = "analysis", icon = icon("chart-bar")),
          menuItem("Corruption in health care", tabName = "healthcare", icon = icon("line-chart")),
          selectInput("year_filter", "Select Year:", choices = c(2010, 2013, 2017, 2021, 2024), selected = 2010)
        )
      ),
      
      dashboardBody(
        tabItems(
          # Dataset Overview Tab
          tabItem(tabName = "overview",
                  fluidRow(
                    box(
                      width = 12,
                      title = "European Quality of Government Index (EQI)",
                      status = "info",
                      solidHeader = TRUE,
                      collapsible = TRUE,
                      p("The dataset used in this dashboard is the EQI-CATI Country Level dataset for the years 2010 to 2024."),
                      h4("Variables"),
                      p("info on variables"),
                      h4("Source"),
                      p("The dataset is sourced from the Quality of Government Institute's European Quality of Government Index (EQI). For more information, visit the ", 
                        tags$a(href = "https://www.gu.se/en/quality-government", "official website"), ".")
                    )
                  )
          ),
      tabItem(tabName = "map",
              fluidRow(
                box(width = 12,
                    selectInput("quality", "Select a Quality Variable:", choices = NULL),
                    leafletOutput("countryMap", height = 500))
              )
      ),
      tabItem(tabName = "analysis",
              fluidRow(
                box(width = 12,
                    selectInput("country", "Select a Country:", choices = NULL))
              ), 
              fluidRow(
                box(width = 12, verbatimTextOutput("summaryStats"))
              ),
              fluidRow(
                box(width = 12, plotOutput("timeseriesPlot", height = 400))
              )
      ),
      tabItem(tabName = "healthcare",
              fluidRow(
                box(width = 12, plotOutput("trendPlot1", height = 400))
              ),
              fluidRow(
                box(width = 12, plotOutput("trendPlot2", height = 400))
              )
      )
    )
  )
)

# Define the server logic
server <- function(input, output, session) {
  
  ## Set data through reactive function
  all_data <- reactive({
    read_csv("C:/Users/aurel/OneDrive/Documents/DataHandling/datahandling-lecture/materials/code_examples/qog_eqicati_long_24.csv") |> 
      select(cname, year, Ed_qual, Hel_qual, Law_qual, Helimpart1, Hel_ask)
  })
  
  
  # This reactive function filters the data from 'all_data' based on the user's selection for the year.
  # The 'req' function ensures that the 'year_filter' input exists and has a value before proceeding.

  filtered_data <- reactive({
    
    req(input$year_filter)
    
    all_data() |> 
      filter(year == input$year_filter)
  })
  
  
  # "Observe" watches the filtered_data for changes and updates the selectInput choices for '
  # country' and 'quality' based on the filtered data.
  observe({
    data <- filtered_data()
    updateSelectInput(session, "country", 
                      choices = unique(data$cname))
    updateSelectInput(session, "quality", 
                      choices = c("Ed_qual", "Hel_qual", "Law_qual"))
    updateSelectInput(session, "health_care", 
                      choices = c("Hel_qual", "Helimpart1", "Hel_ask"))
  })
  
  
  
  ## Create map
  output$countryMap <- renderLeaflet({
    req(filtered_data(), input$quality)
    
    # Load world polygons with rnaturalearth
    world <- ne_countries(continent = "europe", returnclass = "sf") |> 
      filter(name_en != "Russia") 
    
    # Prepare data for merging with polygons
    plot_data <- filtered_data() %>%
      group_by(cname) %>%
      summarize(value = mean(.data[[input$quality]], na.rm = TRUE)) %>%
      rename(name_long = cname)
    
    # Ensure compatibility of names between data and polygons
    world <- world %>%
      left_join(plot_data, by = c("name_long"))
    
    palette <- colorBin("RdYlGn", domain = world$value, bins = 5, na.color = "transparent")
    
    # Create the interactive map
    leaflet(world) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~palette(value),
        weight = 1,
        color = "black",
        fillOpacity = 0.7,
        popup = ~paste0("<strong>", name_long, "</strong><br/>Value: ", round(value, 2))
      ) %>%
      addLegend(
        pal = palette,
        values = world$value,
        position = "bottomright",
        title = paste("Values of", input$quality),
        opacity = 0.7
      ) %>%
      # Set initial view to center Europe
      setView(lng = 10, lat = 50, zoom = 4) %>%
      # Constrain the map to Europe bounds
      fitBounds(lng1 = -25, lat1 = 35, lng2 = 45, lat2 = 70)
  })
  
  
  # Create summary statistics using the summarytools package
  output$summaryStats <- renderPrint({
    req(all_data(), input$country)
    
    selected_data <- all_data() |> 
      filter(cname == input$country)
    
    dfSummary(selected_data)
  })
  
  
  # Evolution of perceived quality over time
  output$timeseriesPlot <- renderPlot({
    
    req(all_data(), input$country)
    
    selected_data <- all_data()  |>
      filter(cname == input$country) |>
      select(year, Ed_qual, Hel_qual, Law_qual) |>
      pivot_longer(cols = c(Ed_qual, Hel_qual, Law_qual), names_to = "quality", values_to = "value")
      
    
    ggplot(selected_data, aes(x = as.factor(year), y = value, color = quality, group = quality)) +
      geom_point() +
      geom_line(size = 1) +
      theme_classic() +
      scale_color_brewer(palette = "Set2") + 
      labs(title = "Perceived quality over time", x = "Year", y = "Quality") 
  })
  
  
  
  output$trendPlot1 <- renderPlot({
    
    req(filtered_data())
    
    filtered_data() |> 
      ggplot( aes(x = Hel_qual, y = Helimpart1)) +
      geom_point() +
      geom_smooth(method = "lm") +
      theme_classic() +
      labs(title = paste("Correlation Perceived Quality of public health care system and perceived corruption in the health care system"), 
           x = "Perceived Health Quality", 
           y = "Helimpart1",
           caption = "Helimpart1: 'Certain people are given special advantages in the public health care system in my area.'") +
      scale_y_continuous(limits = c(3, 8))
  })
  
  output$trendPlot2 <- renderPlot({
    
    req(filtered_data())
    
    filtered_data() |> 
      ggplot(aes(x = Hel_qual, y = Hel_ask)) +
      geom_point() +
      geom_smooth(method = "lm", color = "red") +
      theme_classic() +
      labs(title = paste("Correlation Perceived Quality of public health care system and share of corruption in the health care system"), 
           x = "Perceived Health Quality", 
           y = "Hel_ask",
           caption = "Hel_ask: 'In the last 12 months, have you or anyone in your family been asked by a public official to give an informal gift or bribe in health or medical services?'") +
      scale_y_continuous(limits = c(-0.1, 0.2)) +
      geom_hline(yintercept = 0, linetype = 2, color = "grey50")
  })
}

shinyApp(ui, server)
