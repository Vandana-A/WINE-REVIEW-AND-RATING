## ui.R ##

library(shiny)
library(shinydashboard)
library(shinyjs)
library(DBI)
con <- dbConnect(odbc::odbc(), "winebottlereview", timeout = 10)

ui <- dashboardPage(skin = "purple",
                    dashboardHeader(title = "Wine Ratings - Visualized", ###########
                                    titleWidth = 275
                    ), #end header  
                    ## -- SIDEBAR: ######################
                    dashboardSidebar(   
                      width = 275,
                      div(img(src = "bottles.jpeg"), style="text-align: center;"),
                      sidebarMenu(
                        menuItem("Background", tabName = "background", icon = icon("leaf")),
                        menuItem("New Rating",tabName = "newRating", icon = icon("leaf")),
                        menuItem("Ratings vs. Price", tabName = "ptsPrice", icon = icon("leaf")),
                        menuItem("Compare Countries & Varietals", tabName = "barPlot", icon = icon("leaf")),
                        menuItem("Wine Selector", tabName = "wineChooser", icon = icon("leaf")),
                        menuItem("Top Varietal by Region", tabName = "wineRegions", icon = icon("leaf"))
                      ) #end sidebarMenu
                    ), #end sidebar
                    ## -- BODY: ######################
                    dashboardBody(
                      tabItems(
                        ## -- FIRST TAB: ######################
                        tabItem(tabName = "background",
                                div(img(src = "grapes2.jpeg"), style="text-align: center;"),
                                fluidRow(
                                  box(
                                    h2("Background", style="text-align: center;"),
                                    
                                    br(),
                                    h4("* Over 120,000 reviews, 20 different wine tasters"),
                                    h4("* More than 110,000 different wines from 42 countries"),
                                    h4("* Ratings ranged between 80-100 points"),
                                    h4("* Wines priced at $4-$3300 per bottle"),
                                    br(),
                                    h4("Motivation: "),
                                    h5(" - To investigate the relationship between a wine's 
                            rating and its price, origin, and varietal"),
                                    br(),
                                    h5("Sources: ",uiOutput("WineMag")),
                                    h5(uiOutput("Kaggle")), width = 12
                                  )
                                )
                        ), #end 1st tab
                        
                        
                        ##Form Tab
                        
                        
                        
                        ## -- NEW RATING TAB: ######################
                        tabItem(useShinyjs(),tabName = "newRating",
                                h3("Submit a new rating!"),
                                
                                fluidRow(
                                  column(4, 
                                         textInput("winery_id", "Winery Id:"),
                                         textInput("winery", "Winery Name:"),
                                         textInput("variety", "Variety:"),
                                         textInput("designation", "Designation:"),
                                         textInput("year", "Year:", value = ""),
                                         textInput("country", "Country:"),
                                         textInput("province", "Province:", value = ""),
                                         textInput("region_1", "Region 1:", value = ""),
                                         textInput("region_2", "Region 2:", value = ""),
                                         numericInput("price", "Price:", value = ""),
                                         textInput("price_range", "Price Range:", value = ""),
                                         textInput("taster_name", "Taster Name:", value = ""),
                                         numericInput("points", "Points:", value = ""),
                                         numericInput("point_range", "Point Range:", value = ""),
                                         textInput("rating", "Rating:", value = ""),
                                         numericInput("model_score", "model_score", value = ""),
                                         actionButton("submit", "Submit")
                                  ),
                                  column(8,
                                         verbatimTextOutput("status")
                                  )
                                )
                        ),
                        
                        
                        ## -- SECOND TAB: ######################
                        tabItem(tabName = "ptsPrice", 
                                h3("Do Wine Ratings Correlate with Price?"),
                                
                                fluidRow(
                                  box(plotOutput("plot1", height = 250),  #plot pts vs. price
                                      plotOutput("plot2", height = 250), width = 12) #plot pts vs. log(price)
                                )
                        ), #end 2nd tab
                        
                        ## -- THIRD TAB: ######################
                        tabItem(tabName = "barPlot", 
                                h3("Compare Popular Varietals from the Top 5 Wine-Producing Countries"),
                                fluidRow(
                                  box(
                                    # radioButtons("swapPlot",
                                    #              label = "Choose a graph:",
                                    #              choices = list("Varietal vs. Average Rating" = 1,
                                    #                             "Varietal vs. Median Price" = 2),
                                    #              selected = 1,
                                    #              inline = TRUE),
                                    checkboxGroupInput("pickVar",
                                                       label = "Choose varietal(s) to compare:",
                                                       choices = sort(top_varieties[1:10]),
                                                       selected = sort(top_varieties[1:10])), width = 2
                                  ),
                                  box(
                                    plotOutput("barGraph1", height = 550),width = 5),
                                  box(
                                    plotOutput("barGraph2", height = 550),width = 5
                                  ))
                        ), #end 3rd tab
                        
                        ## -- FOURTH TAB: ######################
                        tabItem(tabName = "wineChooser", 
                                h3("Top 20 Highest-Rated Wines Based on Price Range and Varietal"),
                                fluidRow(
                                  box(
                                    selectInput("varietal", 
                                                label = "Choose a varietal:",
                                                choices = top_var,
                                                selected = "All"),
                                    
                                    radioButtons("pricerange", 
                                                 label = "Select a price range:",
                                                 choices = list(#"Any" = 0,
                                                   "< $10" = 1, 
                                                   "$10 - $25" = 2, 
                                                   "$25 - $50" = 3,
                                                   "$50 - $100" = 4, 
                                                   "$100 - $500" = 5, 
                                                   "> $500" = 6), 
                                                 selected = 1),
                                    checkboxGroupInput("pointcategory",
                                                       label = "Select desired rating(s):",
                                                       choices = list("Classic",
                                                                      "Superb",
                                                                      "Excellent",
                                                                      "Very Good",
                                                                      "Good",
                                                                      "Acceptable"),
                                                       selected = list("Classic",
                                                                       "Superb",
                                                                       "Excellent",
                                                                       "Very Good",
                                                                       "Good",
                                                                       "Acceptable")),
                                    width = 2, 
                                    height = 600),
                                  box(
                                    DT::dataTableOutput("selected_wines"), width = 10 
                                  )
                                )
                        ), #end 4th tab
                        
                        ## -- FIFTH TAB: ######################
                        tabItem(tabName = "wineRegions", 
                                h3("Average Rating for the Most Popular Varietal Produced by Each Region:"),
                                fluidRow(
                                  box(htmlOutput("map"), width = 12 )
                                ),
                                fluidRow(
                                  box(htmlOutput("map2"), width = 12)
                                )
                        )
                      ) #end tabItems #####
                    ) #end Body 
) #end Page





# Connect to the database
#con <- dbConnect(MySQL(), 
#                 host = "127.0.0.1", 
#                 user = "root", 
#                 password = "1234", 
#                 dbname = "wine")

# Define the UI

# Define the server logic
server <- function(input, output, session) {
  
  options(shiny.allowUnsafeServer = TRUE)
  options(shiny.allowHTML = TRUE,
          shiny.use_data = TRUE)
  
  
  
  # JavaScript code for validations
  jscode <- "
  // Validation function for Winery Name
  shinyjs.validateWineryName = function(params) {
    var value = document.getElementById(params.inputId).value;
    if (value.trim() === '') {
      return 'Please enter Winery Name';
    }
  }
  
  // Validation function for Variety
  shinyjs.validateVariety = function(params) {
    var value = document.getElementById(params.inputId).value;
    if (value.trim() === '') {
      return 'Please enter Variety';
    }
  }
  
  // Validation function for Designation
  shinyjs.validateDesignation = function(params) {
    var value = document.getElementById(params.inputId).value;
    if (value.trim() === '') {
      return 'Please enter Designation';
    }
  }
  
  // Validation function for Country
  shinyjs.validateCountry = function(params) {
    var value = document.getElementById(params.inputId).value;
    if (value.trim() === '') {
      return 'Please enter Country';
    }
  }
  
  // Validation function for Year
  shinyjs.validateYear = function(params) {
    var value = document.getElementById(params.inputId).value;
    if (value.trim() === '') {
      return 'Please enter Year';
    } else if (isNaN(value)) {
      return 'Please enter a valid Year';
    } else if (value < 1800 || value > 2100) {
      return 'Year should be between 1800 and 2100';
    }
  }
  
  // Validation function for Points
  shinyjs.validatePoints = function(params) {
    var value = document.getElementById(params.inputId).value;
    if (value.trim() === '') {
      return 'Please enter Points';
    } else if (isNaN(value)) {
      return 'Please enter a valid Points';
    } else if (value < 0 || value > 100) {
      return 'Points should be between 0 and 100';
    }
  }
  
  // Validation function for Rating
  shinyjs.validateRating = function(params) {
    var value = document.getElementById(params.inputId).value;
    if (value.trim() === '') {
      return 'Please enter Rating';
    } else if (isNaN(value)) {
      return 'Please enter a valid Rating';
    } else if (value < 0 || value > 5) {
      return 'Rating should be between 0 and 5';
    }
  }
  
  // Validation function for Winery ID
  shinyjs.validateWineryID = function(params) {
    var value = document.getElementById(params.inputId).value;
    if (value.trim() === '') {
      return 'Please enter Winery ID';
    } else if (isNaN(value)) {
      return 'Please enter a valid Winery ID';
    }
  }
  
  // Validation function for Province
  shinyjs.validateProvince = function(params) {
    var value = document.getElementById(params.inputId).value;
    if (value.trim() === '') {
      return 'Please enter Province';
    }
  }
  "
  
  # Reactive input fields
  
  winery <- reactive({
    input$winery
  })
  
  variety <- reactive({
    input$variety
  })
  
  designation <- reactive({
    input$designation
  })
  
  country <- reactive({
    input$country
  })
  
  year <- reactive({
    as.integer(input$year)
  })
  
  points <- reactive({
    as.integer(input$points)
  })
  
  rating <- reactive({
    input$rating
  })
  
  winery_id <- reactive({
    input$winery_id
  })
  
  province <- reactive({
    input$province
  })
  
  region_1 <- reactive({
    input$region_2
  })
  
  region_2 <- reactive({
    input$region_2
  })
  
  taster_name <- reactive({
    input$taster_name
  })
  
  price_range <- reactive({
    as.integer(input$price_range)
  })
  
  price <- reactive({
    as.integer(input$price)
  })
  
  point_range <- reactive({
    as.integer(input$point_range)
  })
  
  model_score <- reactive({
    as.integer(input$model_score)
  })
  
  
  # Write the data to the database
  observeEvent(input$submit, {
    data <- data.frame(winery_id = winery_id(),
                       winery = winery(),
                       variety = variety(),
                       designation = designation(),
                       country = country(),
                       year = year(),
                       points = points(),
                       rating = rating(),
                       province = province(),
                       region_1 = region_1(),
                       region_2 = region_2(),
                       price = price(),
                       price_range = price_range(),
                       taster_name = taster_name(),
                       point_range = point_range(),
                       model_score = model_score()
    )
    dbWriteTable(con, "datadata", data, overwrite = FALSE, append = TRUE)
    output$status <- renderText("Data submitted successfully!")
  })
}

# Run the shiny app
shinyApp(ui, server)


