library(shiny)
library(plotly)

shinyUI(fluidPage(
        titlePanel("Plot Quarterly Approval Ratings of US Presidents"),
        sidebarLayout(
                sidebarPanel(
                        sliderInput("sliderYear", "Pick Minimum and Maximum Dates",
                                    as.Date("1945-01-01"), as.Date("1975-12-31"), value = c(as.Date("1945-01-01"), as.Date("1975-12-31")), timeFormat = "%Y", step = 30),
                        checkboxInput("show_xlab", "Show/Hide X Axis Label", value = TRUE),
                        checkboxInput("show_ylab", "Show/Hide Y Axis Label", value = TRUE),
                        textOutput("aveRating")
                        ),
                mainPanel(
                        plotlyOutput("plot1")
                )
        )
))