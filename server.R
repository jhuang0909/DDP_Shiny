library(shiny)
library(plotly)
library(zoo)

presidents <- get("presidents", "package:datasets")
presidents.df <- data.frame(rating=as.matrix(presidents), date=as.Date(time(presidents)))
getSubset <- function(minY, maxY) {
                        # Need to cover at least two valid ratings
                        subset <- presidents.df %>% filter(date >= minY & date <= maxY & !is.na(rating))
                        return(subset)
                }                

shinyServer(function(input, output) {
                minY <- min(presidents.df$date)
                maxY <- max(presidents.df$date)

                dfSubset <- reactive({
                        minY <- input$sliderYear[1]
                        maxY <- input$sliderYear[2]
                        subset <- getSubset(minY, maxY)
                        validate(
                                need(nrow(subset) > 0, "Please select a valid time range")
                        )
                        return(subset)
                })
                
                output$plot1 <- renderPlotly({
                        presidents.df.subset <- dfSubset()
                        
                        minRatings <- presidents.df.subset[which(presidents.df.subset$rating == 
                                        min(presidents.df.subset$rating, na.rm = TRUE)),]
                        maxRatings <- presidents.df.subset[which(presidents.df.subset$rating == 
                                        max(presidents.df.subset$rating, na.rm = TRUE)),]
                        xlab <- "Year"
                        ylab <- ifelse(input$show_ylab, "Approval Ratings", "")
                        plot_ly(data = presidents.df.subset, x = ~date, showlegend = FALSE) %>% 
                                layout(yaxis = list(title = ylab), 
                                       xaxis = list(title = xlab)) %>%
                                add_lines(y = ~rating, 
                                          name = "",
                                          line = list(color = "#00526d", width = 4)) %>%
                                add_markers(x = minRatings$date,
                                            y = minRatings$rating,
                                            name = "Minimum Rating",
                                            marker = list(size = 15, color = "#f44141")) %>%
                                add_markers(x = maxRatings$date,
                                            y = maxRatings$rating,
                                            name = "Maximum Rating",
                                            marker = list(size = 15, color = "#42f445"))
                })
        
                output$aveRating <- renderText({ 
                        if(input$show_aveRating) {
                                presidents.df.subset <- dfSubset()
                                paste0("Average Rating = ", sprintf("%.2f",mean(presidents.df.subset$rating, na.rm = TRUE)))
                        }
        })
})