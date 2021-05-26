shinyServer(function(input, output,session) {
    
    graficos <- reactive({
        
        if(input$comparar == "Nada"){
            
            df <- rnorm(input$slider, mean = input$slider1,
                       sd = input$slider2)
            
            qplot(df, geom = 'blank') +   
                stat_function(fun = dnorm, n=input$slider,
                              args = list(mean = input$slider1,
                                          sd = input$slider2),
                              color = "red") +                      
                geom_histogram(aes(y = ..density..),
                               alpha = 0.4, fill = "cadetblue",
                               color = "white") +
                theme_minimal()+
                ggtitle("Histograma da Normal")+
                ylab("Densidade")+
                xlab("X")
            
        } else {
            
            k1 <- rnorm(input$slider, mean = input$slider1,
                        sd = input$slider2)
            k2 <- rnorm(input$slider, mean = input$num1,
                        sd = input$num2)
            df <- data.frame(valor = c(k1,k2), 
                            normal = rep(c("Escolhida","Comparada"),
                                         each = input$slider))
            df$normal <- as.factor(df$normal)
            
            ggplot(df,geom = 'blank') +
                geom_histogram(aes(x = valor, fill = normal, y = ..density..),
                               alpha = 0.4, color = "white") +
                theme_minimal()+
                ggtitle("Histograma das Normais comparadas")+
                labs(x = "X", y = "Densidade", fill = "Normal")
            
        }
    })

    output$plot1 <- renderPlot({
        
        graficos()

    })

})
