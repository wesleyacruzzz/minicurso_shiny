shinyServer(function(input, output) {
    
    dados_reativos <- reactiveValues(soma = 0, x = NULL, y = NULL)
    
    observe({
        req(input$plot_click)
        isolate(dados_reativos$soma <- dados_reativos$soma + 1)
        dados_reativos$x <- input$plot_click$x
        dados_reativos$y <- input$plot_click$y
        
    })
    
    dados <- reactive({
        x1 <- c(df$x,dados_reativos$x)
        y1 <- c(df$y,dados_reativos$y)
        
        Pp <- ifelse(y1[2] > input$linha, "Passou","Não Passou")
        isolate(df[dados_reativos$soma+1,] <- c(x1[2],y1[2],Pp))
    })
    
    eventReactive(input$ref,{
        df <- data.frame(x = NA, y = NA, P = NA)
        df$P <- as.factor(df$P)
        levels(df$P) <- c("Passou", "Não Passou")
        isolate(df)
    })
    
    output$plot1 <- renderPlot({
        
        df2[dados_reativos$soma+1,] <<- dados()
        df3 <<- na.omit(rbind(df2,df3))
        
        ggplot(df3,
               aes(x = as.numeric(x), y = as.numeric(y)))+
            geom_point()+
            geom_line()+
            geom_hline(yintercept = input$linha, linetype = 2,
                       col = "red")+
            labs(x = "", y = "")+
            ylim(0,20)+
            xlim(0,20)+
            theme_light()
        
    })
    
    output$plot2 <- renderPlot({
      
      df2[dados_reativos$soma+1,] <<- dados()
      df3 <<- na.omit(rbind(df2,df3))
      df4 <- dplyr::distinct(df3)
      
      ggplot(df4)+
        geom_bar(aes(x = as.factor(P),fill = P))+
        scale_fill_manual(values = c("red","blue"))+
        labs(x= " ", y = " ", fill = "Resultado")+
        theme_light()
    })
})
