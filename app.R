library(shiny)

# Define UI ----
ui <- fluidPage(
  titlePanel("Wine Review"),
  
  fluidRow(
    
    column(3, 
           textInput("text", h3("Wine Taster Name"), 
                     value = "Enter text..."))  ,
    
    column(3, 
           textInput("text", h3("Winery Name"), 
                     value = "Enter text..."))  ,
    
    column(3,
           selectInput("select", h3("Variety"), 
                       choices = list("Pinot Noir" = 1, "Merlot" = 2,
                                      "Red Blend" = 3), selected = 1))  ,
    
    column(3, 
           dateInput("Date of Production", 
                     h3("Date input"), 
                     value = "2014-01-01"))   
  ),
  
  fluidRow(
    
    column(3,
           selectInput("select", h3("Country"), 
                       choices = list("India" = 1, "US" = 2,
                                      "France" = 3), selected = 1)) ,
    
    
    column(3, 
           
           sliderInput("Price Range", "",
                       min = 0, max = 100000, value = c(25, 75))
  ),
  
  fluidRow(
    
    column(3,
           selectInput("select", h3("Province"), 
                       choices = list("Washington" = 1, "California" = 2,
                                      "Nashik" = 3), selected = 1)),
    
    column(3,
           selectInput("select", h3("Region 1"), 
                       choices = list("Sonoma Valley" = 1, "California" = 2,
                                      "Columbia Valley" = 3), selected = 1)),
    column(3,
           selectInput("select", h3("Region 2"), 
                       choices = list("Columbia Valley" = 1, "N/A" = 2,
                                      "Sonoma" = 3), selected = 1))
    ),
    
  column(3, 
         numericInput("num", 
                      h3("Points for the wine"), 
                      value = 1))     
  )
  
)

# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)