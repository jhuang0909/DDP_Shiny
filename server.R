library(shiny)
library(plotly)
library(zoo)

shinyServer(function(input, output) {
                presidents.df <- data.frame(rating=as.matrix(presidents), date=as.Date(time(presidents)))
                output$plot1 <- renderPlotly({
                        minY <- input$sliderYear[1]
                        maxY <- input$sliderYear[2]
                        presidents.df.subset <- presidents.df %>% 
                                filter(date >= minY & date <= maxY)
                        minRatings <- presidents.df.subset[which(presidents.df.subset$rating == 
                                        min(presidents.df.subset$rating, na.rm = TRUE)),]
                        maxRatings <- presidents.df.subset[which(presidents.df.subset$rating == 
                                        max(presidents.df.subset$rating, na.rm = TRUE)),]
                        xlab <- ifelse(input$show_xlab, "Year", "")
                        ylab <- ifelse(input$show_ylab, "Approval Ratings", "")
                        plot_ly(data = presidents.df.subset, x = ~date, showlegend = FALSE) %>% 
                                layout(yaxis = list(title = ylab), 
                                       xaxis = list(title = xlab)) %>%
                                
                                add_lines(y = ~rating, 
                                          line = list(color = "#00526d", width = 4)) %>%
                                add_markers(x = minRatings$date,
                                            y = minRatings$rating,
                                            marker = list(size = 15, color = "#f44141")) %>%
                                add_markers(x = maxRatings$date,
                                            y = maxRatings$rating,
                                            marker = list(size = 15, color = "#42f445"))
                })
        
        output$aveRating <- renderText({ 
                subset <- presidents.df %>% filter(date >= input$sliderYear[1] & date <= input$sliderYear[2])
                paste0("Average rating is ", sprintf("%.2f",mean(subset$rating, na.rm = TRUE)))
        })
})