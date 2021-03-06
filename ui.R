library(shiny)
library(plotly)

shinyUI(fluidPage(
        
        tags$head(
                tags$style(HTML("
                      .shiny-output-error-validation {
                        color: green;
                      }
                    "))
        ),
        
        titlePanel("Plot Quarterly Approval Ratings of US Presidents"),
        
        sidebarLayout(
                sidebarPanel(
                        sliderInput("sliderYear", "Pick Minimum and Maximum Dates",
                                    as.Date("1945-01-01"), as.Date("1974-10-01"), value = c(as.Date("1945-01-01"), as.Date("1974-10-01")), timeFormat = "%Y", step = 100),
                        checkboxInput("show_aveRating", "Show/Hide Average Rating", value = TRUE),
                        textOutput("aveRating")
                        ),
                mainPanel(
                        wellPanel(plotlyOutput("plot1")),
                        wellPanel(h4('README'),p('This Shiny application demonstrates the approval ratings of US predisents between 1945 and 1975.  The raw data is from the R Datasets Package.  Using the slidebar, you may choose any date range between 1945 and 1975.  The Shiny server will automatically show the rating trace for the given range in a Plotly plot, the min and max are also marked.  The average rating may be shown in a text box based on whether Show/Hide checkbox is checked.'))
                )
        )
))