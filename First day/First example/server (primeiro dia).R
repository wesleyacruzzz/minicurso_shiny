shinyServer(function(input, output) {
    
    formulaText <- reactive({
        paste("mpg ~", input$var)
    })
    
    output$formula <- renderText({
        formulaText()
    })
    
    output$mpgPlot <- renderPlot({
        boxplot(as.formula(formulaText()), 
                data = mpgData,
                outline = input$outliers)
    })
})