shinyServer(function(input, output, session) {
    
resultado_escolha <- reactive({
  
  if (input$mod == "Random Forest"){
    resu1
  } else {
    resu2
  }
})
output$metricas <- renderDT({
    
    resultado <- resultado_escolha()
    
    # Métricas
    dt <- metrics(resultado, 
                  truth = NOTA, 
                  estimate = predicao,
                  options = "rmse")
    
    dt <- as.data.frame(dt)
    dt[,3] <- round(dt[,3],4)
    dt <- dt[,c(1,3)]
    names(dt) <- c("Métrica","Estimativa")
    dt
    
})
output$plot1 <- renderPlot({
  
  resultado <- resultado_escolha()
  
  cl <- makePSOCKcluster(2)
  registerDoParallel(cl)
  
  if (input$mod == "Random Forest"){
    
    p2 <- ggplot(resultado, aes(x = NOTA , y = predicao))+
      geom_point(alpha=0.25) +
      geom_abline(linetype = "dashed",col="red")+
      theme_light()+
      labs(y = "Nota final em matemática prevista", x = "Nota final em matemática")
    
    gridExtra::grid.arrange(p1_1,p2,ncol = 1)
    
  } else {
    
    p2 <- ggplot(resultado, aes(x = NOTA , y = predicao))+
      geom_point(alpha=0.25) +
      geom_abline(linetype = "dashed",col="red")+
      theme_light()+
      labs(y = "Nota final em matemática prevista", x = "Nota final em matemática")
    gridExtra::grid.arrange(p1_2,p2,ncol = 1)
  }
  
  stopImplicitCluster()
  
})
predicao1 <- eventReactive(input$but1,{
  
  questoes <- str_split(input$quest,",") %>% as.vector()
  questoes <- questoes[[1]] %>% as.numeric()
  questoes <- as.data.frame(t(questoes))

  names(questoes) <- c(paste0("Q0",1:45),"NOTA")
  
  questoes_rec_teste <- 
    recipe(NOTA ~ ., 
           data = questoes) %>% 
    step_center(-NOTA) %>% 
    step_scale(-NOTA) %>% 
    prep()
  
  questoes_2 <- bake(dados_rec_treino,
                     new_data = questoes)
  
  if(input$mod == "Random Forest"){
    
    predicao <- predict(modelo_rf, as.tibble(questoes_2))
    
  } else {
    
    predicao <- predict(modelo_xgboost, as.tibble(questoes_2))
  }
})
output$res <- renderInfoBox({
  
  predicao1 <- predicao1()
  
  infoBox(
    title = "Predição da nota final de matemática:",
    color = "navy",
    round(predicao1,2)
  ) 
  
})
output$res1 <- renderInfoBox({
  questoes <- str_split(input$quest,",")[[1]]
  real <- questoes[46]
  
  infoBox(
    title = "Nota média real:",
    color = "navy",
    real
  ) 
})

})